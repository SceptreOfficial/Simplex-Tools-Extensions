#include "script_component.hpp"

params [
	"_group",
	"_wpPos",
	"",
	["_posASL",[0,0,0],[[]],3],
	["_endDir",-1,[0]],
	["_flyHeight",50,[0]],
	["_approachDistance",300,[0]],
	["_maxDropSpeed",-8,[0]],
	["_holdTime",30,[0]],
	["_engineOn",true,[false]]
];

private _waypoint = [_group,currentWaypoint _group];
private _vehicle = vehicle leader _group;

if !(driver _vehicle in units _group) exitWith {true};

_group allowFleeing 0;
_vehicle flyInHeight _flyHeight;

private _moveTick = 0;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;

		if (isTouchingGround _vehicle && _vehicle distance2D _wpPos < 200) then {
			_vehicle engineOn true;
			_vehicle doMove (_vehicle getPos [200,getDir _vehicle]);
		} else {
			_vehicle doMove _wpPos
		};
	};

	sleep 0.2;

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < HELO_TAKEOVER_DISTANCE
};

if (_wpPos distance2D _posASL > 2) then {
	_posASL = +_wpPos;
	_posASL set [2,waypointPosition _waypoint # 2];
	_posASL = ATLToASL _posASL;

	private _ix = lineIntersectsSurfaces [_posASL vectorAdd [0,0,50],_posASL vectorAdd [0,0,-1],_vehicle,objNull,true,1,"GEOM","FIRE"];
	if (_ix isNotEqualTo []) then {_posASL = _ix # 0 # 0};

	private _height = 1;
	if (getNumber (configOf _vehicle >> "gearRetracting") == 1) then {
		_height = _height + (1.5 max (1.5 * getNumber (configOf _vehicle >> "gearDownTime")));
	};

	_posASL = _posASL vectorAdd [0,0,_height];
};

[_vehicle,_posASL,[_endDir],_flyHeight,_approachDistance,_maxDropSpeed,[{
	params ["_holdTime","_engineOn"];

	if !(_vehicle getVariable [QGVAR(flyHelicopterReached),false]) then {
		doStop _vehicle;
		_vehicle flyInHeight 0;
		_vehicle action ["LandGear",_vehicle];
	};

	private _holdInterval = if (_holdTime >= 0) then {
		(CBA_missionTime - (_startTime + _controlTime)) / (_holdTime max 1);
	} else {0};

	(_vehicle call BIS_fnc_getPitchBank) params ["_pitch","_bank"];

	if (abs _pitch > 30 || abs _bank > 30 || _holdInterval > 1 || _vehicle distance2D _endASL > 20) exitWith {true};

	private _vel = velocity _vehicle;
		
	if (isTouchingGround _vehicle) then {
		if (_engineOn && !isEngineOn _vehicle) then {_vehicle engineOn true};
		if (!_engineOn && isEngineOn _vehicle) then {_vehicle engineOn false};

		_vehicle setVelocity [_vel # 0 * 0.7,_vel # 1 * 0.7,(_vel # 2 * 0.999) min -0.1];
	} else {
		_vehicle setVelocity [_vel # 0,_vel # 1,(_vel # 2 - 0.02) max -1];
	};

	false
},[_holdTime,_engineOn]]] call FUNC(flyHelicopter);

waitUntil {
	sleep 0.5;
	!(_vehicle getVariable [QGVAR(flyHelicopter),false]) ||	_vehicle getVariable [QGVAR(flyHelicopterCompleted),false]
};

true
