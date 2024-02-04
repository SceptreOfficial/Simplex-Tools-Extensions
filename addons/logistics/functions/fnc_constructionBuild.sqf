#include "..\script_component.hpp"

params ["_box","_unit"];

_box getVariable [QGVAR(construction),[]] params ["_vehicle","_class","_name","_cost","_buildTime","_initFnc","_pos","_dir","_up"];

_box setVariable [QGVAR(builder),_unit,true];

[_unit,"AinvPknlMstpSnonWnonDnon_medic4"] call ace_common_fnc_doAnimation;

GVAR(nextConstructionProgressUpdate) = CBA_missionTime + 1;
private _progress = _box getVariable [QGVAR(constructionProgress),1];

[format [LLSTRING(building),floor linearConversion [_buildTime,0,_progress,0,100,true],"%"],_progress,{
	(_this # 0) params ["_vehicle","_unit","_box","_buildTime"];

	if (CBA_missionTime > GVAR(nextConstructionProgressUpdate)) then {
		// Update construction progress
		GVAR(nextConstructionProgressUpdate) = CBA_missionTime + 1;
		private _progress = (_box getVariable [QGVAR(constructionProgress),1]) - 1;
		_box setVariable [QGVAR(constructionProgress),_progress,true];
		
		// Update progress bar title
		private _ctrlTitle = uiNamespace getVariable "CBA_UI_ProgressBar" displayCtrl 10;
		_ctrlTitle ctrlSetText format [LLSTRING(building),floor linearConversion [_buildTime,0,_progress,0,100,true],"%"];
	};

	// Make sure player is conscious and the only person building the object
	_unit call ace_common_fnc_isAwake && alive _box && _box getVariable [QGVAR(builder),objNull] == _unit
},{
	(_this # 0) params ["_vehicle","_unit","_box","","_class","_initFnc","_pos","_dir","_up"];

	// Stop player animation
	[_unit,"",1] call ace_common_fnc_doAnimation;

	// Remove placeholder box
	deleteVehicle _box;

	// Create object
	private _object = _class createVehicle [0,0,0];
	_object setPosWorld _pos;
	_object setVectorDirAndUp [_dir,_up];
	_object setVariable [QGVAR(constructionPos),_pos,true];

	// Exec custom init
	_object call _initFnc;
	_object call (_vehicle getVariable [QGVAR(constructionInitFnc),{}]);

	// Move player out of object if necessary
	private _ix = lineIntersectsSurfaces [_unit modelToWorldWorld [0,-0.5,0],_unit modelToWorldWorld [0,-20,0],_unit,objNull,true,1,"GEOM","NONE"];
	if (!(_ix isEqualTo []) && {_ix # 0 # 2 == _object}) then {
		private _ixPos = _ix # 0 # 0;
		_unit setPosWorld (_ixPos vectorAdd (getPosWorld _unit vectorFromTo _ixPos));
	};

	// CBA Event
	private _JIPID = [QGVAR(objectBuilt),[_object,_unit]] call CBA_fnc_globalEventJIP;
	[_JIPID,_object] call CBA_fnc_removeGlobalEventJIP;
},{
	(_this # 0) params ["_vehicle","_unit","_box"];
	
	if (_box getVariable [QGVAR(builder),objNull] == _unit) then {
		_box setVariable [QGVAR(builder),objNull,true];
	};

	[_unit,"",1] call ace_common_fnc_doAnimation;
},[_vehicle,_unit,_box,_buildTime,_class,_initFnc,_pos,_dir,_up]] spawn CBA_fnc_progressBar;
