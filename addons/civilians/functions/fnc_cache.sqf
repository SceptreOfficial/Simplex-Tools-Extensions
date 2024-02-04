#include "..\script_component.hpp"

params ["_object"];

// Prevent double execution
if (_object getVariable [QGVAR(cached),false]) exitWith {};
_object setVariable [QGVAR(cached),true];

if (_object isKindOf "CAManBase") then {
	private _unit = _object;
	private _vehicle = vehicle _unit;

	if (_vehicle != _unit) then {
		GVAR(cache) pushBack ["driver",[
			typeOf _vehicle,
			getPosASLVisual _vehicle,
			[vectorDirVisual _vehicle,vectorUpVisual _vehicle],
			typeOf _unit,
			_unit getVariable QGVAR(inhabitancy)
		]];

		deleteVehicleCrew _vehicle;
		deleteVehicle _vehicle;
	} else {
		GVAR(cache) pushBack ["pedestrian",[
			typeOf _unit,
			getPosASLVisual _unit,
			[vectorDirVisual _unit,vectorUpVisual _unit],
			group _unit,
			_unit getVariable QGVAR(inhabitancy)
		]];

		deleteVehicle _unit;
	};
} else {
	private _vehicle = _object;
	private _unit = driver _vehicle;

	if (alive _unit) then {
		GVAR(cache) pushBack ["driver",[
			typeOf _vehicle,
			getPosASLVisual _vehicle,
			[vectorDirVisual _vehicle,vectorUpVisual _vehicle],
			typeOf _unit,
			_unit getVariable QGVAR(inhabitancy)
		]];

		deleteVehicleCrew _vehicle;
		deleteVehicle _vehicle;
	} else {
		GVAR(cache) pushBack ["parked",[
			typeOf _vehicle,
			getPosASLVisual _vehicle,
			[vectorDirVisual _vehicle,vectorUpVisual _vehicle]
		]];

		deleteVehicleCrew _vehicle;
		deleteVehicle _vehicle;
	};
};
