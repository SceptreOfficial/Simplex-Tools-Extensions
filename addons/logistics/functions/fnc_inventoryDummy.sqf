#include "script_component.hpp"

params [
	["_cargo",[],[[]]],
	["_closeCode",{},[{}]],
	"_closeArgs",
	["_class","B_supplyCrate_F",[""]],
	["_maxLoad",MAX_LOAD,[0]]
];

private _dummy = _class createVehicleLocal [0,0,0];
_dummy allowDamage false;
hideObject _dummy;
_dummy setMaxLoad _maxLoad;

clearItemCargo _dummy;
clearMagazineCargo _dummy;
clearWeaponCargo _dummy;
clearBackpackCargo _dummy;

[_dummy,_cargo] call EFUNC(common,validateCargo) params ["_itemCargo","_weaponCargo","_magazineCargo","_backpackCargo"];
{_dummy addItemCargo _x} forEach _itemCargo;
{_dummy addWeaponCargo _x} forEach _weaponCargo;
{_dummy addMagazineCargo _x} forEach _magazineCargo;
{_dummy addBackpackCargo _x} forEach _backpackCargo;

[{
	params ["_dummy","_closeCode","_closeArgs","_maxLoad"];

	_dummy call zen_inventory_fnc_configure;
	
	private _zenDisplay = uiNamespace getVariable "zen_common_display";
	_zenDisplay setVariable ["zen_inventory_maximumLoad",_maxLoad];
	(_zenDisplay displayCtrl 1508) progressSetPosition (0 max (loadAbs _dummy / maxLoad _dummy) min 1);
 
	[{isNull (_this # 0)},{
		params ["","_dummy","_closeCode","_closeArgs"];
		[_dummy,_closeArgs] call _closeCode;
		deleteVehicle _dummy;
	},[_zenDisplay,_dummy,_closeCode,_closeArgs]] call CBA_fnc_waitUntilAndExecute;
},[_dummy,_closeCode,_closeArgs,_maxLoad]] call CBA_fnc_execNextFrame;
