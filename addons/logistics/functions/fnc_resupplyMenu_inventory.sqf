#include "script_component.hpp"

private _ctrlBoxClass = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS;

private _ctrlCapacityLimit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_CAPACITY_LIMIT;
[_ctrlCapacityLimit,"",false,true] call EFUNC(sdf,getCache);

private _ctrlEditInventory = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_EDIT_INV;
private _ctrlPresetsCategory = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PRESETS_CATEGORY;
private _ctrlPresets = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PRESETS;
private _ctrlPresetName = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PRESETS_NAME;
private _ctrlPresetSave = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PRESETS_SAVE;
private _ctrlPresetRename = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PRESETS_RENAME;
private _ctrlPresetLoad = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PRESETS_LOAD;
private _ctrlPresetDelete = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PRESETS_DELETE;

[_ctrlEditInventory,"ButtonClick",{
	_thisArgs params ["_display","_ctrlCapacityLimit","_ctrlBoxClass"];
	
	private _boxClass = ctrlText _ctrlBoxClass;
	if (!isClass (configFile >> "CfgVehicles" >> _boxClass)) exitWith {LOG_WARNING("INVALID BOX CLASS")};
	private _maxLoad = [nil,getNumber (configFile >> "CfgVehicles" >> _boxClass >> "maximumLoad")] select (cbChecked _ctrlCapacityLimit);

	{_x ctrlShow false} forEach [
		_display displayCtrl IDC_TITLE,
		_display displayCtrl IDC_BG,
		_display displayCtrl IDC_CANCEL,
		_display displayCtrl IDC_CONFIRM,
		_display displayCtrl IDC_GROUP
	];

	[GVAR(resupplyInventory),{
		params ["_dummy","_display"];

		GVAR(resupplyInventory) = [_dummy,0] call EFUNC(common,getCargo);

		{_x ctrlShow true} forEach [
			_display displayCtrl IDC_TITLE,
			_display displayCtrl IDC_BG,
			_display displayCtrl IDC_CANCEL,
			_display displayCtrl IDC_CONFIRM,
			_display displayCtrl IDC_GROUP
		];

		((_display displayCtrl IDC_GROUP) controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS_TREE) ctrlShow false;
	},_display,_boxClass,_maxLoad] call FUNC(inventoryDummy);
},[_display,_ctrlCapacityLimit,_ctrlBoxClass]] call CBA_fnc_addBISEventHandler;

[_ctrlPresetsCategory,"LBSelChanged",{
	params ["_ctrlPresetsCategory","_lbCurSel"];
	_thisArgs params ["_ctrlPresets","_ctrlPresetName"];

	lbClear _ctrlPresets;

	switch _lbCurSel do {
		case 0 : {
			{_ctrlPresets lbAdd _x} forEach (missionNamespace getVariable [QGVAR(cargoPresets),createHashMap]);
		};
		case 1 : {
			{_ctrlPresets lbAdd _x} forEach (profileNamespace getVariable [QGVAR(cargoPresets),createHashMap]);
		};
	};

	lbSort _ctrlPresets;
	_ctrlPresets lbSetCurSel -1;
	_ctrlPresetName ctrlSetText "";
},[_ctrlPresets,_ctrlPresetName]] call CBA_fnc_addBISEventHandler;

[_ctrlPresetsCategory,"",0,true] call EFUNC(sdf,getCache);

[_ctrlPresets,"LBSelChanged",{
	params ["_ctrlPresets","_lbCurSel"];
	_thisArgs ctrlSetText (_ctrlPresets lbText _lbCurSel);
},_ctrlPresetName] call CBA_fnc_addBISEventHandler;

