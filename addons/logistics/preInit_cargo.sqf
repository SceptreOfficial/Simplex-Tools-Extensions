if (isServer) then {
	["All","Deleted",{
		params ["_object"];

		{
			if (_x isEqualType objNull) then {
				_x setVariable [QGVAR(cargoParent),nil];
				detach _x;
				deleteVehicle _x;
			};
		} forEach (_object getVariable [QGVAR(cargoManifest),[]]);
		
		if (!isNull (_object getVariable [QGVAR(cargoParent),objNull])) then {
			[_object,[]] call FUNC(cargoUnload);	
		};
	}] call CBA_fnc_addClassEventHandler;
};

["All","Killed",{
	params ["_object"];

	private _manifest = _object getVariable [QGVAR(cargoManifest),[]];
	
	if (_manifest isEqualTo []) exitWith {};

	{
		if (_x isEqualType objNull) then {
			detach _x;
			deleteVehicle _x;
		};
	} forEach _manifest;

	_object setVariable [QGVAR(cargoManifest),[],true];
}] call CBA_fnc_addClassEventHandler;
