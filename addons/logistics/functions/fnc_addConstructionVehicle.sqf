#include "script_component.hpp"

params [["_vehicle",objNull,[objNull]],["_maxBudget",1000,[0]],["_inventory",[],[[]]],["_initFnc",{},[{}]]];

[QEGVAR(common,execute),[[_vehicle,_maxBudget,_inventory,_initFnc],{
	params ["_vehicle","_maxBudget","_inventory","_initFnc"];

	if (_vehicle getVariable [QGVAR(constructionVehicle),false]) exitWith {};

	private _cfgVehicles = configFile >> "CfgVehicles";
	
	_inventory = _inventory apply {
		_x params [["_class","",[""]],["_name","",[""]],["_cost",0,[0]],["_buildTime",-1,[0]],["_initFnc",{},[{}]]];

		if (_name isEqualTo "") then {
			_name = format ["%1 ($%2)",getText (_cfgVehicles >> _class >> "displayName"),_cost];
		} else {
			_name = format ["%1 ($%2)",_name,_cost];
		};

		if (_buildTime < 0) then {
			_buildTime = 2 * (_class call EFUNC(common,sizeOf));
		};
		
		[_class,_name,_cost,_buildTime,_initFnc]
	};

	_vehicle setVariable [QGVAR(constructionVehicle),true,true];
	_vehicle setVariable [QGVAR(constructionMaxBudget),_maxBudget,true];
	_vehicle setVariable [QGVAR(constructionBudget),_maxBudget,true];
	_vehicle setVariable [QGVAR(constructionInventory),_inventory,true];
	_vehicle setVariable [QGVAR(constructionInitFnc),_initFnc,true];

	private _JIPID = [QGVAR(constructionVehicleAdded),[_vehicle,_maxBudget]] call CBA_fnc_globalEventJIP;
	[_JIPID,_vehicle] call CBA_fnc_removeGlobalEventJIP;
	_vehicle setVariable [QGVAR(constructionVehicleJIPID),_JIPID,true];
}]] call CBA_fnc_serverEvent;
