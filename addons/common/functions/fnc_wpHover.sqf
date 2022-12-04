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
	["_holdTime",30,[0]]
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
};

[_vehicle,_posASL,[_endDir],_flyHeight,_approachDistance,_maxDropSpeed,[{
	params ["_holdTime"];

	if !(_vehicle getVariable [QGVAR(flyToReached),false]) then {
		doStop _vehicle;
		//_vehicle flyInHeight (getPosVisual _vehicle # 2 + 0.5);
	};

	private _holdInterval = if (_holdTime >= 0) then {
		(CBA_missionTime - (_startTime + _controlTime)) / (_holdTime max 1);
	} else {0};

	if (_holdInterval > 0.9) then {_vehicle flyInHeight 100};
	if (_holdInterval > 1) exitWith {
		_vehicle setVelocity [0,0,1.5];
		true
	};

	_vehicle setVectorDirAndUp _endDirUp;
	_vehicle setVelocity [0,0,0];

	false
},[_holdTime]]] call FUNC(flyHelicopter);

waitUntil {
	sleep 0.5;
	!(_vehicle getVariable [QGVAR(flyHelicopter),false]) ||	_vehicle getVariable [QGVAR(flyHelicopterCompleted),false]
};

true
