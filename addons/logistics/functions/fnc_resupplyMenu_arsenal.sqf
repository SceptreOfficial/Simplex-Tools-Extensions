#include "script_component.hpp"

private _ctrlWhitelist = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_WHITELIST;
private _ctrlWhitelistEdit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_WHITELIST_EDIT;
private _ctrlBlacklist = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_BLACKLIST;
private _ctrlBlacklistEdit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_BLACKLIST_EDIT;

[_ctrlWhitelist,"LBSelChanged",{
	params ["_ctrlWhitelist","_lbCurSel"];
	_thisArgs ctrlEnable (_lbCurSel in [2,3]);
},_ctrlWhitelistEdit] call CBA_fnc_addBISEventHandler;

[_ctrlBlacklist,"LBSelChanged",{
	params ["_ctrlBlacklist","_lbCurSel"];
	_thisArgs ctrlEnable (_lbCurSel in [2,3]);
},_ctrlBlacklistEdit] call CBA_fnc_addBISEventHandler;

[_ctrlWhitelist,"",0,true] call EFUNC(sdf,getCache);
[_ctrlBlacklist,"",1,true] call EFUNC(sdf,getCache);

[_ctrlWhitelistEdit,"ButtonClick",{
	params ["_ctrlWhitelistEdit"];
	_thisArgs params ["_display"];

	{_x ctrlShow false} forEach [
		_display displayCtrl IDC_TITLE,
		_display displayCtrl IDC_BG,
		_display displayCtrl IDC_CANCEL,
		_display displayCtrl IDC_CONFIRM,
		_display displayCtrl IDC_GROUP
	];

	[GVAR(resupplyWhitelist),{
		params ["_dummy","_display"];

		GVAR(resupplyWhitelist) = [_dummy,3] call EFUNC(common,getCargo);

		{_x ctrlShow true} forEach [
			_display displayCtrl IDC_TITLE,
			_display displayCtrl IDC_BG,
			_display displayCtrl IDC_CANCEL,
			_display displayCtrl IDC_CONFIRM,
			_display displayCtrl IDC_GROUP
		];

		((_display displayCtrl IDC_GROUP) controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS_TREE) ctrlShow false;
	},_display] call FUNC(inventoryDummy);
},_display] call CBA_fnc_addBISEventHandler;

[_ctrlBlacklistEdit,"ButtonClick",{
	params ["_ctrlBlacklistEdit"];
	_thisArgs params ["_display"];

	{_x ctrlShow false} forEach [
		_display displayCtrl IDC_TITLE,
		_display displayCtrl IDC_BG,
		_display displayCtrl IDC_CANCEL,
		_display displayCtrl IDC_CONFIRM,
		_display displayCtrl IDC_GROUP
	];

	[GVAR(resupplyBlacklist),{
		params ["_dummy","_display"];

		GVAR(resupplyBlacklist) = [_dummy,3] call EFUNC(common,getCargo);

		{_x ctrlShow true} forEach [
			_display displayCtrl IDC_TITLE,
			_display displayCtrl IDC_BG,
			_display displayCtrl IDC_CANCEL,
			_display displayCtrl IDC_CONFIRM,
			_display displayCtrl IDC_GROUP
		];

		((_display displayCtrl IDC_GROUP) controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS_TREE) ctrlShow false;
	},_display] call FUNC(inventoryDummy);
},_display] call CBA_fnc_addBISEventHandler;
