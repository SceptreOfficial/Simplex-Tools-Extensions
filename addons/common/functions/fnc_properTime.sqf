#include "script_component.hpp"
/*
	Authors: Sceptre
	Returns a proper time description from supplied time in seconds

	Parameters:
	0: Seconds <SCALAR>
	1: Generalized rounding, true for 15s <BOOL | SCALAR>

	Returns:
	Time description <STRING>
*/
params [["_time",0,[0]],["_round",false,[false,0]]];

_round = if (_round isEqualType 0) then {
	0 max _round
} else {
	[1,15] select _round	
};

_time = round (0 max round _time / _round) * _round;

private _minutes = floor (_time / 60);
private _description = [];

{
	if (_x != 0) then {
		switch _forEachIndex do {
			case 0 : {_description pushBack format [[LLSTRING(day),LLSTRING(dayPlural)] select (_x > 1),_x]};
			case 1 : {_description pushBack format [[LLSTRING(hour),LLSTRING(hourPlural)] select (_x > 1),_x]};
			case 2 : {_description pushBack format [[LLSTRING(minute),LLSTRING(minutePlural)] select (_x > 1),_x]};
			case 3 : {_description pushBack format [[LLSTRING(second),LLSTRING(secondPlural)] select (_x > 1),_x]};
		};
	};
} forEach [floor (_minutes / 60 / 24),floor (_minutes / 60) % 24,_minutes % 60,_time % 60];

_description joinString ", "
