#include "script_component.hpp"

params [
	["_vehicle",objNull,[objNull]],
	["_cargo",objNull,[objNull]],
	["_massOverride",false,[false]]
];

if (!isNull (_vehicle getVariable [QGVAR(slingloadCargo),objNull])) then {
	[_vehicle,objNull] call FUNC(slingload);
};

(boundingBoxReal _cargo) params ["_min","_max"];

[
	_vehicle,
	getPosASL _cargo vectorAdd [0,0,13 + abs (_min # 2 - _max # 2)],
	getDir _cargo,
	getPos _cargo # 2 + 30,
	100,
	nil,
	[{
		params ["_cargo","_massOverride"];

		if (_vehicle distance2D _cargo < 5) then {
			[_vehicle,_cargo,false,_massOverride] call FUNC(slingload);
		};

		true
	},[_cargo,_massOverride]]
] call FUNC(flyHelicopter);
