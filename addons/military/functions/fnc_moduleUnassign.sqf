#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _object = attachedTo _logic;

	deleteVehicle _logic;

	if (isNull _object) then {
		[{
			params ["_curatorSelected"];
			_curatorSelected params ["_objects","_groups"];

			if (_objects isEqualTo [] && _groups isEqualTo []) exitWith {
				[objNull,"Nothing selected"] call BIS_fnc_showCuratorFeedbackMessage;
			};

			{_groups pushBackUnique group _x} forEach _objects;

			if (_groups isEqualTo []) exitWith {
				[objNull,"No valid groups were selected"] call BIS_fnc_showCuratorFeedbackMessage;
			};

			{
				_x setVariable [QGVAR(assignment),nil,true];
				_x setVariable [QGVAR(available),nil,true];
			} forEach _groups;
		}] call EFUNC(common,zeusSelection);
	} else {
		private _group = group _object;

		_group setVariable [QGVAR(assignment),nil,true];
		_group setVariable [QGVAR(available),nil,true];

		[QEGVAR(common,execute),[_group,{
			{
				_x doFollow leader _this;
				_x enableAI "PATH";
			} forEach units _this;
		}],leader _group] call CBA_fnc_targetEvent;
	};
},_this] call CBA_fnc_directCall;
