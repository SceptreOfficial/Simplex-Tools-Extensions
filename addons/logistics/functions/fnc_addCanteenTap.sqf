#include "script_component.hpp"

params [["_object",objNull,[objNull]]];

[QEGVAR(common,execute),[_object,{
	params ["_object"];

	if (_object getVariable [QGVAR(canteenTap),false]) exitWith {};

	_object setVariable [QGVAR(canteenTap),true,true];

	private _JIPID = [QGVAR(canteenTapAdded),_object] call CBA_fnc_globalEventJIP;
	[_JIPID,_object] call CBA_fnc_removeGlobalEventJIP;
}]] call CBA_fnc_serverEvent;
