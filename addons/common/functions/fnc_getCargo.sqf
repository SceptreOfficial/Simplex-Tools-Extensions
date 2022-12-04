#include "script_component.hpp"
#define CARGO [getItemCargo _object,getWeaponCargo _object,getMagazineCargo _object,getBackpackCargo _object]

params ["_object",["_format",0,[0]]];

private _cargo = [[],[],[],[]];

switch _format do {
	case 0 : {// categories & items/counts
		{
			private _items = _cargo # _forEachIndex;
			private _counts = _x # 1;
			{_items pushBack [_x,_counts # _forEachIndex]} forEach (_x # 0);
		} forEach CARGO;
	};
	case 1 : {// categories & items only
		_cargo = CARGO apply {_x # 0};
	};
	case 2 : {// all items only
		_cargo = flatten (CARGO apply {_x # 0});
	};
	case 3 : {// categories & items/1
		{
			private _items = _cargo # _forEachIndex;
			{_items set [_forEachIndex,[_x,1]]} forEach (_x # 0);
		} forEach CARGO;
	};
};

_cargo
