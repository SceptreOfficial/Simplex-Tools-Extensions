#include "script_component.hpp"

params [["_targetPosition",[],[[]]],["_spawnRadius",-1,[0]],["_type",-1,[0]]];

if (surfaceIsWater _targetPosition || _spawnRadius < 0 || _type < 0) exitWith {};

private _spawnCounts = switch (_type) do {
	case 0 : {[GVAR(pedestrianCount),0,0]};
	case 1 : {[0,GVAR(driverCount),0]};
	case 2 : {[0,0,GVAR(parkedCount)]};
};

if (_spawnCounts isEqualTo [0,0,0]) exitWith {};

if ((GVAR(blacklist) findIf {
	private _area = +([_x] call CBA_fnc_getArea);
	if (_area isNotEqualTo []) then {
		_area set [1,_area # 1 + 100];
		_area set [2,_area # 2 + 100];
		_targetPosition inArea _area
	} else {false}
}) != -1) exitWith {};

private _spawnPoint = createTrigger ["EmptyDetector",_targetPosition,false];
_spawnPoint setTriggerArea [_spawnRadius,_spawnRadius,0,false];
_spawnPoint setVariable [QGVAR(type),_type];

[
	_spawnPoint,
	GVAR(unitClasses),
	GVAR(vehClasses),
	_spawnCounts,
	(GVAR(spawnPoints) select {_x getVariable QGVAR(type) isEqualTo _type}) + GVAR(blacklist),
	{
		params ["_object","_spawnPoint"];

		if (isNull _spawnPoint) then {
			deleteVehicleCrew _object;
			deleteVehicle _object;
		} else {
			_spawnPoint setVariable [QGVAR(objects),(_spawnPoint getVariable [QGVAR(objects),[]]) + [_object]];
		};
	},
	_spawnPoint,
	true
] call FUNC(populate);

GVAR(spawnPoints) pushBack _spawnPoint;

_spawnPoint
