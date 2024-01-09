#include "script_component.hpp"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_weapon",""],
	["_infiniteAmmo",true],
	["_approachDir",-1],
	["_spread",0],
	["_duration",4],
	["_triggerDelay",0]
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

		if (isTouchingGround _vehicle) then {
			_vehicle doMove (_vehicle getPos [200,getDir _vehicle]);
		};
	};

	sleep 0.2;

	!isTouchingGround _vehicle
};

[
	_vehicle,
	[_attachedObject,ATLtoASL waypointPosition [_group,currentWaypoint _group]] select (isNull _attachedObject),
	[_weapon,[_duration,true],_triggerDelay],
	_infiniteAmmo,
	_spread,
	_approachDir
] call EFUNC(common,strafe);

waitUntil {
	sleep 0.5;
	!(_vehicle getVariable [QEGVAR(common,strafe),false])
};

true
