#include "script_component.hpp"

params ["_object","_cargo"];

private _maxLoad = maxLoad _object;
private _load = 0;
private _validCargo = [[],[],[],[]];

{
	private _category = _forEachIndex;
	
	{
		private _mass = (_x # 0) call zen_inventory_fnc_getItemMass;
		private _validCount = 0;

		for "_i" from 1 to (_x # 1) do {
			if (_load + _mass > _maxLoad) exitWith {};
			_load = _load + _mass;
			_validCount = _i;
		};

		if (_validCount > 0) then {
			(_validCargo # _category) pushBack [(_x # 0),_validCount];
		};
	} forEach _x;
} forEach _cargo;

_validCargo
