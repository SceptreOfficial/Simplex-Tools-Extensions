#include "script_component.hpp"

params [["_civ",objNull,[objNull]]];

if (!alive _civ) exitWith {};

[QGVAR(addPanicServer),_civ] call CBA_fnc_serverEvent;
