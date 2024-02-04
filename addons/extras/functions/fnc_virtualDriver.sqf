#include "..\script_component.hpp"

params [["_unit",objNull,[objNull]],["_clone",false,[false]]];

if (_unit in _unit) exitWith {objNull};

private _vehicle = vehicle _unit;

if (!isNull driver _vehicle) exitWith {
	LLSTRING(virtualDriverOccupied) call EFUNC(common,hint);
	objNull
};

private _driver = objNull;

if (_clone) then {
	_driver = group _unit createUnit [typeOf _unit,[0,0,0],[],0,"NONE"];
	_driver setUnitLoadout getUnitLoadout _unit;
} else {
	private _class = switch (side group _unit) do {
		case west : {"B_UAV_AI"};
		case east : {"O_UAV_AI"};
		case independent : {"I_UAV_AI"};
		default {"C_UAV_AI_F"};
	};

	_driver = group _unit createUnit [_class,[0,0,0],[],0,"NONE"];
};

_driver allowDamage false;
_driver moveInDriver _vehicle;

_vehicle setVariable [QGVAR(virtualDriver),_driver,true];
_vehicle setVariable [QGVAR(virtualDriverCreator),_unit,true];

[QGVAR(virtualDriverCreated),[_driver,_vehicle,_unit]] call CBA_fnc_globalEvent;

_driver
