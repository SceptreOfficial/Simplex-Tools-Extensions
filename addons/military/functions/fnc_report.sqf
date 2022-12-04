#include "script_component.hpp"

params ["_group"];

if (isNull _group || {{alive _x} count units _group isEqualTo 0}) exitWith {};

private _side = _group getVariable QGVAR(side);
private _sideTargets = missionNamespace getVariable [SIDE_TARGETS(_side),[]];
private _newTargets = ((_group getVariable QGVAR(targetsToReport)) select {{alive _x} count crew _x > 0}) - _sideTargets;

_group setVariable [QGVAR(targetsToReport),[]];

if (_newTargets isEqualTo []) exitWith {};

// Report targets
[QGVAR(report),[_side,_newTargets]] call CBA_fnc_serverEvent;

// Process how to handle new targets
([_group,_side,_newTargets] call FUNC(analyze)) params ["_target","_canEngage","_threatRating","_urgentStrength","_respondingGroups"];

if (_respondingGroups isNotEqualTo []) then {
	if (_canEngage && _threatRating <= _urgentStrength) then {
		[_respondingGroups] call FUNC(orderAttack);
		[_group,units _target call EFUNC(common,positionAvg)] call FUNC(smoke);
	} else {
		[
			_respondingGroups,
			_side,
			leader _group getPos [180 + round random 50,leader _target getDir leader _group]
		] call FUNC(orderRegroup);

		if (selectMin (units _group apply {getSuppression _x}) > 0.3) then {
			[_group,units _target call EFUNC(common,positionAvg)] call FUNC(smoke);
		};
	};
};

// Track engagement so targets can be eligible for re-detection
[QGVAR(engagementStarted),[_side,_respondingGroups,_newTargets]] call CBA_fnc_serverEvent;

// Flares
if (GVAR(flaresEnabled) && !(call EFUNC(common,isDaytime)) && random 1 < GVAR(flaresChance)) then {
	[{
		for "_i" from 0 to (1 + round random 2) do {
			private _flare = createVehicle ["F_40mm_White",selectRandom _this getPos [random [20,45,70],random 360],[],0,"CAN_COLLIDE"];
			_flare setPosATL [getPosATL _flare # 0,getPosATL _flare # 1,180 + random 60];
			_flare setVelocity [0,0,-0.05];
		};
	},_newTargets,10 + round random 15] call CBA_fnc_waitAndExecute;
};
