#include "script_component.hpp"

params [["_transport",objNull,[objNull]],["_cargo",objNull,[objNull,""]],["_offset",[0,0,-100],[[]]],["_dirAndUp",[[0,1,0],[0,0,1]],[[]]]];

[_cargo] call FUNC(cargoUnload);

private _manifest = _transport getVariable [QGVAR(cargoManifest),[]];
_manifest pushBack _cargo;
_transport setVariable [QGVAR(cargoManifest),_manifest,true];

if (_cargo isEqualType objNull) then {
	if (_offset isEqualTo [0,0,-100]) then {
		[QEGVAR(common,hideObjectGlobal),[_cargo,true]] call CBA_fnc_serverEvent;
	};
	
	[QEGVAR(common,allowDamage),[_cargo,false],_cargo] call CBA_fnc_targetEvent;
	detach _cargo;
	_cargo attachTo [_transport,_offset];
	_cargo setVectorDirAndUp _dirAndUp;
	_cargo setVariable [QGVAR(cargoParent),_transport,true];
};

[QGVAR(cargoLoaded),[_transport,_cargo]] call CBA_fnc_globalEvent;

true
