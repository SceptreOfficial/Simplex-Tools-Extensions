#include "script_component.hpp"

if (GVAR(brainTick) > CBA_missionTime) exitWith {};

if (GVAR(brainList) isEqualTo []) exitWith {
	GVAR(brainList) = units civilian select {local _x && {_x getVariable [QGVAR(brain),false]}};
	GVAR(brainList) append (agents select {local agent _x && {agent _x getVariable [QGVAR(brain),false]}});
	GVAR(brainList) append GVAR(parked);
	GVAR(brainList) append GVAR(cache);

	if (GVAR(brainList) isEqualTo []) then {
		GVAR(brainTick) = CBA_missionTime + 5;
	} else {
		GVAR(brainTick) = CBA_missionTime + 0.1;
	};
};

private _unit = GVAR(brainList) deleteAt 0;
GVAR(brainTick) = CBA_missionTime + 0.1;

// Uncache if possible
if (_unit isEqualType []) exitWith {
	private _posASL = _unit # 1 # 1;

	if (!GVAR(cachingEnabled) || 
		{allPlayers findIf {!(_x isKindOf "HeadlessClient_F") && {_posASL distance getPosASL _x < GVAR(cachingDistance)}} != -1}
	) then {
		GVAR(brainList) pushBack (_unit call FUNC(uncache));
	};
};

if !(_unit isEqualType objNull) then {
	_unit = agent _unit;
};

// Remove dead objects
if (!alive _unit) exitWith {
	if !(_unit isKindOf "CAManBase") exitWith {
		GVAR(parked) deleteAt (GVAR(parked) find _unit);
	};

	_unit setVariable [QGVAR(brain),nil,true];
};

// Cache if possible
if (GVAR(cachingEnabled) && 
	{_unit getVariable [QGVAR(allowCaching),false]} && 
	{allPlayers findIf {_unit distance _x < GVAR(cachingDistance)} isEqualTo -1}
) exitWith {
	_unit call FUNC(cache);
};

if (!(_unit isKindOf "CAManBase") ||
	_unit getVariable [QGVAR(panicking),false] ||
	{!(unitReady _unit || _unit getVariable [QGVAR(moveTick),-1] < CBA_missionTime)}
) exitWith {};

_unit setVariable [QGVAR(moveTick),CBA_missionTime + 200];

private _area = _unit getVariable [QGVAR(inhabitancy),[getPos _unit,100,100,0,false]];
private _pos = getPos _unit;

if (_unit in _unit) then {
	// Chance to base random pos from current pos
	if (random 1 < 0.5) then {
		for "_i" from 1 to 20 do {
			_pos = _unit getPos [60 + random 40,random 360];
			if (!surfaceIsWater _pos) exitWith {};
		};
	} else {
		for "_i" from 1 to 20 do {
			_pos = [_area,false] call CBA_fnc_randPosArea;
			if (!surfaceIsWater _pos) exitWith {};
		};
	};

	private _buildings = nearestObjects [_pos,["Building"],100,true];

	// Move to a nearby building if possible
	if (_buildings isNotEqualTo []) then {
		_pos = _buildings # 0 getPos [random 15,random 360];
	};
} else {
	// Try to find a road
	private _area = +_area;
	_area set [1,_area # 1 + 200];
	_area set [2,_area # 2 + 200];

	for "_i" from 1 to 3 do {
		for "_i" from 1 to 20 do {
			_pos = [_area,false] call CBA_fnc_randPosArea;
			if (!surfaceIsWater _pos) exitWith {};
		};

		private _road = [_pos,_pos nearRoads 500] call EFUNC(common,getNearest);

		if (!isNull _road) exitWith {
			_pos = getPosATL _road;
		};
	};
};

if (isNull group _unit) then {
	[{
		params ["_unit","_pos"];
		
		if (_unit in _unit) then {
			_unit forceSpeed (_unit getSpeed "SLOW");
		} else {
			_unit forceSpeed (vehicle _unit getSpeed "NORMAL");
		};
		
		_unit moveTo _pos;
	},[_unit,_pos],3] call CBA_fnc_waitAndExecute;
} else {
	doStop _unit;

	[{
		params ["_unit","_pos"];
		_unit doFollow _unit;
		_unit setSpeedMode "LIMITED";
		_unit doMove _pos;
	},[_unit,_pos],3] call CBA_fnc_waitAndExecute;
};
