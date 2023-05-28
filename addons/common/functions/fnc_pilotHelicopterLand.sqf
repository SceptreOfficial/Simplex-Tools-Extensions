#include "script_component.hpp"

params ["_hold","_engine"];

if !(_vehicle getVariable [QGVAR(pilotHelicopterReached),false]) then {
	doStop _vehicle;
	_vehicle flyInHeight 0;
	_vehicle action ["LandGear",_vehicle];
};

private _holdInterval = if (_hold >= 0) then {
	(CBA_missionTime - (_startTime + _controlTime)) / (_hold max 1);
} else {0};

(_vehicle call BIS_fnc_getPitchBank) params ["_pitch","_bank"];

if (abs _pitch > 30 || abs _bank > 30 || _holdInterval > 1 || _vehicle distance2D _endASL > 20) exitWith {true};

private _vel = velocity _vehicle;
	
if (isTouchingGround _vehicle) then {
	if (_engine && !isEngineOn _vehicle) then {_vehicle engineOn true};
	if (!_engine && isEngineOn _vehicle) then {_vehicle engineOn false};

	_vehicle setVelocity [_vel # 0 * 0.7,_vel # 1 * 0.7,(_vel # 2 * 0.999) min -0.1];
} else {
	_vehicle setVelocity [_vel # 0,_vel # 1,(_vel # 2 - 0.02) max -1];
};

false