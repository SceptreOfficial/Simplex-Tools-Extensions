#include "script_component.hpp"

params ["_group","_targetPos"];

if (!GVAR(smokeEnabled)) exitWith {};

private _distance = _targetPos distance getPosASL leader _group;

if (_distance > 450 || _distance < 20 || random 1 < GVAR(smokeChance)) exitWith {};

private _count = 0;
private _type = switch (_side) do {
	case west : {SMOKE_TYPES # GVAR(smokeColorWEST)};
	case east : {SMOKE_TYPES # GVAR(smokeColorEAST)};
	case independent : {SMOKE_TYPES # GVAR(smokeColorGUER)};
	default {SMOKE_TYPES # 0};
};

{
	if (alive _x && {_x in _x && _count <= 2 && (_count == 0 || random 1 < 0.65)}) then {
		[_x,_type # 0,_type # 1,_targetPos] call EFUNC(common,throwGrenade);
		_count = _count + 1;
	};
} forEach units _group;
