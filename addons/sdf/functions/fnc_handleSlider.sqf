#include "script_component.hpp"

params ["_ctrlSlider","_ctrlEdit","_options","_value","_onValueChanged",["_symbol",""],"_minText","_maxText"];
_options params [["_min",0,[0]],["_max",1,[0]],["_decimals",1,[0]]];

_ctrlSlider setVariable [QGVAR(options),[_min,_max,_decimals]];
_ctrlSlider setVariable [QGVAR(ctrlEdit),_ctrlEdit];
_ctrlSlider setVariable [QGVAR(onValueChanged),_onValueChanged];
_ctrlSlider setVariable [QGVAR(minText),_minText];
_ctrlSlider setVariable [QGVAR(maxText),_maxText];
_ctrlSlider setVariable [QGVAR(symbol),_symbol];
_ctrlEdit setVariable [QGVAR(ctrlSlider),_ctrlSlider];

_ctrlSlider sliderSetRange [_min,_max];
_ctrlSlider sliderSetPosition _value;

private _posText = (sliderPosition _ctrlSlider toFixed _decimals) + _symbol;

if (_value == _min) then {
	_posText = _ctrlSlider getVariable [QGVAR(minText),_posText];
};

if (_value == _max) then {
	_posText = _ctrlSlider getVariable [QGVAR(maxText),_posText];
};

_ctrlEdit ctrlSetText _posText;

private _IDs = _ctrlSlider getVariable QGVAR(handlingIDs);

if (!isNil "_IDs") then {
	_ctrlSlider ctrlRemoveEventHandler ["SliderPosChanged",_IDs # 0];
	_ctrlEdit ctrlRemoveEventHandler ["KeyUp",_IDs # 1];
	_ctrlEdit ctrlRemoveEventHandler ["KillFocus",_IDs # 2];
	_ctrlEdit ctrlRemoveEventHandler ["SetFocus",_IDs # 3];
};

_ctrlSlider setVariable [QGVAR(handlingIDs),[
	[_ctrlSlider,"SliderPosChanged",{
		params ["_ctrlSlider","_sliderPos"];
		
		_ctrlSlider getVariable QGVAR(options) params ["_min","_max","_decimals"];
		private _posText = (_sliderPos toFixed _decimals) + (_ctrlSlider getVariable QGVAR(symbol));
		private _pos = parseNumber _posText;

		if (_pos == _min) then {
			_posText = _ctrlSlider getVariable [QGVAR(minText),_posText];
		};

		if (_pos == _max) then {
			_posText = _ctrlSlider getVariable [QGVAR(maxText),_posText];
		};

		_ctrlSlider sliderSetPosition _pos;
		(_ctrlSlider getVariable QGVAR(ctrlEdit)) ctrlSetText _posText;
		[_ctrlSlider,sliderPosition _ctrlSlider] call (_ctrlSlider getVariable QGVAR(onValueChanged));
	}] call CBA_fnc_addBISEventHandler,

	[_ctrlEdit,"KeyUp",{
		params ["_ctrlEdit"];

		private _ctrlSlider = _ctrlEdit getVariable QGVAR(ctrlSlider);
		_ctrlSlider getVariable QGVAR(options) params ["_min","_max","_decimals"];
		private _posText = ((_min max (parseNumber ctrlText _ctrlEdit) min _max) toFixed _decimals) + (_ctrlSlider getVariable QGVAR(symbol));
		private _pos = parseNumber _posText;

		if (_pos == _min) then {
			_posText = _ctrlSlider getVariable [QGVAR(minText),_posText];
		};

		if (_pos == _max) then {
			_posText = _ctrlSlider getVariable [QGVAR(maxText),_posText];
		};

		_ctrlSlider sliderSetPosition _pos;
		_ctrlEdit ctrlSetText _posText;
		[_ctrlSlider,sliderPosition _ctrlSlider] call (_ctrlSlider getVariable QGVAR(onValueChanged));
	}] call CBA_fnc_addBISEventHandler,

	[_ctrlEdit,"KillFocus",{
		params ["_ctrlEdit"];

		private _ctrlSlider = _ctrlEdit getVariable QGVAR(ctrlSlider);
		_ctrlSlider getVariable QGVAR(options) params ["_min","_max","_decimals"];

		private _posText = (sliderPosition _ctrlSlider toFixed _decimals) + (_ctrlSlider getVariable QGVAR(symbol));
		private _pos = parseNumber _posText;

		if (_pos == _min) then {
			_posText = _ctrlSlider getVariable [QGVAR(minText),_posText];
		};

		if (_pos == _max) then {
			_posText = _ctrlSlider getVariable [QGVAR(maxText),_posText];
		};

		_ctrlEdit ctrlSetText _posText;
	}] call CBA_fnc_addBISEventHandler,

	[_ctrlEdit,"SetFocus",{
		params ["_ctrlSlider"];
		uiNamespace setVariable [QGVAR(editFocus),_ctrlSlider];
	}] call CBA_fnc_addBISEventHandler
]];
