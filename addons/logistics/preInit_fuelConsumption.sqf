#include "script_component.hpp"

[
	QGVAR(enableFuelConsumption),
	"CHECKBOX",
	[LSTRING(enableFuelConsumptionName),LSTRING(enableFuelConsumptionInfo)],
	[LSTRING(category),LSTRING(fuelConsumption)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(minFuelConsumption),
	"SLIDER",
	[LSTRING(minFuelConsumptionName),LSTRING(minFuelConsumptionInfo)],
	[LSTRING(category),LSTRING(fuelConsumption)],
	[0,999,180,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(maxFuelConsumption),
	"SLIDER",
	[LSTRING(maxFuelConsumptionName),LSTRING(maxFuelConsumptionInfo)],
	[LSTRING(category),LSTRING(fuelConsumption)],
	[0,999,40,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Inspired by KP Liberation

["CAManBase","GetInMan",{
	if (!GVAR(enableFuelConsumption)) exitWith {};

	params ["_unit","","_vehicle"];

	if (!local _unit || !isPlayer _unit) exitWith {};

	if (isNil QGVAR(fuelConsumptionVehicles)) then {
		GVAR(fuelConsumptionVehicles) = [];
	};

	if (_vehicle in GVAR(fuelConsumptionVehicles)) exitWith {};

	GVAR(fuelConsumptionVehicles) pushBack _vehicle;

	[{
		params ["_vehicle","_PFHID"];

		if (!local _vehicle || !alive _vehicle || !GVAR(enableFuelConsumption)) exitWith {
			_PFHID call CBA_fnc_removePerFrameHandler;
			GVAR(fuelConsumptionVehicles) deleteAt (GVAR(fuelConsumptionVehicles) find _vehicle);
		};

		if (isEngineOn _vehicle) then {
			private _min = _vehicle getVariable [QGVAR(minFuelConsumption),GVAR(minFuelConsumption)];
			private _max = _vehicle getVariable [QGVAR(maxFuelConsumption),GVAR(maxFuelConsumption)];
			private _coef = linearConversion [
				5,
				getNumber (configOf _vehicle >> "maxSpeed") * 0.9,
				abs speed _vehicle,
				_min,
				_max,
				true
			];

			_vehicle setFuel (fuel _vehicle - (1 / (_coef * 60)));
		};
	},1,_vehicle] call CBA_fnc_addPerFrameHandler;
}] call CBA_fnc_addClassEventHandler;
