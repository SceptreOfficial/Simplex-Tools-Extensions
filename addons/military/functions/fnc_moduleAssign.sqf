#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _object = attachedTo _logic;
	private _assignment = getText (configFile >> "CfgVehicles" >> typeOf _logic >> QGVAR(assignment));
	
	deleteVehicle _logic;

	if (isNull _object) then {
		[{
			params ["_curatorSelected","_assignment"];
			_curatorSelected params ["_objects","_groups"];

			if (_objects isEqualTo [] && _groups isEqualTo []) exitWith {
				[objNull,"Nothing selected"] call BIS_fnc_showCuratorFeedbackMessage;
			};

			{_groups pushBackUnique group _x} forEach _objects;
			
			_groups = (_groups select {
				side _x in [west,east,independent] && isNil {_x getVariable QGVAR(assignment)}
			}) - (allPlayers apply {group _x});

			if (_groups isEqualTo []) exitWith {
				[objNull,"No valid groups were selected"] call BIS_fnc_showCuratorFeedbackMessage;
			};

			[_groups,_assignment] call FUNC(assignmentDialog);
		},_assignment] call EFUNC(common,zeusSelection);
	} else {
		private _group = group _object;

		if !(side _group in [west,east,independent]) exitWith {};
		if (!isNil {_group getVariable QGVAR(assignment)}) exitWith {};

		[_group,_assignment] call FUNC(assignmentDialog);
	};
},_this] call CBA_fnc_directCall;
