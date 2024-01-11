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

_vehicle call FUNC(addPanic);

[{
	params ["_vehicle","_randPos"];
	_vehicle setVelocity [0,0,0];
	_vehicle setVehiclePosition [_randPos,[],0,"NONE"];
	[EFUNC(common,spawnCleanup),_vehicle,2] call CBA_fnc_waitAndExecute;
},[_vehicle,_randPos],1] call CBA_fnc_waitAndExecute;

private _unitClass = if (_unitClasses isEqualTypeAll "") then {
	selectRandom _unitClasses
} else {
	selectRandomWeighted _unitClasses
};

private _unit = objNull;

if (GVAR(useAgents)) then {
	_unit = createAgent [_unitClass,[0,0,0],[],0,"CAN_COLLIDE"];
} else {
	private _group = createGroup [civilian,true];
	_group setSpeedMode "LIMITED";
	_group setBehaviour "CARELESS";
	_group addVehicle _vehicle;

	_unit = _group createUnit [_unitClass,_randPos,[],0,"NONE"];
	doStop _unit;
};

[_unit,_area] call FUNC(initMan);

_unit assignAsDriver _vehicle;
_unit moveInDriver _vehicle;

if (!_ambCiv && GVAR(cachingDefault)) then {
	_unit setVariable [QGVAR(allowCaching),true,true];
	_vehicle setVariable [QGVAR(allowCaching),true,true];
};

[_unit,_customArgs] call _customInit;
[_vehicle,_customArgs] call _customInit;

[QGVAR(driverSpawned),[_unit,_vehicle]] call CBA_fnc_serverEvent;
