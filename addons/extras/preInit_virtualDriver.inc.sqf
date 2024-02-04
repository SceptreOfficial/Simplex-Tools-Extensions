[
	QGVAR(virtualDriverAllow),
	"CHECKBOX",
	[LSTRING(virtualDriverAllowName),LSTRING(virtualDriverAllowInfo)],
	[LSTRING(category),LSTRING(virtualDriver)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(virtualDriverRemoveOnExit),
	"CHECKBOX",
	[LSTRING(virtualDriverRemoveOnExitName),LSTRING(virtualDriverRemoveOnExitInfo)],
	[LSTRING(category),LSTRING(virtualDriver)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(virtualDriverClone),
	"CHECKBOX",
	[LSTRING(virtualDriverCloneName),LSTRING(virtualDriverCloneInfo)],
	[LSTRING(category),LSTRING(virtualDriver)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

private _actionParent = [
	QGVAR(virtualDriver),
	LLSTRING(virtualDriver),
	QPATHTOF(data\virtual_driver.paa),
	{},
	{true}
] call ace_interact_menu_fnc_createAction;

private _actionCreate = [
	QGVAR(virtualDriverCreate),
	LLSTRING(create),
	QPATHTOF(data\plus.paa),
	{[_this # 1,GVAR(virtualDriverClone)] call FUNC(virtualDriver)},
	{
		params ["_vehicle","_player"];

		GVAR(virtualDriverAllow) &&
		isNull (_vehicle getVariable [QGVAR(virtualDriver),objNull]) &&
		{_player in [gunner _vehicle,commander _vehicle]} &&
		{!(_vehicle isKindOf "StaticWeapon")}
	}
] call ace_interact_menu_fnc_createAction;

private _actionRemove = [
	QGVAR(virtualDriverRemove),
	LLSTRING(remove),
	"\A3\3DEN\Data\cfg3den\history\deleteitems_ca.paa",
	{(_this # 0) deleteVehicleCrew ((_this # 0) getVariable [QGVAR(virtualDriver),objNull])},
	{!isNull ((_this # 0) getVariable [QGVAR(virtualDriver),objNull])}
] call ace_interact_menu_fnc_createAction;

private _actionEngine = [
	QGVAR(virtualDriverRemove),
	LLSTRING(toggleEngine),
	"\a3\ui_f\data\igui\cfg\vehicletoggles\engineiconon_ca.paa",
	{[QEGVAR(common,execute),[_this # 0,{_this engineOn !(isEngineOn _this)}],_this # 0] call CBA_fnc_targetEvent},
	{!isNull ((_this # 0) getVariable [QGVAR(virtualDriver),objNull])}
] call ace_interact_menu_fnc_createAction;

{
	[_x,1,["ACE_SelfActions"],_actionParent,true] call ace_interact_menu_fnc_addActionToClass;
	[_x,1,["ACE_SelfActions",QGVAR(virtualDriver)],_actionCreate,true] call ace_interact_menu_fnc_addActionToClass;
	[_x,1,["ACE_SelfActions",QGVAR(virtualDriver)],_actionRemove,true] call ace_interact_menu_fnc_addActionToClass;
	[_x,1,["ACE_SelfActions",QGVAR(virtualDriver)],_actionEngine,true] call ace_interact_menu_fnc_addActionToClass;
} forEach ["LandVehicle","Air","Ship"];

["CAManBase","GetOutMan",{
	params ["_unit","","_vehicle"];
	
	if (!local _unit) exitWith {};

	if (_unit == _vehicle getVariable [QGVAR(virtualDriverCreator),objNull] && GVAR(virtualDriverRemoveOnExit)) then {
		_vehicle deleteVehicleCrew (_vehicle getVariable [QGVAR(virtualDriver),objNull]);
	};
}] call CBA_fnc_addClassEventHandler;

["CAManBase","Killed",{
	params ["_unit"];

	if (!local _unit) exitWith {};

	private _vehicle = vehicle _unit;

	if (_unit == _vehicle getVariable [QGVAR(virtualDriverCreator),objNull] && GVAR(virtualDriverRemoveOnExit)) then {
		_vehicle deleteVehicleCrew (_vehicle getVariable [QGVAR(virtualDriver),objNull]);
	};
}] call CBA_fnc_addClassEventHandler;

if (isServer) then {
	[QGVAR(virtualDriverCreated),{
		params ["_driver","_vehicle","_unit"];

		_driver addEventHandler ["GetOutMan",{
			params ["_unit","_role","_vehicle","_turret"];
			deleteVehicle _unit;
		}];

		_driver addEventHandler ["SeatSwitchedMan",{
			params ["_unit1","_unit2","_vehicle"];
			_vehicle deleteVehicleCrew _unit1;
		}];
	}] call CBA_fnc_addEventHandler;	
};
