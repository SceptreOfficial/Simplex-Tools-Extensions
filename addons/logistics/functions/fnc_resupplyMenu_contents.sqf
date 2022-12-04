#include "script_component.hpp"

[_ctrlContents,"LBSelChanged",{
	params ["_ctrlContents","_lbCurSel"];

	private _ctrlGroup = ctrlParentControlsGroup _ctrlContents;
	private _display = ctrlParent _ctrlGroup;
	private _ctrlContentsGroup = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_CONTENTS_GROUP;
	private _contentHeight = 1;

	{[_x,false] call EFUNC(sdf,show)} forEach (allControls _ctrlContentsGroup);

	{[_ctrlContentsGroup controlsGroupCtrl _x,true] call EFUNC(sdf,show)} forEach (switch _lbCurSel do {
		case 0 : {
			_contentHeight = 9;

			[
				IDC_RESUPPLY_CAPACITY_LIMIT_TEXT,
				IDC_RESUPPLY_CAPACITY_LIMIT,
				IDC_RESUPPLY_EDIT_INV,
				IDC_RESUPPLY_PRESETS_CATEGORY_TEXT,
				IDC_RESUPPLY_PRESETS_CATEGORY,
				IDC_RESUPPLY_PRESETS_TEXT,
				IDC_RESUPPLY_PRESETS,
				IDC_RESUPPLY_PRESETS_NAME_TEXT,
				IDC_RESUPPLY_PRESETS_NAME,
				IDC_RESUPPLY_PRESETS_SAVE,
				IDC_RESUPPLY_PRESETS_RENAME,
				IDC_RESUPPLY_PRESETS_LOAD,
				IDC_RESUPPLY_PRESETS_DELETE
			]
		};
		case 1 : {
			_contentHeight = 13;

			[
				IDC_RESUPPLY_MUNITIONS,
				IDC_RESUPPLY_MEDICAL,
				IDC_RESUPPLY_MAGAZINE_COUNT_TEXT,
				IDC_RESUPPLY_MAGAZINE_MULTIPLY,
				IDC_RESUPPLY_MAGAZINE_COUNT,
				IDC_RESUPPLY_MAGAZINE_COUNT_EDIT,
				IDC_RESUPPLY_UNDERBARREL_COUNT_TEXT,
				IDC_RESUPPLY_UNDERBARREL_MULTIPLY,
				IDC_RESUPPLY_UNDERBARREL_COUNT,
				IDC_RESUPPLY_UNDERBARREL_COUNT_EDIT,
				IDC_RESUPPLY_ROCKET_COUNT_TEXT,
				IDC_RESUPPLY_ROCKET_MULTIPLY,
				IDC_RESUPPLY_ROCKET_COUNT,
				IDC_RESUPPLY_ROCKET_COUNT_EDIT,
				IDC_RESUPPLY_THROWABLE_COUNT_TEXT,
				IDC_RESUPPLY_THROWABLE_MULTIPLY,
				IDC_RESUPPLY_THROWABLE_COUNT,
				IDC_RESUPPLY_THROWABLE_COUNT_EDIT,
				IDC_RESUPPLY_PLACEABLE_COUNT_TEXT,
				IDC_RESUPPLY_PLACEABLE_MULTIPLY,
				IDC_RESUPPLY_PLACEABLE_COUNT,
				IDC_RESUPPLY_PLACEABLE_COUNT_EDIT,
				IDC_RESUPPLY_MEDICAL_COUNT_TEXT,
				IDC_RESUPPLY_MEDICAL_MULTIPLY,
				IDC_RESUPPLY_MEDICAL_COUNT,
				IDC_RESUPPLY_MEDICAL_COUNT_EDIT,
				IDC_RESUPPLY_UNITS_TEXT,
				IDC_RESUPPLY_UNITS_TOOLBOX,
				IDC_RESUPPLY_UNITS_LISTBOX
			]
		};
		case 2 : {
			_contentHeight = 2;

			[
				IDC_RESUPPLY_WHITELIST_TEXT,
				IDC_RESUPPLY_WHITELIST,
				IDC_RESUPPLY_WHITELIST_EDIT,
				IDC_RESUPPLY_BLACKLIST_TEXT,
				IDC_RESUPPLY_BLACKLIST,
				IDC_RESUPPLY_BLACKLIST_EDIT
			]
		};
	});

	private _ctrlContentsBG = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_CONTENTS_BG;
	private _applicationHeight = _ctrlContents getVariable [QGVAR(applicationHeight),1];

	_ctrlContents setVariable [QGVAR(contentHeight),_contentHeight];

	[_ctrlContentsBG,[0,_applicationHeight + 2,20,_contentHeight],true,false] call EFUNC(sdf,setPosition);
	_ctrlContentsBG ctrlCommit GVAR(uiSpeed);
	[_ctrlContentsGroup,[0,_applicationHeight + 2,20,_contentHeight]] call EFUNC(sdf,setPosition);
	_ctrlContentsGroup ctrlCommit GVAR(uiSpeed);
}] call CBA_fnc_addBISEventHandler;
