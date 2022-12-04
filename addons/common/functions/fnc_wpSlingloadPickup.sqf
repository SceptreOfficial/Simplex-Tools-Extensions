#include "script_component.hpp"

params ["_group","_wpPos","",["_cargoID","",[""]]];

private _waypoint = [_group,currentWaypoint _group];
private _vehicle = vehicle leader _group;

if !(driver _vehicle in units _group) exitWith {true};

private _cargo = _vehicle getVariable [_cargoID,objNull];
_vehicle setVariable [_cargoID,nil,true];

if (isNull _cargo) exitWith {true};

_group allowFleeing 0;
_vehicle flyInHeight (getPos _cargo # 2 + 30);

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

if (isNull _cargo) exitWith {true};

[_vehicle,_cargo,true] call FUNC(slingloadPickup);

waitUntil {
	sleep 0.5;
	!isNull (_vehicle getVariable [QGVAR(slingloadCargo),objNull]) ||
	!(_vehicle getVariable [QGVAR(flyHelicopter),false]) ||
	_vehicle getVariable [QGVAR(flyHelicopterCompleted),false]
};

true
