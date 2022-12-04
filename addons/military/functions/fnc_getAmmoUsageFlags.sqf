#include "script_component.hpp"
/*-----------------------------------------------------------------------------------------------//
Authors: Sceptre
Returns ammo usage flags from an ammo (or supplied magazine) type.
NOTE: Relies on aiAmmoUsageFlags, could be unreliable

Parameters:
0: Ammo or magazine classname <STRING>

(https://community.bistudio.com/wiki/CfgAmmo_Config_Reference#aiAmmoUsageFlags):
Value 	| Type 				| Description
--------|-------------------|-------------------------------
0 		| None 				| ???
1 		| Light 			| used for illumination
2 		| Marking 			| ???
4 		| Concealment 		| used for smokes
8 		| CounterMeasures 	| ???
16 		| Mine 				| ???
32 		| Underwater 		| used in underwater environment
64 		| OffensiveInf 		| against infantry
128 	| OffensiveVeh 		| against vehicles
256 	| OffensiveAir 		| against air
512 	| OffensiveArmour 	| against armored vehicles

Returns:
Array of usage flags as strings
//-----------------------------------------------------------------------------------------------*/
params [["_class","",[""]]];

if (isNil QGVAR(ammoUsageFlags)) then {
	GVAR(ammoUsageFlags) = createHashMap;
};

private _usageFlags = GVAR(ammoUsageFlags) get _class;

if (!isNil "_usageFlags") exitWith {_usageFlags};

_usageFlags = [];

private _cfgAmmoClass = switch true do {
	case (isClass (configFile >> "CfgMagazines" >> _class)) : {
		configFile >> "CfgAmmo" >> getText (configFile >> "CfgMagazines" >> _class >> "ammo")
	};
	case (isClass (configFile >> "CfgAmmo" >> _class)) : {
		configFile >> "CfgAmmo" >> _class
	};
	default {configNull};
};

if (isNull _cfgAmmoClass) exitWith {[]};

private _flags = _cfgAmmoClass >> "aiAmmoUsageFlags";

if (!isNull _flags) then {
	_usageFlags = switch true do {
		case (isText _flags) : {getText _flags splitString "+ "};
		case (isNumber _flags) : {str getNumber _flags splitString "+ "};
		default {[]};
	};
};

if (_usageFlags isEqualTo []) then {
	private _subAmmoClass = getText (_cfgAmmoClass >> "submunitionAmmo");
		
	if (_subAmmoClass isNotEqualTo "") then {
		private _flags = configFile >> "CfgAmmo" >> _subAmmoClass >> "aiAmmoUsageFlags";
		
		if (!isNull _flags) then {
			_usageFlags = switch true do {
				case (isText _flags) : {getText _flags splitString "+ "};
				case (isNumber _flags) : {str getNumber _flags splitString "+ "};
				default {[]};
			};
		};
	};
};

GVAR(ammoUsageFlags) set [_class,_usageFlags];

_usageFlags
