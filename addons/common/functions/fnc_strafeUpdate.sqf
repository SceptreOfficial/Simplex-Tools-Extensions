#include "script_component.hpp"

// Called via fnc_strafeSim scope
//private _perf = diag_tickTime;
_ammoData params ["_initSpeed","_airFriction","_timeToLive","_simulationStep"];
_speedLimits params ["_minSpeed","_maxSpeed"];
_relVel params ["_xRelVel","_yRelVel","_zRelVel"];
_rotations  params ["_dir","_pitch","_bank"];

private _pos = _lastPos;
private _velPos = _pos vectorAdd (_lastVelocity vectorMultiply 0.5);

_yRelVel = _minSpeed max (_yRelVel * 0.999) min _maxSpeed;
private _ammoSpeed = _yRelVel + _initSpeed;
private _rate = 6;
private _G = 9.8;

private _targetASL = if (_target isEqualType objNull) then {
	private _targetASL = getPosASL _target;
	private _distance = _velPos distance2D _targetASL;
	private _pitch = (_ammoSpeed^2 - sqrt (_ammoSpeed^4 - _G * (_G * _distance^2 + 2 * (_targetASL # 2 - _velPos # 2) * _ammoSpeed^2))) atan2 (_G * _distance);
	private _ETA = ((_ammoSpeed * sin _pitch) + sqrt ((_ammoSpeed * sin _pitch) ^ 2 - 2 * _G * (_targetASL # 2 - _velPos # 2))) / _G;
	if (!finite _ETA) then {_ETA = 0};
	private _estPos = _targetASL vectorAdd (velocity _target vectorMultiply _ETA * linearConversion [1200,100,_ammoSpeed,2,6,true]);

	[_estPos # 0,_estPos # 1,getTerrainHeightASL _estPos]
} else {_target};

_targetASL set [2,_targetASL # 2 max getTerrainHeightASL _targetASL];

//_pos # 2 < 50 + _targetASL # 2 ||
if (_pos # 2 < ([150,50] select (_vehicle isKindOf "Helicopter")) + getTerrainHeightASL _pos) exitWith {_abort = true};

private _strafeDir = _pos getDir _targetASL;
private _strafeStart = _targetASL getPos [-_spread/2,_strafeDir];
_strafeStart set [2,_targetASL # 2];

if (_fireStart > 0) then {
	_targetASL = _strafeStart getPos [0 max (_spread * ((CBA_missionTime - _fireStart + 0.8) / _duration)) min _spread,_strafeDir];
	_targetASL set [2,_strafeStart # 2];
} else {
	_targetASL = _strafeStart;
};

private _dirDiff = (_strafeDir - _dir) call CBA_fnc_simplifyAngle;
_dirDiff = [_dirDiff,_dirDiff - 360] select (_dirDiff > 180);
_dir = _dir + (-_rate max _dirDiff min _rate);

private _bankDiff = (-80 max (_dirDiff * 3) min 80) - _bank;
_bank = _bank + (-_rate max _bankDiff min _rate);

private "_pitchDiff";

if (_pos distance2D _targetASL > ((_ammoSpeed * sqrt (2 * _G * (_pos # 2 - _targetASL # 2)) / _G) * 0.9) min _minRange) then {
	_pitchDiff = -1 - _pitch;
	_pitch = _pitch + (-_rate max _pitchDiff min _rate);
} else {
	private _distance = _velPos distance2D _targetASL;
	private _targetZ = _targetASL # 2;
	private _angle = (_ammoSpeed^2 - sqrt (_ammoSpeed^4 - _G * (_G * _distance^2 + 2 * (_targetZ - _velPos # 2) * _ammoSpeed^2))) atan2 (_G * _distance);
	if (!finite _angle) then {_angle = asin ((_velPos vectorFromTo _targetASL) # 2)};

	_pitchDiff = if (_initSpeed > 0) then {
		private _mVel = [[0,_ammoSpeed,0],[0,0,0]];
		private _mBank = [[1,0,0],[0,1,0],[0,0,1]];
		private _mDir = [[cos -_dir,sin -_dir,0],[-sin -_dir,cos -_dir,0],[0,0,1]];
		private _GV = [0,0,-_G];
		private ["_velocity","_simPos"];
		
		while {
			_angle = _angle + 0.5;
			_simPos = _velPos;
			_velocity = (_mVel matrixMultiply _mBank matrixMultiply [[1,0,0],[0,cos _angle,sin _angle],[0,-sin _angle,cos _angle]] matrixMultiply _mDir) # 0;

			for "_i" from 0 to (_timeToLive + 1) step _simulationStep do {
				_velocity = _velocity vectorMultiply vectorMagnitude _velocity vectorMultiply _airFriction vectorAdd _GV vectorMultiply _simulationStep vectorAdd _velocity;
				_simPos = _velocity vectorMultiply _simulationStep vectorAdd _simPos;
				if (_simPos # 2 <= _targetZ) exitWith {};
			};

			_angle < 0 && abs ((_simPos getDir _targetASL) - _dir) < 30	
		} do {};
		
		(_angle - 0.4) - _pitch
	} else {
		_angle - _pitch
	};

	_pitch = _pitch + (-_rate max _pitchDiff min _rate);

	if (abs _dirDiff < 2 && abs _pitchDiff < 2 && _fireStart == 0) then {
		_thisArgs set [15,CBA_missionTime + 3];
	};
};

if (_pitch < -80) exitWith {_abort = true};

_rate = 0.2;

_relVel = [
	_xRelVel * 0.95 - (-_rate max _dirDiff min _rate),
	_yRelVel,
	_zRelVel * 0.95 - ((abs _bankDiff / 2) min _rate) + (-_rate max _pitchDiff min _rate)
];

_thisArgs set [12,_relVel];
_thisArgs set [17,[_dir,_pitch,_bank]];
_thisArgs set [11,[[
	_pos,
	_velPos,
	_pos vectorAdd ([_relVel,_dir,_pitch,_bank] call FUNC(modelToWorld))
],[
	vectorDir _vehicle,
	[[0,cos _pitch,sin _pitch],-_dir] call FUNC(rotateVector2D)
],[
	vectorUp _vehicle,
	[[sin _bank,0,cos _bank],-_dir] call FUNC(rotateVector2D)
],_tick]];

_vehicle setVariable [QGVAR(strafeRelVel),_relVel];

//systemChat str (ceil ((diag_tickTime - _perf) * 1000));
