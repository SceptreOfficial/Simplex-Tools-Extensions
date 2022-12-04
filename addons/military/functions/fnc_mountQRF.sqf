#include "script_component.hpp"

params ["_group"];

private _vehicles = [];
private _infantry = [];

{
	if (_x in _x) then {
		_infantry pushBack _x;
	} else {
		_vehicles pushBackUnique vehicle _x;
	};
} forEach units _group;

if (_vehicles isEqualTo []) exitWith {};

{
	private _openVehicle = selectRandom (_vehicles select {_x emptyPositions "Cargo" > 0});

	if (!isNil "_openVehicle") then {
		_x assignAsCargo _openVehicle;
		[_x] orderGetIn true;
	};
} forEach _infantry;
