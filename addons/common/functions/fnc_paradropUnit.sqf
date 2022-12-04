#include "script_component.hpp"

params [["_unit",objNull,[objNull]],["_AIOpenAltitude",150,[]]];

if (!local _unit) exitWith {
	[QGVAR(execute),[_this,QFUNC(paradropUnit)],_this] call CBA_fnc_targetEvent;
};

_unit setVariable [QGVAR(paradropLoadout),getUnitLoadout _unit];
removeBackpack _unit;

if (isPlayer _unit) then {
	_unit addBackpack "B_Parachute";

	[{
		isNull _this || {!(vehicle _this isKindOf "ParachuteBase") && getPos _this # 2 < 2}
	},{
		_this setUnitLoadout (_this getVariable QGVAR(paradropLoadout));
		_this setVariable [QGVAR(paradropLoadout),nil];
		[QGVAR(paradropUnitEnd),[_this]] call CBA_fnc_globalEvent;
	},_unit] call CBA_fnc_waitUntilAndExecute;
} else {
	[{
		params ["_unit","_AIOpenAltitude"];
		isNull _unit || getPos _unit # 2 <= _AIOpenAltitude
	},{
		params ["_unit"];

		_unit addBackpack "B_Parachute";
		_unit action ["OpenParachute",_unit];

		[{
			isNull _this || {!(vehicle _this isKindOf "ParachuteBase") && getPos _this # 2 < 2}
		},{
			_this setUnitLoadout (_this getVariable QGVAR(paradropLoadout));
			_this setVariable [QGVAR(paradropLoadout),nil];
			[QGVAR(paradropUnitEnd),[_this]] call CBA_fnc_globalEvent;
		},_unit] call CBA_fnc_waitUntilAndExecute;
	},[_unit,_AIOpenAltitude]] call CBA_fnc_waitUntilAndExecute;
};

[QGVAR(paradropUnitStart),[_unit]] call CBA_fnc_globalEvent;
