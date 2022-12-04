#include "script_component.hpp"

params ["_ctrlSlider","_ctrlEdit","_options","_initValue"];
_options params [["_min",0,[0]],["_max",1,[0]],["_decimals",1,[0]]];

_ctrlSlider sliderSetRange [_min,_max];
_ctrlSlider setVariable [QGVAR(options),[_min,_max,_decimals]];
_ctrlSlider setVariable [QGVAR(ctrlEdit),_ctrlEdit];
_ctrlEdit setVariable [QGVAR(ctrlSlider),_ctrlSlider];

_ctrlSlider sliderSetPosition _initValue;
_ctrlEdit ctrlSetText (sliderPosition _ctrlSlider toFixed _decimals);

[_ctrlSlider,"SliderPosChanged",{
	params ["_ctrlSlider","_sliderPos"];
	
	_ctrlSlider getVariable QGVAR(options) params ["_min","_max","_decimals"];

	(_ctrlSlider getVariable QGVAR(ctrlEdit)) ctrlSetText (_sliderPos toFixed _decimals);
}] call CBA_fnc_addBISEventHandler;

[_ctrlEdit,"KeyUp",{
	params ["_ctrlEdit"];

	private _ctrlSlider = _ctrlEdit getVariable QGVAR(ctrlSlider);

	_ctrlSlider getVariable QGVAR(options) params ["_min","_max","_decimals"];

	_ctrlSlider sliderSetPosition (parseNumber ctrlText _ctrlEdit);
}] call CBA_fnc_addBISEventHandler;

[_ctrlEdit,"KillFocus",{
	params ["_ctrlEdit"];

	private _ctrlSlider = _ctrlEdit getVariable QGVAR(ctrlSlider);

	_ctrlSlider getVariable QGVAR(options) params ["_min","_max","_decimals"];

	_ctrlEdit ctrlSetText (sliderPosition _ctrlSlider toFixed _decimals);
}] call CBA_fnc_addBISEventHandler;

[_ctrlEdit,"SetFocus",{
	params ["_ctrlSlider"];
	uiNamespace setVariable [QGVAR(editFocus),_ctrlSlider];
}] call CBA_fnc_addBISEventHandler;