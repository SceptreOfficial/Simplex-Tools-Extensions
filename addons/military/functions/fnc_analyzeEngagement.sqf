#include "script_component.hpp"
#define RATING_HELI 7
#define RATING_TANK 6
#define RATING_CAR 3

params ["_respondingGroups","_side","_knownTargets"];

([_knownTargets,false] call FUNC(getTypes)) params ["_enemyInfantry","","_enemyTanks","_enemyCars"];

private _threatRating = count _enemyInfantry + count _enemyTanks * RATING_TANK + count _enemyCars * RATING_CAR;
private _countAT = 0;
private _strength = 0;

{
	([units _x,true] call FUNC(getTypes)) params ["_infantry","_AT","_tanks","_cars","_helis"];
	
	_countAT = _countAT + count _AT;
	_strength = _strength + (
		count _infantry +
		_countAT * RATING_TANK * 0.75 +
		count _tanks * RATING_TANK +
		count _cars * RATING_CAR +
		count _helis * RATING_HELI
	);
} forEach _respondingGroups;

[_countAT >= count _enemyTanks,_threatRating,_strength]
