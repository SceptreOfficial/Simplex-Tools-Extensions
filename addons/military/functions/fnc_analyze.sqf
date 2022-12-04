#include "script_component.hpp"
#define RATING_HELI GVAR(RatingHelicopter)
#define RATING_TANK GVAR(RatingTank)
#define RATING_CAR GVAR(RatingCar)

params ["_group","_side","_targets"];

private _target = selectRandom _targets;
private _canEngage = true;
private _respondingGroups = [];
private _strength = 0;

// Calculate enemy threat and assist ratios
([_targets,false] call FUNC(getTypes)) params ["_enemyInfantry","","_enemyTanks","_enemyCars"];

private _threatRating = count _enemyInfantry + count _enemyTanks * RATING_TANK + count _enemyCars * RATING_CAR;
private _assistRatio = _threatRating * GVAR(AssistCoef);
private _QRFRatio = _assistRatio * GVAR(QRFRatio);
//private _vehicleRatio = _assistRatio * 0.3;

// Add the reporting group if it's free
if (_group getVariable QGVAR(available)) then {
	_respondingGroups pushBack _group;

	([units _group,true] call FUNC(getTypes)) params ["_infantry","_groupAT","_tanks","_cars","_helis"];

	_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;
	_canEngage = count _groupAT >= count _enemyTanks;

	_target = if (_canEngage && _enemyTanks isNotEqualTo []) then {
		selectRandom _enemyTanks
	} else {
		selectRandom _targets
	};

	_group setVariable [QGVAR(target),_target,true];
};

// Get the nearest available groups and units
private _leader = leader _group;
private _requestDistance = _group getVariable QGVAR(requestDistance);
private _availableGroups = (allGroups select {
	private _distance = leader _x distance2D _leader;
	
	_x getVariable [QGVAR(available),false] &&
	{_x getVariable QGVAR(side) isEqualTo _side} &&
	{_distance <= _requestDistance && _distance <= (_x getVariable QGVAR(responseDistance))}
}) - [_group];

if (_availableGroups isEqualTo []) exitWith {[_target,_canEngage,_threatRating,_strength,_respondingGroups]};

private _nearestGroups = [_availableGroups,true,{leader _x distance2D _leader}] call EFUNC(common,sortBy);
private _nearestUnits = [];
private _urgentUnits = [];

{
	_nearestUnits append (units _x);

	if (leader _x distance2D _leader < 400) then {
		_urgentUnits append (units _x);
		_x setBehaviour "AWARE";
		_x setSpeedMode "NORMAL";
	};
} forEach _nearestGroups;

([_nearestUnits,true] call FUNC(getTypes)) params ["_nearestInfantry","_nearestAT","_nearestTanks","_nearestCars","_nearestHelis"];

// Calculate immediate strength
private _urgentStrength = _strength + (
	count (_urgentUnits arrayIntersect _nearestInfantry) +
	count (_urgentUnits arrayIntersect _nearestAT) * RATING_TANK * 0.75 +
	count (_urgentUnits arrayIntersect _nearestTanks) * RATING_TANK +
	count (_urgentUnits arrayIntersect _nearestCars) * RATING_CAR +
	count (_urgentUnits arrayIntersect _nearestHelis) * RATING_HELI
);

// Add any needed AT units
if (_enemyTanks isNotEqualTo []) then {
	{
		if (_nearestAT isNotEqualTo []) then {
			private _grp = group (_nearestAT deleteAt 0);
			
			if (_respondingGroups pushBackUnique _grp isNotEqualTo -1) then {
				([units _grp,false] call FUNC(getTypes)) params ["_infantry","","_tanks","_cars","_helis"];
				
				_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;
				
				_grp setVariable [QGVAR(target),_x,true];

				if (!_canEngage) then {
					_canEngage = leader _grp distance _leader < 400;
				};
			};
		};

		if (_nearestTanks isNotEqualTo []) then {
			private _grp = group (_nearestTanks deleteAt 0);
			
			if (_respondingGroups pushBackUnique _grp isNotEqualTo -1) then {
				([units _grp,false] call FUNC(getTypes)) params ["_infantry","","_tanks","_cars","_helis"];
				
				_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;
				
				_grp setVariable [QGVAR(target),_x,true];

				if (!_canEngage) then {
					_canEngage = leader _grp distance _leader < 400;
				};
			};
		};
	} forEach _enemyTanks;
};

// Add nearest QRF until ratio satisfied
private _nearestQRF = _nearestGroups select {(_x getVariable QGVAR(assignment)) == "QRF"};

if (_nearestQRF isNotEqualTo []) then {
	{
		if (_strength >= _QRFRatio) exitWith {};

		if (_respondingGroups pushBackUnique _x isNotEqualTo -1) then {
			([units _x,false] call FUNC(getTypes)) params ["_infantry","","_tanks","_cars","_helis"];
			
			_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;

			_x setVariable [QGVAR(target),selectRandom _targets,true];
		};
	} forEach _nearestQRF;
};

// Add any extra needed groups until ratio satisfied
if (_nearestGroups isNotEqualTo []) then {
	{
		if (_strength >= _assistRatio) exitWith {};

		if (_respondingGroups pushBackUnique _x isNotEqualTo -1) then {
			([units _x,false] call FUNC(getTypes)) params ["_infantry","","_tanks","_cars","_helis"];
			
			_strength = _strength + count _infantry + count _tanks * RATING_TANK + count _cars * RATING_CAR + count _helis * RATING_HELI;

			_x setVariable [QGVAR(target),selectRandom _targets,true];
		};
	} forEach _nearestGroups;
};

// Return
[_target,_canEngage,_threatRating,_urgentStrength,_respondingGroups]

