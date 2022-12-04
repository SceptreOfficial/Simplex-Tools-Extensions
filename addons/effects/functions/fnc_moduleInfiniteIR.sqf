#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _object = "O_IRStrobe_Infinite" createVehicle [0,0,0];
	_object allowDamage false;
	_object attachTo [_logic,[0,0,0]];
	[QGVAR(infiniteItemCreated),[_object,_logic]] call CBA_fnc_globalEvent;
},_this] call CBA_fnc_execNextFrame;
