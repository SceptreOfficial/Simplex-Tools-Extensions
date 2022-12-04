#include "script_component.hpp"

params ["_group","_wpPos","",["_posASL",[0,0,0],[[]],3],["_flyHeight",60,[0]]];

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
};

[_vehicle,_posASL,true] call FUNC(slingloadDropoff);

waitUntil {
	sleep 0.5;
	isNull (_vehicle getVariable [QGVAR(slingloadCargo),objNull]) ||
	!(_vehicle getVariable [QGVAR(flyHelicopter),false]) ||
	_vehicle getVariable [QGVAR(flyHelicopterCompleted),false]
};

true
