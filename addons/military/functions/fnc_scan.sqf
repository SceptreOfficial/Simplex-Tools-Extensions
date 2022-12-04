#include "script_component.hpp"

params ["_group"];

// Evaluate known targets
private _targets = leader _group targets [true];

if (_targets isEqualTo []) exitWith {};

private _targetsToReport = _group getVariable [QGVAR(targetsToReport),[]];
private _sideTargets = missionNamespace getVariable [SIDE_TARGETS(_group getVariable GVAR(side)),[]];
private _newTargets = (_targets - _sideTargets - _targetsToReport) select {
	(_group knowsAbout _x) > 0.5 &&
	{!(vehicle _x isKindOf "Air")} &&
	{!(vehicle _x isKindOf "Ship")} &&
	{{alive _x} count crew _x isNotEqualTo 0}
};

if (_newTargets isEqualTo []) exitWith {};

_targetsToReport append _newTargets;
_group setVariable [QGVAR(targetsToReport),_targetsToReport];

// Report all new targets after a short period of time
if (_group getVariable [QGVAR(report),true]) then {
	_group setVariable [QGVAR(report),false];

	[{
		_this setVariable [QGVAR(report),nil];
		_this call FUNC(report);
	},_group,8 + round random 6] call CBA_fnc_waitAndExecute;
};

// Reveal the area around new targets for accurate intel
{{_group reveal _x} forEach (_x nearEntities 20)} forEach _newTargets;

nil
