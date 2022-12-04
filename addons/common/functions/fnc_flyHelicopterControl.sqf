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

	_vehicle setVariable [QGVAR(flyHelicopter),nil,true];
	_vehicle setVariable [QGVAR(flyHelicopterCancel),nil,true];
	
	if (_vehicle getVariable [QGVAR(flyToReached),false]) then {
		private _velocity = velocity _vehicle;
		_vehicle setVelocity [_velocity # 0,_velocity # 1,1];
	};
	
	_vehicle flyInHeight 100;
	_vehicle doFollow _vehicle;

	// PUBLIC EVENT
	[QGVAR(flyHelicopterCancelled),[_vehicle]] call CBA_fnc_globalEvent;
};

private _interval = (CBA_missionTime - _startTime) / _controlTime;

if (_interval > 1 || isTouchingGround _vehicle) exitWith {
	_endRotation params ["_endDir","_endPitch","_endBank"];
	_complete params ["_completeCondition","_completeArgs"];

	if (_completeArgs call _completeCondition) then {
		removeMissionEventHandler [_thisEvent,_thisEventHandler];

		_vehicle setVariable [QGVAR(flyHelicopter),nil,true];
		_vehicle setVariable [QGVAR(flyHelicopterCompleted),true,true];
		_vehicle flyInHeight 100;
		_vehicle doFollow _vehicle;

		// PUBLIC EVENT
		[QGVAR(flyHelicopterCompleted),[_vehicle]] call CBA_fnc_globalEvent;
	};

	if !(_vehicle getVariable [QGVAR(flyHelicopterReached),false]) then {
		_vehicle setVariable [QGVAR(flyHelicopterReached),true,true];

		// PUBLIC EVENT
		[QGVAR(flyHelicopterReached),[_vehicle]] call CBA_fnc_globalEvent;
	};
};

private _pos = _interval bezierInterpolation _posList;
private _dir = _interval bezierInterpolation _dirList;
private _up = _interval bezierInterpolation _upList;
private _velocity = (_pos vectorDiff _lastPos) vectorMultiply (diag_fps / (accTime max 0.01));
_thisArgs set [4,_pos];

_vehicle setVelocityTransformation [_pos,_pos,_velocity,_velocity,_dir,_dir,_up,_up,_interval];
_vehicle setVelocity _velocity;
