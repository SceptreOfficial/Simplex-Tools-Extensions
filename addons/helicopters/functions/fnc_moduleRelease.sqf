#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _vehicle = attachedTo _logic;
	deleteVehicle _logic;

	if (!alive _vehicle || !(_vehicle isKindOf "Helicopter")) exitWith {
		"NO HELICOPTER SELECTED" call EFUNC(common,zeusMessage);
	};

	[_vehicle,[0,0,0]] call EFUNC(common,pilotHelicopter);
	
	"HELICOPTER RELEASED" call EFUNC(common,zeusMessage);
},_this] call CBA_fnc_execNextFrame;
