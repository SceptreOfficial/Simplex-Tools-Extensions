#include "script_component.hpp"

removeMissionEventHandler ["EachFrame",_vehicle getVariable [QGVAR(strafeSimEHID),-1]];
_vehicle removeEventHandler ["Fired",_vehicle getVariable [QGVAR(strafeFiredEHID),-1]];

_vehicle setVariable [QGVAR(strafeSimEHID),nil];
_vehicle setVariable [QGVAR(strafeFiredEHID),nil];
_vehicle setVariable [QGVAR(strafe),nil,true];
_vehicle setVariable [QGVAR(strafeCancel),nil,true];

private _driver = driver _vehicle;

{
	[QGVAR(enableAIFeature),[_driver,_x],_driver] call CBA_fnc_targetEvent;
} forEach (_driver getVariable [QGVAR(strafeAIFeatures),[["AUTOTARGET",true],["TARGET",true]]]);

_driver setVariable [QGVAR(strafeAIFeatures),nil,true];

[QGVAR(strafeCleanup),[_vehicle]] call CBA_fnc_localEvent;

//private _entity = _vehicle getVariable [QPVAR(entity),objNull];
//
//if (!isNull _entity) then {
//	[QEGVAR(common,flyInHeight),[
//		_vehicle,
//		_entity getVariable [QPVAR(flyHeightATL),_vehicle getVariable [QGVAR(strafeHeight),100]]
//	],_vehicle] call CBA_fnc_targetEvent;
//};

[QEGVAR(common,flyInHeightASL),[
	_vehicle,
	(_vehicle getVariable [QPVAR(entity),objNull]) getVariable [QPVAR(flyHeightASL),100]
],_vehicle] call CBA_fnc_targetEvent;

