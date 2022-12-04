#include "script_component.hpp"

// List iteration
if (GVAR(list) isEqualTo []) exitWith {
	GVAR(list) = allGroups select {local _x && {!isNil {_x getVariable QGVAR(assignment)}}};
	GVAR(list) append GVAR(cache);
};

private _group = GVAR(list) deleteAt 0;

// Item evalutation
if (
	_group isEqualType grpNull && 
	{!isNull _group && !isNil {_group getVariable QGVAR(assignment)}} &&
	{{alive _x} count units _group > 0}
) then {
	private _leaderPos = getPos leader _group;

	if (
		_group getVariable [QGVAR(allowCaching),true] && 
		{GVAR(cachingEnabled)} && 
		{allPlayers findIf {_leaderPos distance _x < GVAR(cachingDistance)} isEqualTo -1}
	) exitWith {
		_group call FUNC(cache);
	};
	
	_group call FUNC(scan);
};

if (_group isEqualType []) then {
	private _cachePos = _group # 1;

	if (
		!GVAR(cachingEnabled) || 
		{allPlayers findIf {!(_x isKindOf "HeadlessClient_F") && {_cachePos distance getPosASL _x < GVAR(cachingDistance)}} != -1}
	) then {
		_group call FUNC(uncache);
		GVAR(cache) deleteAt (GVAR(cache) find _group);
	};
};
