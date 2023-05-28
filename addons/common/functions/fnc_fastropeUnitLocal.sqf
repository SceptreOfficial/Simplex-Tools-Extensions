#include "script_component.hpp"

params ["_unit","_vehicle","_line"];
_line params ["_hook","_anchor","_rope","_length"];

[_unit] orderGetIn false;
unassignVehicle _unit;
moveOut _unit;
_unit setPosASL (getPosASL _hook vectorAdd [0,0,-2]);
_unit setDir random 360;
//if (!isPlayer _unit) then {_unit setDir random 360};

_unit switchMove QPVAR(fastrope);

[{
	params ["_unit","_vehicle","_endHeight"];

	private _height = getPosASL _unit # 2 - _endHeight;
	private _speed = velocity _unit # 2;
	if (_speed < -8) then {_unit setVelocity [0,0,-7.5]};
	if (_height < 6 && _speed < -1) then {_unit setVelocity [0,0,(_speed * 0.95) min -3]};

	!alive _unit || isTouchingGround _unit || _height < 0.2
},{
	params ["_unit","_vehicle"];

	_unit switchMove "";
	_unit setVectorUp [0,0,1];
	_unit setVariable [QPVAR(fastroping),nil,true];
	
	[QGVAR(fastropingDone),[_unit,_vehicle],_vehicle] call CBA_fnc_targetEvent;
},[_unit,_vehicle,getPosASL _hook # 2 - _length]] call CBA_fnc_waitUntilAndExecute;
