#include "script_component.hpp"
/*
	Author: Sceptre

	Description:
	Displays a hint

	Parameters:
	0: Text <STRING>
*/

params ["_text"];

switch GVAR(hintType) do {
	case 0 : {hint _text};
	case 1 : {hintSilent _text};
	case 2 : {
		private _layer = QGVAR(hint) + str diag_tickTime;
		_layer cutText [_text,"PLAIN",0.2];
		[{_this cutFadeOut 1},_layer,2] call CBA_fnc_waitAndExecute;
	};
	case 3 : {systemChat _text};
};
