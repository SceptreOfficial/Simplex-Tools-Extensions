#include "script_component.hpp"

if (isServer) then {
	[QGVAR(hideObjectGlobal),{
		params ["_object","_state"];
		_object hideObjectGlobal _state;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(enableSimulationGlobal),{
		params ["_object","_state"];
		_object enableSimulationGlobal _state;
	}] call CBA_fnc_addEventHandler;
};

[QGVAR(allowDamage),{
	params ["_object","_state"];
	_object allowDamage _state;
}] call CBA_fnc_addEventHandler;

[QGVAR(enableAIFeature),{
	params ["_unit","_args"];
	_unit enableAIFeature _args;
}] call CBA_fnc_addEventHandler;

[QGVAR(flyInHeight),{
	params ["_vehicle","_height"];
	_vehicle flyInHeight _height;
}] call CBA_fnc_addEventHandler;

[QGVAR(flyInHeightASL),{
	params ["_vehicle","_height"];
	_vehicle flyInHeightASL [_height,_height,_height];
}] call CBA_fnc_addEventHandler;

[QGVAR(limitSpeed),{
	params ["_object","_speed"];
	
	if (_speed <= 0) then {
		_object limitSpeed 99999999;
		_object forceSpeed -1;
	} else {
		_object limitSpeed _speed;
		_object forceSpeed (_speed / 3.6);
	};
}] call CBA_fnc_addEventHandler;
