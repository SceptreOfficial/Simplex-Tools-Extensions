#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _obj = attachedTo _logic;
	deleteVehicle _logic;

	if (isNull _obj) then {
		[{
			params ["_curatorSelected","_args"];
			
			{
				if (side _x == civilian) then {
					{_x call FUNC(addPanic)} forEach units _x;
				};
			} forEach (_curatorSelected # 1); // groups
		}] call EFUNC(common,zeusSelection);
	} else {
		if (side group _obj == civilian) then {
			_obj call FUNC(addPanic);
			[objNull,LLSTRING(Module_AddPanic_Added)] call BIS_fnc_showCuratorFeedbackMessage;
		} else {
			[objNull,LLSTRING(Module_AddPanic_NotCiv)] call BIS_fnc_showCuratorFeedbackMessage;
		};
	};
},_this] call CBA_fnc_directCall;
