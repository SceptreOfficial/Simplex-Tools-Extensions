#include "..\script_component.hpp"

private _ctrlSide = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_SIDE;
private _ctrlFaction = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_FACTION;
private _ctrlCategory = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_CATEGORY;
private _ctrlVehicle = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_VEHICLE;

[_ctrlSide,"LBSelChanged",{
	params ["_ctrlSide","_lbCurSel"];
	_thisArgs params ["_ctrlFaction"];

	[_ctrlSide,"",_lbCurSel] call EFUNC(sdf,setCache);

	private _cfgFactionClasses = configFile >> "CfgFactionClasses";
	private _factions = keys (_lbCurSel call FUNC(compileAirdropVehicles));
	
	lbClear _ctrlFaction;
	
	{
		private _index = _ctrlFaction lbAdd getText (_cfgFactionClasses >> _x >> "displayName");
		_ctrlFaction lbSetPicture [_index,getText (_cfgFactionClasses >> _x >> "icon")];
		_ctrlFaction lbSetData [_index,_x];
	} forEach _factions;

	lbSort _ctrlFaction;
	_ctrlFaction setVariable [QGVAR(values),_factions];
	[_ctrlFaction,[QGVAR(resupplyFaction),_factions],0,true] call EFUNC(sdf,getCache);
},[_ctrlFaction]] call CBA_fnc_addBISEventHandler;

[_ctrlFaction,"LBSelChanged",{
	params ["_ctrlFaction","_lbCurSel"];
	_thisArgs params ["_ctrlSide","_ctrlCategory"];

	[_ctrlFaction,[QGVAR(resupplyFaction),_ctrlFaction getVariable QGVAR(values)],_lbCurSel] call EFUNC(sdf,setCache);

	private _cfgEditorSubcategories = configFile >> "CfgEditorSubcategories";
	private _categories = keys ((lbCurSel _ctrlSide call FUNC(compileAirdropVehicles)) get (_ctrlFaction lbData _lbCurSel));
	
	lbClear _ctrlCategory;
	
	{
		private _index = _ctrlCategory lbAdd getText (_cfgEditorSubcategories >> _x >> "displayName");
		_ctrlCategory lbSetPicture [_index,"#(argb,8,8,3)color(0,0,0,0)"];
		_ctrlCategory lbSetData [_index,_x];
	} forEach _categories;

	lbSort _ctrlCategory;
	_ctrlCategory setVariable [QGVAR(values),_categories];
	[_ctrlCategory,[QGVAR(resupplyCategory),_categories],0,true] call EFUNC(sdf,getCache);
},[_ctrlSide,_ctrlCategory]] call CBA_fnc_addBISEventHandler;

[_ctrlCategory,"LBSelChanged",{
	params ["_ctrlCategory","_lbCurSel"];
	_thisArgs params ["_ctrlSide","_ctrlFaction","_ctrlVehicle"];

	[_ctrlCategory,[QGVAR(resupplyCategory),_ctrlCategory getVariable QGVAR(values)],_lbCurSel] call EFUNC(sdf,setCache);

	private _cfgVehicles = configFile >> "CfgVehicles";
	private _vehicles = (lbCurSel _ctrlSide call FUNC(compileAirdropVehicles)) get (_ctrlFaction lbData lbCurSel _ctrlFaction) get (_ctrlCategory lbData _lbCurSel);

	lbClear _ctrlVehicle;
	
	{
		private _index = _ctrlVehicle lbAdd getText (_cfgVehicles >> _x >> "displayName");
		_ctrlVehicle lbSetPicture [_index,getText (_cfgVehicles >> _x >> "icon")];
		_ctrlVehicle lbSetData [_index,_x];
	} forEach _vehicles;

	lbSort _ctrlVehicle;
	_ctrlVehicle setVariable [QGVAR(values),_vehicles];
	[_ctrlVehicle,[QGVAR(resupplyVehicle),_vehicles],0,true] call EFUNC(sdf,getCache);
},[_ctrlSide,_ctrlFaction,_ctrlVehicle]] call CBA_fnc_addBISEventHandler;

[_ctrlVehicle,"LBSelChanged",{
	params ["_ctrlVehicle","_lbCurSel"];
	[_ctrlVehicle,[QGVAR(resupplyVehicle),_ctrlVehicle getVariable QGVAR(values)],_lbCurSel] call EFUNC(sdf,setCache);
}] call CBA_fnc_addBISEventHandler;

[_ctrlSide,"",0,true] call EFUNC(sdf,getCache);
