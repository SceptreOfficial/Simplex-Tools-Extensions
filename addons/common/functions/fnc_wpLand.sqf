#include "..\script_component.hpp"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_timeout",0],
	["_engine",true],
	["_endDir",-1],
	["_approach",100]
];

private _vehicle = vehicle leader _group;

if !(driver _vehicle in units _group) exitWith {true};

_group allowFleeing 0;
_vehicle engineOn true;
[_vehicle,[0,0,0]] call EFUNC(common,pilotHelicopter);

private _moveTick = 0;
private _pilotDistance = [HELO_PILOT_DISTANCE,VTOL_PILOT_DISTANCE] select (_vehicle isKindOf "VTOL_Base_F");
private _moving = false;

waitUntil {
	scopeName "wait";

	if (CBA_missionTime > _moveTick) then {
		if (_vehicle isKindOf "VTOL_Base_F") then {
			if (isTouchingGround _vehicle) then {
				_moveTick = CBA_missionTime + 20;
				if (_moving) exitWith {breakTo "wait"};
			} else {
				_moveTick = CBA_missionTime + 10;
			};
		} else {
			_moveTick = CBA_missionTime + 3;
		};

		if (isTouchingGround _vehicle && _vehicle distance2D _wpPos < 200) then {
			_vehicle doMove (_vehicle getRelPos [200,0]);
		} else {
			_vehicle doMove _wpPos
		};

		_moving = true;
	};

	sleep 0.2;

	!isTouchingGround _vehicle && _vehicle distance2D _wpPos < _pilotDistance
};

[
	_vehicle,
	[_vehicle,ATLtoASL waypointPosition [_group,currentWaypoint _group],"LAND"] call FUNC(surfacePosASL),
	[_endDir],
	(getPos _vehicle # 2) max 50,
	_approach,
	nil,
	[FUNC(pilotHelicopterLand),[[60,-1] select _engine,_engine]]
] call FUNC(pilotHelicopter);

waitUntil {
	sleep 0.5;
	isTouchingGround _vehicle ||
	!(_vehicle getVariable [QEGVAR(common,pilotHelicopter),false]) ||
	_vehicle getVariable [QEGVAR(common,pilotHelicopterCompleted),false]
};

sleep _timeout;

[_vehicle,[0,0,0]] call EFUNC(common,pilotHelicopter);

true
