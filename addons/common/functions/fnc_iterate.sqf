#include "script_component.hpp"
/*
	Example:

	[[0,1,2,3],{systemChat str _this},[],1] call FUNC(iterate);
*/

params [["_array",[],[[],0]],["_code",{},[{}]],["_args",[]],["_delay",1,[0]],["_delayBeforeExec",false,[false]],["_endCode",{},[{}]]];

if (_array isEqualType 0) then {
	private _int = -1;
	private _newArray = [];
	_newArray resize _array;
	_array = _newArray apply {_init = _int + 1; _int};
};

private _fnc_PFH = {
	params ["_args","_iteratePFHID"];
	_args params ["_array","_thisArgs","_thisCode","_endCode"];

	if (_array isEqualTo []) exitWith {
		_iteratePFHID call CBA_fnc_removePerFrameHandler;
	};

	private _element = (_this # 0 # 0) deleteAt 0;
	_element call _thisCode;

	if (array isEqualTo []) then {
		_element call _endCode;
	};
};

if (_delayBeforeExec) then {
	[CBA_fnc_addPerFrameHandler,[_fnc_PFH,_delay,[+_array,_args,_code,_endCode]],_delay] call CBA_fnc_waitAndExecute;
} else {
	[_fnc_PFH,_delay,[+_array,_args,_code,_endCode]] call CBA_fnc_addPerFrameHandler;	
};
