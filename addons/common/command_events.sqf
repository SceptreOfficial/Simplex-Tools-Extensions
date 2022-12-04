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
