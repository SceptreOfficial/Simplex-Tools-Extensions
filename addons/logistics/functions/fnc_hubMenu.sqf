#include "script_component.hpp"
#include "\z\stx\addons\sdf\gui_macros.hpp"

params ["_display"];

uiNamespace setVariable [QEGVAR(sdf,display),_display];
uiNamespace setVariable [QEGVAR(sdf,displayClass),QGVAR(HubMenu)];
private _ctrlGroup = _display displayCtrl IDC_GROUP;

// Get controls
[
	IDC_HUB_EDITINV,
	IDC_HUB_BOXSPAWN,
	IDC_HUB_CANTEEN,
	IDC_HUB_CONSTRUCTION,
	IDC_HUB_ARSENAL,
	IDC_HUB_WHITELIST,
	IDC_HUB_WHITELIST_EDIT,
	IDC_HUB_BLACKLIST,
	IDC_HUB_BLACKLIST_EDIT
] apply {_ctrlGroup controlsGroupCtrl _x} params [
	"_ctrlEditInv",
	"_ctrlBoxSpawn",
	"_ctrlCanteen",
	"_ctrlConstruction",
	"_ctrlArsenal",
	"_ctrlWhitelist",
	"_ctrlWhitelistEdit",
	"_ctrlBlacklist",
	"_ctrlBlacklistEdit"
];

// Cancel button
[_display displayCtrl IDC_CANCEL,"ButtonClick",{closeDialog 0}] call CBA_fnc_addBISEventHandler;

// Confirm button
[_display displayCtrl IDC_CONFIRM,"ButtonClick",{
	_thisArgs params [
		"_display",
		"_ctrlEditInv",
		"_ctrlBoxSpawn",
		"_ctrlCanteen",
		"_ctrlConstruction",
		"_ctrlArsenal",
		"_ctrlWhitelist",
		"_ctrlBlacklist"
	];

	[
		GVAR(hubObject),
		[_ctrlEditInv,"",cbChecked _ctrlEditInv] call EFUNC(sdf,setCache),
		[_ctrlBoxSpawn,"",cbChecked _ctrlBoxSpawn] call EFUNC(sdf,setCache),
		[_ctrlCanteen,"",cbChecked _ctrlCanteen] call EFUNC(sdf,setCache),
		[_ctrlConstruction,"",cbChecked _ctrlConstruction] call EFUNC(sdf,setCache),
		[_ctrlArsenal,"",cbChecked _ctrlArsenal] call EFUNC(sdf,setCache),
		[_ctrlWhitelist,"",lbCurSel _ctrlWhitelist] call EFUNC(sdf,setCache),
		flatten (GVAR(hubWhitelist) apply {_x apply {_x # 0}}),
		[_ctrlBlacklist,"",lbCurSel _ctrlBlacklist] call EFUNC(sdf,setCache),
		flatten (GVAR(hubBlacklist) apply {_x apply {_x # 0}})
	] call FUNC(addHub);

	GVAR(hubObject) = nil;

	closeDialog 0;
},[
	_display,
	_ctrlEditInv,
	_ctrlBoxSpawn,
	_ctrlCanteen,
	_ctrlConstruction,
	_ctrlArsenal,
	_ctrlWhitelist,
	_ctrlBlacklist
]] call CBA_fnc_addBISEventHandler;

// Init control values
_ctrlEditInv cbSetChecked ([_ctrlEditInv,"",true] call EFUNC(sdf,getCache));
_ctrlBoxSpawn cbSetChecked ([_ctrlBoxSpawn,"",true] call EFUNC(sdf,getCache));
_ctrlCanteen cbSetChecked ([_ctrlCanteen,"",true] call EFUNC(sdf,getCache));
_ctrlConstruction cbSetChecked ([_ctrlConstruction,"",true] call EFUNC(sdf,getCache));

// Handle arsenal checkbox and dropdowns
[_ctrlArsenal,"CheckedChanged",{
	params ["_ctrlArsenal","_checked"];
	_checked = _checked == 1;
	_thisArgs params ["_ctrlWhitelist","_ctrlWhitelistEdit","_ctrlBlacklist","_ctrlBlacklistEdit"];

	_ctrlWhitelist ctrlEnable _checked;
	_ctrlWhitelistEdit ctrlEnable (_checked && lbCurSel _ctrlWhitelist in [2,3]);
	_ctrlBlacklist ctrlEnable _checked;
	_ctrlBlacklistEdit ctrlEnable (_checked && lbCurSel _ctrlBlacklist in [2,3]);
},[_ctrlWhitelist,_ctrlWhitelistEdit,_ctrlBlacklist,_ctrlBlacklistEdit]] call CBA_fnc_addBISEventHandler;

_ctrlArsenal cbSetChecked ([_ctrlArsenal,"",true] call EFUNC(sdf,getCache));

// Custom whitelist/blacklist buttons
[_ctrlWhitelist,"LBSelChanged",{
	params ["_ctrlWhitelist","_lbCurSel"];
	_thisArgs ctrlEnable (_lbCurSel in [2,3]);
},_ctrlWhitelistEdit] call CBA_fnc_addBISEventHandler;

[_ctrlBlacklist,"LBSelChanged",{
	params ["_ctrlBlacklist","_lbCurSel"];
	_thisArgs ctrlEnable (_lbCurSel in [2,3]);
},_ctrlBlacklistEdit] call CBA_fnc_addBISEventHandler;

_ctrlWhitelist lbSetCurSel ([_ctrlWhitelist,"",0] call EFUNC(sdf,getCache));
_ctrlBlacklist lbSetCurSel ([_ctrlBlacklist,"",1] call EFUNC(sdf,getCache));

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

	[GVAR(hubWhitelist),{
		params ["_dummy","_display"];

		GVAR(hubWhitelist) = [_dummy,3] call EFUNC(common,getCargo);

		{_x ctrlShow true} forEach [
			_display displayCtrl IDC_TITLE,
			_display displayCtrl IDC_BG,
			_display displayCtrl IDC_CANCEL,
			_display displayCtrl IDC_CONFIRM,
			_display displayCtrl IDC_GROUP
		];
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

	[GVAR(hubBlacklist),{
		params ["_dummy","_display"];

		GVAR(hubBlacklist) = [_dummy,3] call EFUNC(common,getCargo);

		{_x ctrlShow true} forEach [
			_display displayCtrl IDC_TITLE,
			_display displayCtrl IDC_BG,
			_display displayCtrl IDC_CANCEL,
			_display displayCtrl IDC_CONFIRM,
			_display displayCtrl IDC_GROUP
		];
	},_display] call FUNC(inventoryDummy);
},_display] call CBA_fnc_addBISEventHandler;