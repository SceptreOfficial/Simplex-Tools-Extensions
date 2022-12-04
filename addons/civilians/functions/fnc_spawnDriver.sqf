#include "script_component.hpp"

_thisArgs params ["_area","_blacklist","_unitClasses","_vehicleClasses","_customInit","_customArgs","_ambCiv"];

if (_ambCiv && {isNull _customArgs}) exitWith {};
	
private "_randPos";
while {
	_randPos = [_area,false] call CBA_fnc_randPosArea;
	surfaceIsWater _randPos || (_blacklist findIf {_randPos inArea _x}) != -1
} do {};

private _roads = (_randPos nearRoads 325) select {
	private _road = _x;
	_blacklist findIf {_road inArea _x} isEqualTo -1
};

private _road = [_randPos,_roads] call EFUNC(common,getNearest);
private _dir = random 360;
private _noRoad = if (!isNull _road) then {
	_randPos = getPosATL _road;

	private _connectedRoads = roadsConnectedTo _road;
	if (_connectedRoads isNotEqualTo []) then {
		_dir = _road getDir (_connectedRoads # 0);
	};

	false
} else {true};

// If no good spots are found, just stop
if (_noRoad && {random 1 < 0.9}) exitWith {
	_iteratePFHID call CBA_fnc_removePerFrameHandler;
};

private _vehClass = if (_vehicleClasses isEqualTypeAll "") then {
	selectRandom _vehicleClasses
} else {
	selectRandomWeighted _vehicleClasses
};

private _vehicle = createVehicle [_vehClass,[0,0,999 + round random 999],[],0,"CAN_COLLIDE"];
_vehicle allowDamage false;
_vehicle setDir _dir;

[{
	params ["_vehicle","_randPos"];
	_vehicle setVelocity [0,0,0];
	_vehicle setVehiclePosition [_randPos,[],0,"NONE"];
	[EFUNC(common,spawnCleanup),_vehicle,2] call CBA_fnc_waitAndExecute;
},[_vehicle,_randPos],1] call CBA_fnc_waitAndExecute;

private _group = createGroup [civilian,true];

private _manClass = if (_unitClasses isEqualTypeAll "") then {
	selectRandom _unitClasses
} else {
	selectRandomWeighted _unitClasses
};

private _man = _group createUnit [_manClass,_randPos,[],0,"NONE"];
_man allowDamage false;
[{_this allowDamage true},_man,4] call CBA_fnc_waitAndExecute;
doStop _man;

_man setVariable [QGVAR(hasBrain),true,true];
_man setVariable [QGVAR(inhabitancy),_area,true];

[QGVAR(setSpeaker),[_man,"NoVoice"]] call CBA_fnc_globalEvent;

_man disableAI "TARGET";
_man disableAI "AUTOTARGET";
_man disableAI "FSM";
_man disableAI "AIMINGERROR";
_man disableAI "AUTOCOMBAT";
_man disableAI "SUPPRESSION";
_man disableAI "MINEDETECTION";
_man disableAI "COVER";
_man disableAI "WEAPONAIM";
_man setSkill 0;

_man assignAsDriver _vehicle;
_man moveInDriver _vehicle;

_group setSpeedMode "LIMITED";
_group setBehaviour "CARELESS";
_man setSpeedMode "LIMITED";

[_man,_customArgs] call _customInit;
[_vehicle,_customArgs] call _customInit;

_man call FUNC(addPanic);

[QGVAR(manCreated),_man] call CBA_fnc_serverEvent;
[QGVAR(vehicleCreated),_vehicle] call CBA_fnc_serverEvent;
