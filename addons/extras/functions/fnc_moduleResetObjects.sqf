#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _object = attachedTo _logic;

	if (isNull _object) then {
		[{
			params ["_curatorSelected"];
			_curatorSelected params ["_objects"];
			[_objects,_objects isNotEqualTo []] call FUNC(resetObjects);
		}] call EFUNC(common,zeusSelection);
	} else {
		[[_object]] call FUNC(resetObjects);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