[_ctrlPresetSave,"ButtonClick",{
	_thisArgs params ["_ctrlPresetsCategory","_ctrlPresets","_ctrlPresetName"];

	private _preset = ctrlText _ctrlPresetName;

	if (_preset isEqualTo "") exitWith {};

	private _presets = switch (lbCurSel _ctrlPresetsCategory) do {
		case 0 : {missionNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
		case 1 : {profileNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
	};

	if !(_preset in keys _presets) then {
		_ctrlPresets lbSetCurSel (_ctrlPresets lbAdd _preset);
		lbSort _ctrlPresets;
	};

	_presets set [_preset,+GVAR(resupplyInventory)];

	switch (lbCurSel _ctrlPresetsCategory) do {
		case 0 : {missionNamespace setVariable [QGVAR(cargoPresets),_presets,true]};
		case 1 : {
			profileNamespace setVariable [QGVAR(cargoPresets),_presets];
			saveProfileNamespace;
		};
	};
},[_ctrlPresetsCategory,_ctrlPresets,_ctrlPresetName]] call CBA_fnc_addBISEventHandler;

[_ctrlPresetRename,"ButtonClick",{
	_thisArgs params ["_ctrlPresetsCategory","_ctrlPresets","_ctrlPresetName"];

	private _preset = _ctrlPresets lbText lbCurSel _ctrlPresets;
	private _newName = ctrlText _ctrlPresetName;

	if (_newName isEqualTo "") exitWith {};

	private _presets = switch (lbCurSel _ctrlPresetsCategory) do {
		case 0 : {missionNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
		case 1 : {profileNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
	};

	_presets set [_newName,_presets get _preset];
	_presets deleteAt _preset;

	switch (lbCurSel _ctrlPresetsCategory) do {
		case 0 : {missionNamespace setVariable [QGVAR(cargoPresets),_presets,true]};
		case 1 : {
			profileNamespace setVariable [QGVAR(cargoPresets),_presets];
			saveProfileNamespace;
		};
	};

	_ctrlPresets lbSetText [lbCurSel _ctrlPresets,_newName];
	lbSort _ctrlPresets;
},[_ctrlPresetsCategory,_ctrlPresets,_ctrlPresetName]] call CBA_fnc_addBISEventHandler;

[_ctrlPresetLoad,"ButtonClick",{
	_thisArgs params ["_ctrlPresetsCategory","_ctrlPresets","_display","_ctrlCapacityLimit","_ctrlBoxClass"];

	private _preset = _ctrlPresets lbText lbCurSel _ctrlPresets;

	if (_preset isEqualTo "") exitWith {};

	private _boxClass = ctrlText _ctrlBoxClass;
	if (!isClass (configFile >> "CfgVehicles" >> _boxClass)) exitWith {LOG_WARNING("INVALID BOX CLASS")};
	private _maxLoad = [nil,getNumber (configFile >> "CfgVehicles" >> _boxClass >> "maximumLoad")] select (cbChecked _ctrlCapacityLimit);

	{_x ctrlShow false} forEach [
		_display displayCtrl IDC_TITLE,
		_display displayCtrl IDC_BG,
		_display displayCtrl IDC_CANCEL,
		_display displayCtrl IDC_CONFIRM,
		_display displayCtrl IDC_GROUP
	];

	private _presets = switch (lbCurSel _ctrlPresetsCategory) do {
		case 0 : {missionNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
		case 1 : {profileNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
	};

	GVAR(resupplyInventory) = _presets get _preset;

	[GVAR(resupplyInventory),{
		params ["_dummy","_display"];

		GVAR(resupplyInventory) = [_dummy,0] call EFUNC(common,getCargo);

		{_x ctrlShow true} forEach [
			_display displayCtrl IDC_TITLE,
			_display displayCtrl IDC_BG,
			_display displayCtrl IDC_CANCEL,
			_display displayCtrl IDC_CONFIRM,
			_display displayCtrl IDC_GROUP
		];

		((_display displayCtrl IDC_GROUP) controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS_TREE) ctrlShow false;
	},_display,_boxClass,_maxLoad] call FUNC(inventoryDummy);
},[_ctrlPresetsCategory,_ctrlPresets,_display,_ctrlCapacityLimit,_ctrlBoxClass]] call CBA_fnc_addBISEventHandler;

[_ctrlPresetDelete,"ButtonClick",{
	_thisArgs params ["_ctrlPresetsCategory","_ctrlPresets"];

	private _lbCurSel = lbCurSel _ctrlPresets;
	private _preset = _ctrlPresets lbText _lbCurSel;
	
	if (_preset isEqualTo "") exitWith {};

	private _presets = switch (lbCurSel _ctrlPresetsCategory) do {
		case 0 : {missionNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
		case 1 : {profileNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
	};

	_presets deleteAt _preset;
	
	switch (lbCurSel _ctrlPresetsCategory) do {
		case 0 : {missionNamespace setVariable [QGVAR(cargoPresets),_presets,true]};
		case 1 : {
			profileNamespace setVariable [QGVAR(cargoPresets),_presets];
			saveProfileNamespace;
		};
	};

	_ctrlPresets lbDelete _lbCurSel;
	_ctrlPresets lbSetCurSel ((_lbCurSel - 1) max 0);
},[_ctrlPresetsCategory,_ctrlPresets]] call CBA_fnc_addBISEventHandler;
