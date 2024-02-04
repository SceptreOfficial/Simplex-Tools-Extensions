#include "..\script_component.hpp"

params ["_box","_unit","_args"];
_args params ["_vehicle","_class","_name","_cost","_buildTime","_initFnc","_pos","_dir","_up"];

if (isServer) then {
	GVAR(constructionBoxes) pushBack _box;
	publicVariable QGVAR(constructionBoxes);

	_box addEventHandler ["Deleted",{
		params ["_box"];
		GVAR(constructionBoxes) deleteAt (GVAR(constructionBoxes) find _box);
		publicVariable QGVAR(constructionBoxes);
	}];
};

if (!isNil QGVAR(ghosts)) then {
	private _ghost = _class createVehicleLocal [0,0,0];
	_ghost disableCollisionWith _vehicle;
	_ghost disableCollisionWith _unit;
	_ghost setVectorDirAndUp [_dir,_up];
	_ghost setPosWorld _pos;
	_ghost hideObject true;
	GVAR(ghosts) pushBack _ghost;
};

private _distance = 2.5 max (0.65 * (_class call EFUNC(common,sizeOf)));

// Main node action
[_box,0,[],
	[QGVAR(constructionActions),LLSTRING(constructionActions),QPATHTOF(data\hammer.paa),{},{
		isNull (_this # 0 getVariable [QGVAR(builder),objNull])// && "ACE_Fortify" in (_this # 1 call ace_common_fnc_uniqueItems)
	},{},[],nil,_distance] call ace_interact_menu_fnc_createAction
] call ace_interact_menu_fnc_addActionToObject;

// Build action
[_box,0,[QGVAR(constructionActions)],
	[QGVAR(constructionBuild),format ["%1: %2",LLSTRING(build),_name],QPATHTOF(data\hammer.paa),FUNC(constructionBuild),{true},{},[],nil,_distance] call ace_interact_menu_fnc_createAction
] call ace_interact_menu_fnc_addActionToObject;

// Refund action
[_box,0,[QGVAR(constructionActions)],
	[QGVAR(constructionRefund),format ["%1: %2",LLSTRING(refund),_name],"\A3\3den\data\displays\display3den\toolbar\undo_ca.paa",{
		params ["_box"];

		_box getVariable [QGVAR(construction),[]] params ["_vehicle","_class","_name","_cost","_buildTime","_initFnc","_pos","_dir","_up"];
		
		deleteVehicle _box;

		if (isNull _vehicle) exitWith {
			LLSTRING(constructionRemovedNoParent) call EFUNC(common,hint);
		};

		private _budget = _vehicle getVariable [QGVAR(constructionBudget),1e39];
		private _maxBudget = _vehicle getVariable [QGVAR(constructionMaxBudget),1e39];
		
		_vehicle setVariable [QGVAR(constructionBudget),(_budget + _cost) min _maxBudget,true];

		if (_budget + _cost >= _maxBudget) then {
			LLSTRING(constructionRemovedMax) call EFUNC(common,hint);
		} else {
			LLSTRING(constructionRemoved) call EFUNC(common,hint);
		};

		[QGVAR(constructionCancelled),[_vehicle,_class,_name,_cost,_buildTime,_initFnc,_pos,_dir,_up]] call CBA_fnc_globalEvent;
	},{true},{},[],nil,_distance] call ace_interact_menu_fnc_createAction
] call ace_interact_menu_fnc_addActionToObject;
