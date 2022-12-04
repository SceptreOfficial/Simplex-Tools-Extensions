#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

if (isServer) then {
	[QGVAR(infiniteItemCreated),{
		params ["_object","_logic"];
		[_logic,"Deleted",{deleteVehicle _thisArgs},_object] call CBA_fnc_addBISEventHandler;
	}] call CBA_fnc_addEventHandler;
};

ADDON = true;
