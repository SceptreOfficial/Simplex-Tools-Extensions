#include "..\script_component.hpp"

_thisArgs params ["_group","_area","_blacklist","_unitClasses","_customInit","_customArgs","_ambCiv"];

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

private _unit = objNull;

if (GVAR(useAgents)) then {
	_unit = createAgent [_class,_randPos,[],0,"NONE"];
} else {
	_unit = _group createUnit [_class,_randPos,[],0,"NONE"];
	doStop _unit;
};

_unit allowDamage false;
[{_this allowDamage true},_unit,3] call CBA_fnc_waitAndExecute;
_unit setDir random 360;

[_unit,_area] call FUNC(initMan);

if (!_ambCiv && GVAR(cachingDefault)) then {
	_unit setVariable [QGVAR(allowCaching),true,true];
};

[_unit,_customArgs] call _customInit;

[QGVAR(pedestrianSpawned),_unit] call CBA_fnc_serverEvent;
