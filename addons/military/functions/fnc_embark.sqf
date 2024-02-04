#include "..\script_component.hpp"
// Used within 'order' function scope

private _completionRadius = 10;

if (leader _group distance2D _target >= 400) then {
	private _vehicles = [];
	private _infantry = [];

	{
		if !(_x in _x) then {
			private _vehicle = vehicle _x;
			private _driver = driver _vehicle;

			if (alive _driver && _driver in units _group) then {
				_vehicles pushBackUnique _vehicle;
				
				if (_vehicle isKindOf "Helicopter") then {
					_vehicle flyInHeight 140;
					_group reveal _target;
				};
			};
		} else {
			_infantry pushBack _x
		};
	} forEach units _group;

	if (_vehicles isNotEqualTo []) then {
		_completionRadius = 200;

		{
			private _openVehicle = selectRandom (_vehicles select {_x emptyPositions "Cargo" > 0});
			if (!isNil "_openVehicle") then {
				_x assignAsCargo _openVehicle;
				[_x] orderGetIn true;
			};
		} forEach _infantry;
	};
};

_completionRadius
