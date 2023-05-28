#include "script_component.hpp"

params ["_vehicle","_weapon","_muzzle","_mode","_ammo","_magazine","_projectile","_gunner"];

if (_weapon != _thisArgs || isNil {_vehicle getVariable QGVAR(strafeRelVel)}) exitWith {};

[vectorDir _vehicle,vectorUp _vehicle] call FUNC(yawPitchBank) params ["_dir","_pitch","_bank"];

private _relVel = _vehicle getVariable [QGVAR(strafeRelVel),velocityModelSpace _vehicle];
private _velocity = [[0,_relVel # 1,0],_dir,_pitch,_bank] call FUNC(modelToWorld);

private _pos = getPosASL _projectile;
private _posList = [getPosASL _projectile];
private _dirList = [vectorDir _projectile];
private _upList = [vectorUp _projectile];
private _GV = [0,0,-9.8];
private _pitchLimit = linearConversion [0,250,_relVel # 1,-90,_pitch,true];

while {
	_pitch = (_pitch - 8) max _pitchLimit;
	_bank = _bank * 0.9;
	//_dir = _dir + (((_pos getDir (_pos vectorAdd _velocity)) - _dir) / 2);

	_velocity = _velocity vectorAdd _GV;
	_pos = _pos vectorAdd _velocity;
	
	_posList pushBack _pos;
	_dirList pushBack ([[0,cos _pitch,sin _pitch],-_dir] call FUNC(rotateVector2D));
	_upList pushBack ([[sin _bank,0,cos _bank],-_dir] call FUNC(rotateVector2D));

	_pos # 2 > 0 && _pos # 2 > getTerrainHeightASL _pos
} do {};

[{
	params ["_posList","_dirList","_upList","_totalTime","_startTime","_lastPos","_projectile","_triggerDistance"];

	private _interval = (CBA_missionTime - _startTime) / _totalTime;

	if (!alive _projectile || _interval > 1) exitWith {true};

	private _pos = _interval bezierInterpolation _posList;
	private _dir = _interval bezierInterpolation _dirList;
	private _up = _interval bezierInterpolation _upList;
	private _velocity = _pos vectorDiff _lastPos vectorMultiply 1 / diag_deltaTime / accTime;
	_this set [5,_pos];

	if (_triggerDistance > 0 && {_pos # 2 <= _triggerDistance + getTerrainHeightASL _pos}) exitWith {
		triggerAmmo _projectile;
		true
	};

	_projectile setVelocityTransformation [_pos,_pos,_velocity,_velocity,_dir,_dir,_up,_up,_interval];
	_projectile setVelocity _velocity;

	false
},{},[
	_posList,
	_dirList,
	_upList,
	count _posList,
	CBA_missionTime,
	getPosASL _projectile,
	_projectile,
	getNumber (configFile >> "CfgAmmo" >> typeOf _projectile >> "triggerDistance")
]] call CBA_fnc_waitUntilAndExecute;
