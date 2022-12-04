#include "script_component.hpp"

params ["_objects",["_selection",false]];

[LLSTRING(moduleResetObjectsName),[
	["COMBOBOX","Selection",[["Module selection","All mission objects"],0],_selection],
	["CHECKBOX","Heal/Repair",true,false],
	["CHECKBOX","Refuel vehicles",true,false],
	["CHECKBOX","Rearm vehicles",true,false]
],{
	params ["_values","_objects"];
	_values params ["_selection","_heal","_refuel","_rearm"];

	if (_selection == 1) then {
		_objects = allUnits + vehicles;
	};

	{
		if (_x isKindOf "CAManBase" && _heal) then {
			[_x] call zen_common_fnc_healUnit;
			continue;
		};

		if (_heal) then {_x setDamage 0};
		if (_refuel) then {["zen_common_setFuel",[_x,1],_x] call CBA_fnc_targetEvent};
		if (_rearm) then {[_x,1] call zen_common_fnc_setVehicleAmmo};
	} forEach _objects;
},_objects] call EFUNC(sdf,dialog);
