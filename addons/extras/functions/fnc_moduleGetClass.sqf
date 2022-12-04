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

			str (_objects apply {typeOf _x}) call EFUNC(common,zeusCopyBox);
		}] call EFUNC(common,zeusSelection);
	} else {
		[objNull,LELSTRING(common,zeusSelectionSubmitted)] call BIS_fnc_showCuratorFeedbackMessage;
		str [typeOf _object] call EFUNC(common,zeusCopyBox);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
