[
	QGVAR(parachuteClass),
	"EDITBOX",
	[LSTRING(parachuteClassName),LSTRING(parachuteClassInfo)],
	[LSTRING(category),LSTRING(halo)],
	"B_Parachute",
	true,
	{},
	false
] call CBA_fnc_addSetting;

if (isServer) then {
	[QEGVAR(common,flybyPosReached),{
		params ["_aircraft"];

		_aircraft getVariable QGVAR(HALO) params ["_jumpDelay","_AIOpenAltitude"];
		
		if (isNil "_jumpDelay") exitWith {};

		[{
			params ["_args","_PFHID"];
			_args params ["_aircraft","_AIOpenAltitude"];

			private _units = (crew _aircraft - units group _aircraft) select {alive _x};

			if (!alive _aircraft || _units isEqualTo []) exitWith {
				_PFHID call CBA_fnc_removePerFrameHandler;
			};

			[QEGVAR(common,execute),[[_units # 0,_aircraft,_AIOpenAltitude],{
				params ["_unit","_aircraft","_AIOpenAltitude"];

				[_unit] orderGetIn false;
				moveOut _unit;
				_unit setVelocity (velocity _aircraft vectorMultiply 0.9);
				[_unit,_AIOpenAltitude,GVAR(parachuteClass)] call EFUNC(common,paradropUnit);
			}],_units # 0] call CBA_fnc_targetEvent;
		},_jumpDelay,[_aircraft,_AIOpenAltitude]] call CBA_fnc_addPerFrameHandler;
	}] call CBA_fnc_addEventHandler;
};

[QGVAR(haloPos),{
	params ["_unit","_pos","_AIOpenAltitude"];
	_unit setPosATL _pos;
	[_unit,_AIOpenAltitude,GVAR(parachuteClass)] call EFUNC(common,paradropUnit);
}] call CBA_fnc_addEventHandler;
