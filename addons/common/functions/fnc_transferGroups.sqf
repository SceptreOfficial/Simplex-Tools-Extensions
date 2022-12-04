#include "script_component.hpp"

params ["_owner","_groups","_args","_fnc"];

if (_owner != clientOwner) then {
	[QGVAR(transferGroups),_this,_owner] call CBA_fnc_ownerEvent;
} else {
	// Save loadouts
	{
		if (!local _x) then {
			{_x setVariable [QGVAR(loadout),getUnitLoadout _x]} forEach units _x;
		};
	} forEach _groups;

	[QGVAR(transferGroupsServer),[_owner,_groups]] call CBA_fnc_serverEvent;

	[{
		{!local _x && !isNull _x && {{alive _x} count units _x != 0}} count (_this # 0) == 0
	},{
		params ["_groups","_args","_fnc"];

		// Apply loadouts
		{
			{
				private _loadout = _x getVariable QGVAR(loadout);
				if (!isNil "_loadout") then {
					_x setUnitLoadout _loadout;
					_x setVariable [QGVAR(loadout),nil];
				};
			} forEach units _x;
		} forEach _groups;

		if (_fnc isEqualType "") exitWith {_args call (missionNamespace getVariable [_fnc,{}])};
		if (_fnc isEqualType {}) exitWith {_args call _fnc};
	},[_groups,_args,_fnc],10,{
		LOG_WARNING("Group transfer timed out");
	}] call CBA_fnc_waitUntilAndExecute;
};
