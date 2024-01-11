#include "script_component.hpp"

if (GVAR(tick) > CBA_missionTime) exitWith {};

if (GVAR(list) isEqualTo []) exitWith {
	GVAR(list) = allGroups select {local _x && {!isNil {_x getVariable QGVAR(assignment)}}};
	GVAR(list) append GVAR(cache);

	if (GVAR(list) isEqualTo []) then {
		GVAR(tick) = CBA_missionTime + 10;
	};
};

private _group = GVAR(list) deleteAt 0;

if (GVAR(list) isEqualTo []) then {
	GVAR(tick) = CBA_missionTime + 10;
} else {
	GVAR(tick) = CBA_missionTime + 0.2;
};

if (_group isEqualType grpNull &&
	{!isNil {_group getVariable QGVAR(assignment)}} &&
	{{alive _x} count units _group > 0}
) exitWith {
	private _leaderPos = getPos leader _group;

	if (GVAR(cachingEnabled) && 
		{_group getVariable [QGVAR(allowCaching),false]} && 
		{allPlayers findIf {_leaderPos distance _x < GVAR(cachingDistance)} isEqualTo -1}
	) exitWith {
		_group call FUNC(cache);
	};
	
	_group call FUNC(scan);
};

if (_group isEqualType []) then {
	private _cachePos = _group # 1;

	if (!GVAR(cachingEnabled) || 
		{allPlayers findIf {!(_x isKindOf "HeadlessClient_F") && {_cachePos distance getPosASL _x < GVAR(cachingDistance)}} != -1}
	) then {
		_group call FUNC(uncache);
	};
};
