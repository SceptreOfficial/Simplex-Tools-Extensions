#include "script_component.hpp"

_thisArgs params [
	"_vehicle",
	"_endASL",
	"_endRotation",
	"_complete",
	"_lastPos",
	"_startTime",
	"_controlTime",
	"_posList",
	"_dirList",
	"_upList",
	"_endDirUp"
];

if (!alive _vehicle ||
	!alive driver _vehicle ||
	isPlayer driver _vehicle ||
	!canMove _vehicle ||
	!local _vehicle
) exitWith {
	removeMissionEventHandler [_thisEvent,_thisEventHandler];

	_vehicle setVariable [QGVAR(pilotHelicopter),nil,true];
	_vehicle setVariable [QGVAR(pilotHelicopterCancel),nil,true];
	
	if (_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
		private _velocity = velocity _vehicle;
		_vehicle setVelocity [_velocity # 0,_velocity # 1,1];
	};
	
	_vehicle flyInHeight ((_vehicle getVariable [QPVAR(entity),objNull]) getVariable [QPVAR(flyHeightATL),100]);
	_vehicle doFollow _vehicle;

	// PUBLIC EVENT
	[QGVAR(pilotHelicopterCancelled),[_vehicle]] call CBA_fnc_globalEvent;
};

private _interval = (CBA_missionTime - _startTime) / _controlTime;

if (_interval > 1) exitWith {
	_endRotation params ["_endDir","_endPitch","_endBank"];
	_complete params ["_completeCondition","_completeArgs"];

	if (_completeArgs call _completeCondition) then {
		removeMissionEventHandler [_thisEvent,_thisEventHandler];

		_vehicle setVariable [QGVAR(pilotHelicopter),nil,true];
		_vehicle setVariable [QGVAR(pilotHelicopterCompleted),true,true];
		_vehicle flyInHeight 100;
		_vehicle doFollow _vehicle;

		// PUBLIC EVENT
		[QGVAR(pilotHelicopterCompleted),[_vehicle]] call CBA_fnc_globalEvent;
	};

	if !(_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
		_vehicle setVariable [QGVAR(pilotHelicopterReached),true,true];

		// PUBLIC EVENT
		[QGVAR(pilotHelicopterReached),[_vehicle]] call CBA_fnc_globalEvent;
	};
};

private _pos = _interval bezierInterpolation _posList;
private _dir = _interval bezierInterpolation _dirList;
private _up = _interval bezierInterpolation _upList;
private _velocity = _pos vectorDiff _lastPos vectorMultiply 1 / diag_deltaTime / accTime;
_thisArgs set [4,_pos];

_vehicle setVelocityTransformation [_pos,_pos,_velocity,_velocity,_dir,_dir,_up,_up,_interval];
_vehicle setVelocity _velocity;
