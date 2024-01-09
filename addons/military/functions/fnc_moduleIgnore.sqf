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

			[LLSTRING(moduleIgnore),[
				["CHECKBOX","Objects",true],
				["CHECKBOX","Groups",true]
			],{
				params ["_values","_args"];
				_values params ["_ignoreObjects","_ignoreGroups"];
				_args params ["_objects","_groups"];

				_ignoreObjects = [nil,true] select _ignoreObjects;
				_ignoreGroups = [nil,true] select _ignoreGroups;

				{_x setVariable [QGVAR(ignore),_ignoreObjects,true]} forEach _objects;
				{_x setVariable [QGVAR(ignore),_ignoreGroups,true]} forEach _groups;

				"Changes applied" call EFUNC(common,zeusMessage);
			},[_objects,_groups]] call EFUNC(sdf,dialog);
		}] call EFUNC(common,zeusSelection);
	} else {
		[LLSTRING(moduleIgnore),[
			["CHECKBOX","Objects",true],
			["CHECKBOX","Groups",true]
		],{
			params ["_values","_args"];
			_values params ["_ignoreObjects","_ignoreGroups"];
			_args params ["_objects","_groups"];

			_ignoreObjects = [nil,true] select _ignoreObjects;
			_ignoreGroups = [nil,true] select _ignoreGroups;

			{_x setVariable [QGVAR(ignore),_ignoreObjects,true]} forEach _objects;
			{_x setVariable [QGVAR(ignore),_ignoreGroups,true]} forEach _groups;

			"Changes applied" call EFUNC(common,zeusMessage);
		},[[_object],[group _object]]] call EFUNC(sdf,dialog);
	};
},_this] call CBA_fnc_execNextFrame;
