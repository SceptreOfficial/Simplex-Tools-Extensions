#include "script_component.hpp"

params [
	["_vehicle",objNull,[objNull]],
	["_posASL",[0,0,0],[[]]]
];

private _cargo = _vehicle getVariable [QGVAR(slingloadCargo),objNull];

if (isNull _cargo) exitWith {
	[_vehicle,objNull] call FUNC(slingload);
};

if (_posASL isEqualTo [0,0,0]) then {
	_posASL = getPosASL _vehicle;
	_posASL set [2,0];
	_posASL = AGLToASL _posASL;
};

[
	_vehicle,
	_posASL vectorAdd [0,0,(_vehicle getVariable [QGVAR(slingloadRopeLength),12])],
	[],
	60,
	50,
	-6,
	[{
		[_vehicle,objNull] call FUNC(slingload);
		true
	}]
] call FUNC(flyHelicopter);
