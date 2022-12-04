#include "script_component.hpp"
/*
	File: spawnGroup.sqf
	Author: Joris-Jan van 't Land, Thomas Ryan, modified by Sceptre

	Description:
	Function which handles the spawning of a dynamic group of characters.
	The composition of the group can be passed to the function.
	Alternatively a number can be passed and the function will spawn that
	amount of characters with a random type.

	Parameter(s):
	0: the group's starting position (Array)
	1: the group's side (Side)
	2: can be three different types:
		- list of character types (Array)
		- amount of characters (Number)
		- CfgGroups entry (Config)
	3: (optional) list of relative positions (Array)
	4: (optional) list of ranks (Array)
	5: (optional) skill range (Array)
	6: (optional) ammunition count range (Array)
	7: (optional) randomization controls (Array)
		0: amount of mandatory units (Number)
		1: spawn chance for the remaining units (Number)
	8: (optional) azimuth (Number)
	9: (optional) force precise position (Bool, default: true).
	10: (optional) max. number of vehicles (Number, default: 10e10).

	Returns:
	The group (Group)
*/

params [
	["_pos",[],[[]],[2,3]],
	["_side",sideUnknown,[sideUnknown]],
	["_chars",[],[[],0,configNull]],
	["_positions",[],[[]]],
	["_ranks",[],[[]]],
	["_skillRange",[],[[]]],
	["_ammoRange",[],[[]]],
	["_randomControls",[-1,1],[[]]],
	["_azimuth",true,[0,true]],
	["_precisePosition",true,[true]],
	["_maxVehicles",10e10,[0]]
];

_randomControls params [["_minUnits",-1,[0]],["_chance",1,[0]]];

if (_azimuth isEqualType true) then {
	if (_azimuth) then {
		_azimuth = round random 360;
	} else {
		_azimuth = 0;
	};
};

private _types = switch true do {
	case (_chars isEqualType []) : {_chars};
	case (_chars isEqualType 0) : {[_side,_chars] call BIS_fnc_returnGroupComposition};
	case (_chars isEqualType configNull) : {
		// Convert a CfgGroups entry to types, positions and ranks.
		private _types = [];
		_ranks = [];
		_positions = [];

		{
			if (isClass _x) then {
				_types pushBack getText (_x >> "vehicle");
				_ranks pushBack getText (_x >> "rank");
				_positions pushBack getArray (_x >> "position");
			};
		} forEach _chars;

		_types
	};
};

// Check parameter validity.
if (_minUnits != -1 && _minUnits < 1) exitWith {
	debugLog "Log: [spawnGroup] Mandatory units should be at least 1!";
	grpNull
};

if (_chance < 0 || _chance > 1) exitWith {
	debugLog "Log: [spawnGroup] Spawn chance should be between 0 and 1!";
	grpNull
};

if (count _positions > 0 && count _types != count _positions) exitWith {
	debugLog "Log: [spawnGroup] List of positions should contain an equal amount of elements to the list of types!";
	grpNull
};

if (count _ranks > 0 && count _types != count _ranks) exitWith {
	debugLog "Log: [spawnGroup] List of ranks should contain an equal amount of elements to the list of types!";
	grpNull
};

private _grp = createGroup _side;
private _vehicles = 0;
private _spawns = [];

// Create the units according to the selected types.
{
	// Check if max. of vehicles was already spawned
	private _type = _x;
	private _isMan = _type isKindOf "CAManBase";

	if (!_isMan) then {
		_vehicles = _vehicles + 1;
	};

	if (_vehicles > _maxVehicles) then {continue};

	// See if this unit should be skipped.
	private _skip = false;
	
	if (_minUnits != -1) then {
		// Has the mandatory minimum been reached?
		if (_forEachIndex > (_minUnits - 1)) then {
			// Has the spawn chance been satisfied?
			if (random 1 < _chance) then {
				_skip = true;
			};
		};
	};

	if (_skip) then {continue};

	// If given, use relative position.
	private ["_itemPos"];

	if (_positions isNotEqualTo []) then {
		private _relPos = _positions # _forEachIndex;
		_itemPos = [_pos # 0 + _relPos # 0,_pos # 1 + _relPos # 1];
	} else {
		_itemPos = _pos;
	};

	private ["_unit"];
	
	// Is this a character or vehicle?
	if (_isMan) then {
		_unit = _grp createUnit [_type,_itemPos,[],0,"FORM"];
		_unit allowDamage false;
		_spawns pushBack _unit;
		_unit setDir _azimuth;
	} else {
		private _emptyPos = _itemPos findEmptyPosition [0,30,"B_Heli_Transport_01_F"];
		if (_emptyPos isNotEqualTo []) then {
			_itemPos = _emptyPos;
		};

		_unit = ([_itemPos,_azimuth,_type,_grp,_precisePosition] call BIS_fnc_spawnVehicle) # 0;
		_unit allowDamage false;
		_spawns pushBack _unit;
		_unit setVehiclePosition [_itemPos,[],0,"NONE"];
		[EFUNC(common,spawnCleanup),_vehicle,2] call CBA_fnc_waitAndExecute;
	};

	// If given, set the unit's rank.
	if (_ranks isNotEqualTo []) then {
		[_unit,_ranks select _forEachIndex] call BIS_fnc_setRank;
	};

	// If a range was given, set a random skill.
	if (_skillRange isNotEqualTo []) then {
		private _minSkill = _skillRange # 0;
		private _maxSkill = _skillRange # 1;
		private _diff = _maxSkill - _minSkill;

		_unit setUnitAbility (_minSkill + random _diff);
	};

	// If a range was given, set a random ammo count.
	if (_ammoRange isNotEqualTo []) then {
		private _minAmmo = _ammoRange select 0;
		private _maxAmmo = _ammoRange select 1;
		private _diff = _maxAmmo - _minAmmo;

		_unit setVehicleAmmo (_minAmmo + random _diff);
	};
} forEach _types;

[{{_x allowDamage true} forEach _this},_spawns,5] call CBA_fnc_waitAndExecute;

// Sort group members by ranks (the same as 2D editor does it)
private _newGrp = createGroup [_side,true];

while {units _grp isNotEqualTo []} do {
	private _maxRank = -1;
	private _unit = objnull;

	{
		_rank = rankid _x;
		if (
			_rank > _maxRank || 
			(_rank == _maxRank && group effectivecommander vehicle _unit == _newGrp && effectivecommander vehicle _x == _x)
		) then {
			_maxRank = _rank;
			_unit = _x;
		};
	} foreach units _grp;

	[_unit] joinsilent _newGrp;
};

_newGrp selectleader (units _newGrp # 0);

deletegroup _grp;

_newGrp
