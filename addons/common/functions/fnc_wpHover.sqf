#include "script_component.hpp"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_timeout",30],
	["_hoverHeight",15],
	["_endDir",-1],
	["_approach",100]
];

private _vehicle = vehicle leader _group;

if !(driver _vehicle in units _group) exitWith {true};

_group allowFleeing 0;
_vehicle engineOn true;
[_vehicle,[0,0,0]] call EFUNC(common,pilotHelicopter);

private _moveTick = 0;

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;

		if (isTouchingGround _vehicle && _vehicle distance2D _wpPos < 200) then {
			_vehicle doMove (_vehicle getPos [200,getDir _vehicle]);
		} else {
			_vehicle doMove _wpPos
		};
	};

	sleep 0.2;

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < HELO_TAKEOVER_DISTANCE
};

[
	_vehicle,
	[_vehicle,ATLtoASL waypointPosition [_group,currentWaypoint _group],"HOVER",_hoverHeight] call FUNC(heliSurfacePosASL),
	[_endDir],
	(getPos _vehicle # 2) max 50,
	_approach,
	nil,
	FUNC(pilotHelicopterHover)
] call FUNC(pilotHelicopter);

waitUntil {
	sleep 0.5;
	_vehicle getVariable [QEGVAR(common,pilotHelicopterReached),false] ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

sleep _timeout;

[_vehicle,[0,0,0]] call EFUNC(common,pilotHelicopter);

true
