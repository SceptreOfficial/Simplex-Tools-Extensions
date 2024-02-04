#include "..\script_component.hpp"

params [["_cargo",objNull,[objNull,""]],["_posASL",[],[[]]],["_dirAndUp",[[0,1,0],[0,0,1]],[[]]]];

private _transport = _cargo getVariable [QGVAR(cargoParent),objNull];

if (isNull _transport) exitWith {false};

private _manifest = _transport getVariable [QGVAR(cargoManifest),[]];
_manifest deleteAt (_manifest find _cargo);
_transport setVariable [QGVAR(cargoManifest),_manifest,true];

if (_cargo isEqualType objNull && _posASL isNotEqualTo []) then {
	[QEGVAR(common,hideObjectGlobal),[_cargo,false]] call CBA_fnc_serverEvent;
	[QEGVAR(common,allowDamage),[_cargo,true],_cargo] call CBA_fnc_targetEvent;
	detach _cargo;
	_cargo setPosASL _posASL;
	_cargo setVectorDirAndUp _dirAndUp;
	_cargo setVariable [QGVAR(cargoParent),nil,true];
};

[QGVAR(cargoUnloaded),[_transport,_cargo]] call CBA_fnc_globalEvent;

true


