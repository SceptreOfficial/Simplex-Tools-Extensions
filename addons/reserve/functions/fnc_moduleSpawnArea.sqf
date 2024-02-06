#include "..\script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic"];
	deleteVehicle _logic;
},_this,10] call CBA_fnc_waitAndExecute;
