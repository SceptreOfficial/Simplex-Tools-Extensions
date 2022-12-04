#include "script_component.hpp"

private _ctrlBoxClass = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS;
[_ctrlBoxClass,"","B_supplyCrate_F",true] call EFUNC(sdf,getCache);

private _ctrlBoxClassPicker = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS_PICKER;
private _ctrlBoxClassTree = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS_TREE;

[_ctrlBoxClassPicker,"ButtonDown",{
	_thisArgs params ["_ctrlBoxClassTree"];
	_ctrlBoxClassTree ctrlShow true;
	ctrlSetFocus _ctrlBoxClassTree;
},_ctrlBoxClassTree] call CBA_fnc_addBISEventHandler;

{
	private _faction = _ctrlBoxClassTree tvAdd [[],_x];
	{
		private _category = _ctrlBoxClassTree tvAdd [[_faction],_x];
		{
			private _path = [_faction,_category,_ctrlBoxClassTree tvAdd [[_faction,_category],_x # 0]];
			_ctrlBoxClassTree tvSetData [_path,_x # 1];
		} forEach _y;
	} forEach _y
} forEach ([] call FUNC(compileBoxes));

_ctrlBoxClassTree tvSortAll [[],false];
tvExpandAll _ctrlBoxClassTree;
_ctrlBoxClassTree ctrlShow false;

[_ctrlBoxClassTree,"KillFocus",{
	params ["_ctrlBoxClassTree"];
	_ctrlBoxClassTree ctrlShow false;
},[_display,_ctrlBoxClassTree]] call CBA_fnc_addBISEventHandler;

[_ctrlBoxClassTree,"TreeDblClick",{
	params ["_ctrlBoxClassTree","_path"];
	_thisArgs params ["_ctrlBoxClass"];

	private _class = _ctrlBoxClassTree tvData _path;
	if (_class != "") then {_ctrlBoxClass ctrlSetText _class};

	_ctrlBoxClassTree ctrlShow false;
},_ctrlBoxClass] call CBA_fnc_addBISEventHandler;
