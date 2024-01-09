#include "script_component.hpp"

if (GVAR(playerlist) isEqualTo []) exitWith {
	GVAR(playerlist) = allPlayers select {!(_x isKindOf "HeadlessClient_F")};
	
	// No players online: Force remove
	if (GVAR(playerList) isEqualTo []) exitWith {
		{[_x,true,true] call FUNC(remove)} forEach +GVAR(spawnPoints);
		GVAR(activePoints) = [];
		GVAR(inactivePoints) = [];
		GVAR(isolatedPoints) = [];
	};

	{// Active
		_x setVariable [QGVAR(expiring),nil];
		_x setVariable [QGVAR(expiration),nil];
	} forEach GVAR(activePoints);

	{// Inactive
		if (_x getVariable [QGVAR(expiration),CBA_missionTime + 10] < CBA_missionTime) then {
			_x call FUNC(remove);
		} else {
			if !(_x getVariable [QGVAR(expiring),false]) then {
				_x setVariable [QGVAR(expiring),true];
				_x setVariable [QGVAR(expiration),CBA_missionTime + 10];
			};
		};
	} forEach (GVAR(inactivePoints) - GVAR(activePoints));

	{// Isolated
		[_x,true] call FUNC(remove);
	} forEach (GVAR(isolatedPoints) - (GVAR(activePoints) + GVAR(inactivePoints)));

	GVAR(activePoints) = [];
	GVAR(inactivePoints) = [];
	GVAR(isolatedPoints) = [];
};

private _player = GVAR(playerlist) deleteAt 0;

if (!alive _player) exitWith {};

private _nearestDistances = [1e39,1e39,1e39];
private _nearestSpawnPoints = [objNull,objNull,objNull];

{
	private _spawnRadius = triggerArea _x # 0;
	private _type = _x getVariable QGVAR(type);
	private _distance = _x distance2D _player;

	if (_distance < (_nearestDistances # _type)) then {
		_nearestDistances set [_type,_distance];
		_nearestSpawnPoints set [_type,_x];
	};

	switch true do {
		case (_distance <= _spawnRadius * 1.15) : {GVAR(activePoints) pushBackUnique _x};
		case (_distance >= _spawnRadius * 2) : {GVAR(isolatedPoints) pushBackUnique _x};
		default {GVAR(inactivePoints) pushBackUnique _x};
	};
} forEach +GVAR(spawnPoints);

{
	private _nearestDist = _nearestDistances # _forEachIndex;

	switch true do {
		case (_nearestDist >= _x) : {// Create new since none nearby
			GVAR(activePoints) pushBackUnique ([getPosATL _player,_x,_forEachIndex] call FUNC(create));
		};
		case (_nearestDist >= (_x / 2)) : {// Sequential creation
			private _nearest = _nearestSpawnPoints # _forEachIndex;
			
			GVAR(activePoints) pushBackUnique (
				[_nearest getPos [_x,_nearest getDir _player],_x,_forEachIndex] call FUNC(create)
			);
		};
	};
} forEach [GVAR(pedSpawnRadius),GVAR(driverSpawnRadius),GVAR(parkedSpawnRadius)];
