#include "..\script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		if (_synced isEqualTo []) exitWith {
			LOG_WARNING("No objects synced");
		};

		{_x call FUNC(addCanteenTap)} forEach _synced;
	} else {
		private _object = attachedTo _logic;

		if (!alive _object) exitWith {
			ZEUS_MESSAGE("Invalid object");
		};

		_object call FUNC(addCanteenTap);

		"CANTEEN TAP ADDED" call EFUNC(common,zeusMessage);
	};
	
	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
