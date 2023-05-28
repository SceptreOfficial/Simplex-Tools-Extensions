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
