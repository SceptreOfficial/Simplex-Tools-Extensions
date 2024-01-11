#include "script_component.hpp"
#include "\z\stx\addons\sdf\gui_macros.hpp"

params ["_display"];

uiNamespace setVariable [QEGVAR(sdf,display),_display];
uiNamespace setVariable [QEGVAR(sdf,displayClass),QGVAR(ResupplyMenu)];
private _ctrlGroup = _display displayCtrl IDC_GROUP;
GVAR(uiSpeed) = 0;

[_display displayCtrl IDC_CLOSE,"ButtonClick",{closeDialog 0}] call CBA_fnc_addBISEventHandler;

[_display displayCtrl IDC_CONFIRM,"ButtonClick",{
	_thisArgs params ["_display"];

	call FUNC(resupplyMenu_cache);
	call FUNC(resupplyMenu_confirm);

	closeDialog 0;
},_display] call CBA_fnc_addBISEventHandler;

private _ctrlApplication = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_APPLICATION;
private _ctrlApplicationGroup = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_APPLICATION_GROUP;
[] call FUNC(resupplyMenu_application);

private _ctrlContents = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_CONTENTS;
private _ctrlContentsGroup = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_CONTENTS_GROUP;
[] call FUNC(resupplyMenu_contents);

[_ctrlApplication,"",0,true] call EFUNC(sdf,getCache);
[_ctrlContents,"",0,true] call EFUNC(sdf,getCache);

[] call FUNC(resupplyMenu_boxClass);
[] call FUNC(resupplyMenu_cargoType);

private _ctrlCargoType = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_CARGO_TYPE;

//[_ctrlCargoType,"LBSelChanged",{
//	params ["_ctrlCargoType","_lbCurSel"];
//	_thisArgs params ["_ctrlApplicationGroup"];
//
//	(_ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_UNLOAD_TIME) ctrlEnable (_lbCurSel == 0);
//	(_ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_UNLOAD_TIME_EDIT) ctrlEnable (_lbCurSel == 0);
//},_ctrlApplicationGroup] call CBA_fnc_addBISEventHandler;

[_ctrlCargoType,"",0,true] call EFUNC(sdf,getCache);

private _ctrlUnloadTime = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_UNLOAD_TIME;
private _ctrlUnloadTimeEdit = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_UNLOAD_TIME_EDIT;

[_ctrlUnloadTime,_ctrlUnloadTimeEdit,[0,20,0],[_ctrlUnloadTime,"",5] call EFUNC(sdf,getCache)] call EFUNC(sdf,manageSlider);

private _ctrlHeight = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_HEIGHT;
[_ctrlHeight,"","100",true] call EFUNC(sdf,getCache);

[] call FUNC(resupplyMenu_airdropFlyby);
[] call FUNC(resupplyMenu_inventory);
[] call FUNC(resupplyMenu_arsenal);
[] call FUNC(resupplyMenu_autoFill);

GVAR(uiSpeed) = 0.1;
