#include "script_component.hpp"

params ["_unit","_helper","_object","_construction"];
_construction params ["_vehicle","_class","_name","_cost","_buildTime","_initFnc"];

// Handle the vehicle's budget
private _budget = _vehicle getVariable [QGVAR(constructionBudget),0];

if (_budget < _cost) exitWith {
	LLSTRING(constructionNoCredit) call EFUNC(common,hint);
};

_vehicle setVariable [QGVAR(constructionBudget),_budget - _cost,true];

// Create build box
private _pos = getPosWorldVisual _helper;
private _dir = vectorDirVisual _helper;
private _up = vectorUpVisual _helper;

_construction append [_pos,_dir,_up];

private _box = "Land_WoodenBox_02_F" createVehicle [0,0,0];
_box setObjectMaterialGlobal [0,"\a3\data_f\default.rvmat"];
_box setObjectTextureGlobal [0,"#(rgb,8,8,3)color(1,1,1,0.5)"];
_box setPosWorld _pos;
_box setVectorDirAndUp [_dir,_up];
_box setVariable [QGVAR(constructionParent),_vehicle,true];
_box setVariable [QGVAR(construction),_construction,true];
_box setVariable [QGVAR(constructionProgress),_buildTime,true];
_box setVariable [QGVAR(builder),objNull,true];

private _JIPID = [QGVAR(constructionPlaced),[_box,_unit,_construction]] call CBA_fnc_globalEventJIP;
[_JIPID,_box] call CBA_fnc_removeGlobalEventJIP;