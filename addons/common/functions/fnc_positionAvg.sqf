#include "script_component.hpp"

if !(_this isEqualType []) exitWith {[0,0,0]};

if (_this # 0 isEqualType objNull) then {
	_this = _this apply {getPosASL _x};
};

[
	_this apply {_x # 0} call BIS_fnc_arithmeticMean,
	_this apply {_x # 1} call BIS_fnc_arithmeticMean,
	_this apply {_x # 2} call BIS_fnc_arithmeticMean
]
