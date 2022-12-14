#include "script_component.hpp"

params [
	["_object",objNull,[objNull]],
	["_signal1Class","SmokeShellBlue",[""]],
	["_signal2Class","ACE_G_Chemlight_HiBlue",[""]],
	["_parachuteClass","",[""]]
];

if (_parachuteClass isEqualTo "") then {
	_parachuteClass = "B_Parachute_02_F";
};

private _parachute = _parachuteClass createVehicle [0,0,0];
_parachute setDir getDir _object;
_parachute setPosASL getPosASL _object;
_object attachTo [_parachute,[0,0,abs ((0 boundingBoxReal _object) # 0 # 2)]];

[{
	params ["_object","_parachute"];
	
	_parachute setVectorUp [0,0,1];
	
	isNull _object || !alive _parachute
},{
	params ["_object","_parachute","_signal1Class","_signal2Class"];

	if (!alive _parachute && getPos _object # 2 < 2) then {
		_object setVectorUp surfaceNormal getPosWorld _object;
		_object setVelocity [0,0,0];

		private _offset = (boundingBoxReal _object) # 0;
		private _signal1 = _signal1Class createVehicle [0,0,0];
		_signal1 attachTo [_object,_offset];
		private _signal2 = _signal2Class createVehicle [0,0,0];
		_signal2 attachTo [_object,_offset];
	};

	[QGVAR(paradropEnd),[_object,_parachute]] call CBA_fnc_globalEvent;
},[_object,_parachute,_signal1Class,_signal2Class]] call CBA_fnc_waitUntilAndExecute;

[QGVAR(paradropStart),[_object,_parachute]] call CBA_fnc_globalEvent;

_parachute
