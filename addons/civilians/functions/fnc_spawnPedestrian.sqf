#include "script_component.hpp"

_thisArgs params ["_pedGroup","_area","_blacklist","_unitClasses","_customInit","_customArgs","_ambCiv"];

if (_ambCiv && {isNull _customArgs}) exitWith {};

private _allowSpawn = true;

// Get random position with blacklist exclusion
private "_randPos";
while {
	_randPos = [_area,false] call CBA_fnc_randPosArea;
	surfaceIsWater _randPos || (_blacklist findIf {_randPos inArea _x}) != -1
} do {};

// Find buildings nearest buildings to random position
private _buildings = (nearestObjects [_randPos,["Building"],200,true]) select {
	private _building = _x;
	_blacklist findIf {_building inArea _x} isEqualTo -1
};

if (_buildings isNotEqualTo []) then {
	// Use nearest building position as spawn point
	_randPos = _buildings # 0 getPos [random 15,random 360];
} else {
	// 70% chance to cancel spawning the pedestrian if no buildings were found
	if (_ambCiv && {random 1 < 0.7}) then {
		_allowSpawn = false;
	};
};

// Spawn pedestrian if possible
if (!_allowSpawn) exitWith {};

private _class = if (_unitClasses isEqualTypeAll "") then {
	selectRandom _unitClasses
} else {
	selectRandomWeighted _unitClasses
};

private _man = _pedGroup createUnit [_class,_randPos,[],0,"NONE"];
_man allowDamage false;
[{_this allowDamage true},_man,3] call CBA_fnc_waitAndExecute;
_man setDir random 360;
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

_pedGroup setSpeedMode "LIMITED";
_pedGroup setBehaviour "CARELESS";
_man setSpeedMode "LIMITED";

[_man,_customArgs] call _customInit;

_man call FUNC(addPanic);

[QGVAR(manCreated),_man] call CBA_fnc_serverEvent;
