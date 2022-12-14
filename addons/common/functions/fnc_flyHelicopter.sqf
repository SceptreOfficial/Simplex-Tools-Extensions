#include "script_component.hpp"

if (canSuspend) exitWith {
	[FUNC(flyHelicopter),_this] call CBA_fnc_directCall;
};

params [
	["_vehicle",objNull,[objNull]],
	["_endASL",[0,0,0],[[],objNull],3],
	["_endRotation",[],[[],0]],
	["_flyHeight",50,[0]],
	["_approachDistance",100,[0]],
	["_maxDropSpeed",-8,[0]],
	["_complete",{true},[{},[]]]
];

if (!alive _vehicle || !alive driver _vehicle || isPlayer driver _vehicle || !canMove _vehicle) exitWith {};

// Run locally
if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,QFUNC(flyHelicopter)],_vehicle] call CBA_fnc_targetEvent;
};

// Cancel previous plan
if (_vehicle getVariable [QGVAR(flyHelicopter),false]) then {
	removeMissionEventHandler ["EachFrame",_vehicle getVariable [QGVAR(flyHelicopterEFID),-1]];
	_vehicle setVariable [QGVAR(flyHelicopterEFID),nil];

	if (_vehicle getVariable [QGVAR(flyToReached),false]) then {
		private _velocity = velocity _vehicle;
		_vehicle setVelocity [_velocity # 0,_velocity # 1,1.5];
	};
	
	_vehicle flyInHeight 100;
	_vehicle doFollow _vehicle;

	// PUBLIC EVENT
	[QGVAR(flyHelicopterCancelled),[_vehicle]] call CBA_fnc_globalEvent;
};

if (_endASL isEqualType objNull) then {_endASL = getPosASL _endASL};

// Stop here if null pos
if (_endASL isEqualTo [0,0,0]) exitWith {
	_vehicle setVariable [QGVAR(flyHelicopter),nil,true];
};

// Validate input
_endRotation params [["_endDir",-1,[0]],["_endPitch",0,[0]],["_endBank",0,[0]]];
_endRotation = [_endDir,-89.9 max _endPitch min 89.9,-179.9 max _endBank min 179.9];
_complete params [["_completeCondition",{true},[{}]],["_completeArgs",[]]];
_complete = [_completeCondition,_completeArgs];
_flyHeight = _flyHeight max 5;
_approachDistance = _approachDistance max 10;

if (_endDir >= 0) then {
	_endDir = _endDir call CBA_fnc_simplifyAngle;
};

private _args = [_vehicle,_endASL,_endRotation,_flyHeight,_approachDistance,_maxDropSpeed,_complete];

// Create a path to follow
private _startASL = getPosASL _vehicle;
private _velocity = velocity _vehicle;
private _maxSpeed = (getNumber (configOf _vehicle >> "maxSpeed")) / 3.6;
private _seaHeight = linearConversion [0,1,waves,0,getNumber (configFile >> "CfgWorlds" >> worldName >> "Sea" >> "maxTide")] - getNumber (configOf _vehicle >> "maxFordingDepth");
private _posList = [_startASL,_startASL vectorAdd _velocity];
private _dirList = [vectorDir _vehicle,vectorDir _vehicle];
private _upList = [vectorUp _vehicle,vectorUp _vehicle];
private _pos = _posList # 1;
private _dir = getDir _vehicle;
if (_dir % 90 isEqualTo 0) then {_dir = _dir - 0.0001};
private _endZ = _endASL # 2;

private _fnc_height = {
	params ["_pos","_height"];
	
	private _ix = lineIntersectsSurfaces [_pos vectorAdd [0,0,2],_pos vectorAdd [0,0,-_height],_vehicle,objNull,true,1,"GEOM","FIRE"];
	if (_ix isNotEqualTo []) then {
		_height = _pos # 2 - _ix # 0 # 0 # 2;
	};

	_height
};

private _fnc_pushNormals = {
	params ["_dir","_pitch","_bank"];
	
	_dirList pushBack ([[0,cos _pitch,sin _pitch],360-_dir] call BIS_fnc_rotateVector2D);
	_upList pushBack ([[sin _bank,0,cos _bank],360-_dir] call BIS_fnc_rotateVector2D);
};

while {
	// How fast should the helicopter go
	([_velocity,-_dir,2] call BIS_fnc_rotateVector3D) params ["_xRelVel","_yRelVel"];
	private _distance2D = _pos distance2D _endASL;
	private _targetVelocity = (_pos vectorFromTo _endASL) vectorMultiply ([
		0.8,
		_maxSpeed,
		linearConversion [0,1100,_distance2D,0,1,true],
		1.5
	] call BIS_fnc_easeOut);
	private _targetPos = _pos vectorAdd _targetVelocity;

	// Handle Z axis
	if (_distance2D < _approachDistance) then {
		private _minHeight = linearConversion [2,8,_distance2D,0,8,true];
		private _height = [_targetPos,10] call _fnc_height;

		if (_height < _minHeight) then {
			_targetVelocity set [2,_maxDropSpeed max (_minHeight - _height) min 12];	
		} else {
			_targetVelocity set [2,_maxDropSpeed max (_endZ + _minHeight - _pos # 2) min 12];	
		};

		private _acceleration = linearConversion [0,80,vectorMagnitude _velocity,2,6];
		private _velocityChange = (_targetVelocity vectorDiff _velocity) apply {_x / _acceleration};
		_targetPos = _pos vectorAdd (_velocity vectorAdd _velocityChange);
		_targetPos set [2,(_targetPos # 2) max (getTerrainHeightASL _targetPos) max _seaHeight];
		_velocity = _targetPos vectorDiff _pos;

		[_velocityChange,-_dir,2] call BIS_fnc_rotateVector3D
	} else {
		private _height = [_targetPos,_flyHeight + 10] call _fnc_height;
		_targetVelocity set [2,_maxDropSpeed max (_flyHeight - _height) min 12];

		private _acceleration = linearConversion [0,80,vectorMagnitude _velocity,4,6];
		private _velocityChange = (_targetVelocity vectorDiff _velocity) apply {_x / _acceleration};
		_targetPos = _pos vectorAdd (_velocity vectorAdd _velocityChange);
		_targetPos set [2,(_targetPos # 2) max (((getTerrainHeightASL _targetPos) max _seaHeight) + 5)];
		_velocity = _targetPos vectorDiff _pos;

		[_velocityChange,-_dir,2] call BIS_fnc_rotateVector3D
	} params ["_xVelChange","_yVelChange"];

	// Wanted pitch and roll
	private _pitch = -70 max (-_yVelChange * 6) min 70;
	private _bank = -70 max (_xVelChange * 7) min 70;

	// Wanted direction
	private _targetDir = switch true do {
		case (_endDir >= 0 && {_pos distance _endASL < 15}) : {_endDir};
		case (_distance2D < 15) : {_dir};
		default {_pos getDir _endASL};
	};

	// Limit yaw at fast speeds
	private _yawLimit = linearConversion [0,80,abs _yRelVel,55,10,true];

	// Commit
	[_dir,_pitch,_bank] call _fnc_pushNormals;

	private _relDir = (_targetDir - _dir) call CBA_fnc_simplifyAngle;
	_dir = (_dir + (-_yawLimit max ([_relDir,_relDir - 360] select (_relDir > 180)) min _yawLimit)) call CBA_fnc_simplifyAngle;
	if (_dir % 90 isEqualTo 0) then {_dir = _dir - 0.0001};
	
	_pos = _pos vectorAdd _velocity;
	_pos set [2,(_pos # 2) max ((getTerrainHeightASL _pos) max _seaHeight)];
	_posList pushBack _pos;

	_endASL distance _pos > 2 && count _posList < 300
} do {};

_posList pushBack (_endASL vectorAdd [0,0,0.4]);
_posList pushBack _endASL;

if (_endDir >= 0) then {
	[_endDir,_endPitch,_endBank] call _fnc_pushNormals;
} else {
	[_dir,_endPitch,_endBank] call _fnc_pushNormals;
};

// Debug
//{
//	private _helper = "Sign_Arrow_Large_Yellow_F" createVehicle [0,0,0];
//	_helper setPosASL _x;
//	_helper setVectorDirAndUp [_dirList param [_forEachIndex,[0,1,0]],_upList param [_forEachIndex,[0,0,1]]];
//} forEach _posList;

// Begin control
_vehicle engineOn true;
doStop _vehicle;
_vehicle setVariable [QGVAR(flyHelicopter),true,true];
_vehicle setVariable [QGVAR(flyHelicopterReached),false,true];
_vehicle setVariable [QGVAR(flyHelicopterCompleted),false,true];

private _EFID = addMissionEventHandler ["EachFrame",{call FUNC(flyHelicopterControl)},[
	_vehicle,
	_endASL,
	_endRotation,
	_complete,
	_startASL,
	CBA_missionTime,
	count _posList,
	_posList,
	_dirList,
	_upList,
	[_dirList # (count _dirList - 1),_upList # (count _upList - 1)]
]];

_vehicle setVariable [QGVAR(flyHelicopterEFID),_EFID];

// PUBLIC EVENT
[QGVAR(flyHelicopterControl),_args] call CBA_fnc_globalEvent;
