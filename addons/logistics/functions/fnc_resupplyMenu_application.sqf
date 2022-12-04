#include "script_component.hpp"

[_ctrlApplication,"LBSelChanged",{
	params ["_ctrlApplication","_lbCurSel"];

	private _ctrlGroup = ctrlParentControlsGroup _ctrlApplication;
	private _display = ctrlParent _ctrlGroup;
	private _ctrlApplicationGroup = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_APPLICATION_GROUP;
	private _applicationHeight = 1;

	{[_x,false] call EFUNC(sdf,show)} forEach (allControls _ctrlApplicationGroup);

	{[_ctrlApplicationGroup controlsGroupCtrl _x,true] call EFUNC(sdf,show)} forEach (switch _lbCurSel do {
		case 0 : {
			_applicationHeight = 1;

			[
				IDC_RESUPPLY_BOX_CLASS_TEXT,
				IDC_RESUPPLY_BOX_CLASS_PICKER,
				IDC_RESUPPLY_BOX_CLASS
			]
		};
		case 1 : {
			_applicationHeight = 3;

			[
				IDC_RESUPPLY_BOX_CLASS_TEXT,
				IDC_RESUPPLY_BOX_CLASS_PICKER,
				IDC_RESUPPLY_BOX_CLASS,
				IDC_RESUPPLY_CARGO_TYPE_TEXT,
				IDC_RESUPPLY_CARGO_TYPE,
				IDC_RESUPPLY_UNLOAD_TIME_TEXT,
				IDC_RESUPPLY_UNLOAD_TIME,
				IDC_RESUPPLY_UNLOAD_TIME_EDIT
			]
		};
		case 2 : {
			_applicationHeight = 3;

			[
				IDC_RESUPPLY_BOX_CLASS_TEXT,
				IDC_RESUPPLY_BOX_CLASS_PICKER,
				IDC_RESUPPLY_BOX_CLASS,
				IDC_RESUPPLY_HEIGHT_TEXT,
				IDC_RESUPPLY_HEIGHT,
				IDC_RESUPPLY_SIGNALS_TEXT,
				IDC_RESUPPLY_SIGNAL1,
				IDC_RESUPPLY_SIGNAL2
			]
		};
		case 3 : {
			_applicationHeight = 7;

			[
				IDC_RESUPPLY_BOX_CLASS_TEXT,
				IDC_RESUPPLY_BOX_CLASS_PICKER,
				IDC_RESUPPLY_BOX_CLASS,
				IDC_RESUPPLY_HEIGHT_TEXT,
				IDC_RESUPPLY_HEIGHT,
				IDC_RESUPPLY_SIGNALS_TEXT,
				IDC_RESUPPLY_SIGNAL1,
				IDC_RESUPPLY_SIGNAL2,
				IDC_RESUPPLY_SIDE_TEXT,
				IDC_RESUPPLY_SIDE,
				IDC_RESUPPLY_FACTION_TEXT,
				IDC_RESUPPLY_FACTION,
				IDC_RESUPPLY_CATEGORY_TEXT,
				IDC_RESUPPLY_CATEGORY,
				IDC_RESUPPLY_VEHICLE_TEXT,
				IDC_RESUPPLY_VEHICLE
			]
		};
	});

	private _ctrlApplicationGroupBG = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_APPLICATION_BG;

	[_ctrlApplicationGroupBG,[0,1,20,_applicationHeight],true,false] call EFUNC(sdf,setPosition);
	_ctrlApplicationGroupBG ctrlCommit GVAR(uiSpeed);

	[_ctrlApplicationGroup,[0,1,20,_applicationHeight]] call EFUNC(sdf,setPosition);
	_ctrlApplicationGroup ctrlCommit GVAR(uiSpeed);

	private _ctrlContents = _display displayCtrl IDC_RESUPPLY_CONTENTS;
	private _ctrlContentsText = _display displayCtrl IDC_RESUPPLY_CONTENTS_TEXT;
	private _ctrlContentsBG = _display displayCtrl IDC_RESUPPLY_CONTENTS_BG;
	private _ctrlContentsGroup = _display displayCtrl IDC_RESUPPLY_CONTENTS_GROUP;
	private _contentHeight = _ctrlContents getVariable [QGVAR(contentHeight),1];

	_ctrlContents setVariable [QGVAR(applicationHeight),_applicationHeight];

	[_ctrlContentsText,[0,_applicationHeight + 1,8,1]] call EFUNC(sdf,setPosition);
	_ctrlContentsText ctrlCommit GVAR(uiSpeed);
	[_ctrlContents,[8,_applicationHeight + 1,12,1]] call EFUNC(sdf,setPosition);
	_ctrlContents ctrlCommit GVAR(uiSpeed);
	[_ctrlContentsBG,[0,_applicationHeight + 2,20,_contentHeight],true,false] call EFUNC(sdf,setPosition);
	_ctrlContentsBG ctrlCommit GVAR(uiSpeed);
	[_ctrlContentsGroup,[0,_applicationHeight + 2,20,_contentHeight]] call EFUNC(sdf,setPosition);
	_ctrlContentsGroup ctrlCommit GVAR(uiSpeed);
}] call CBA_fnc_addBISEventHandler;
