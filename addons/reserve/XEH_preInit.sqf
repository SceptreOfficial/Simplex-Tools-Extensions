#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "initSettings.inc.sqf"

if (isServer) then {
	[QGVAR(save),FUNC(save)] call CBA_fnc_addEventHandler;
};

ADDON = true;
