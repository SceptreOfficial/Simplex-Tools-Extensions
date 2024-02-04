#include "..\script_component.hpp"

params [["_unit",objNull,[objNull]]];

if (!alive _unit) exitWith {};

[QGVAR(addPanicServer),_unit] call CBA_fnc_serverEvent;
