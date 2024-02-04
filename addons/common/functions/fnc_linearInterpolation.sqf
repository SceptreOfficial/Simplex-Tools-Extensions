#include "..\script_component.hpp"

params ["_array","_progress"];

if (_progress < 1) then {
	private _cA = (count _array - 1) * _progress;
	private _cF = floor _cA;
	private _c1 = _array # _cF;
	private _c2 = _array # (_cF + 1);

	(_c2 vectorDiff _c1) vectorMultiply (_cA - _cF) vectorAdd _c1;

	//[
	//	[_c1 # 0,_c2 # 0,_cA - _cF] call BIS_fnc_easeInOut,
	//	[_c1 # 1,_c2 # 1,_cA - _cF] call BIS_fnc_easeInOut,
	//	[_c1 # 2,_c2 # 2,_cA - _cF] call BIS_fnc_easeInOut
	//];
} else {
	_array # (count _array - 1)
};
