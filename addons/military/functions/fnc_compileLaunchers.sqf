#include "script_component.hpp"
/*
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
*/

private _cfgMagazines = configFile >> "CfgMagazines";
private _cfgAmmo = configFile >> "CfgAmmo";
private _ATLaunchers = [];

{
	private _weapon = _x; 
	scopeName "weapon";

	if (getNumber (_weapon >> "type") isEqualTo 4) then {
		{
			private _ammoClass = _cfgAmmo >> getText (_cfgMagazines >> _x >> "ammo");

			if (!isNull _ammoClass) then {
				private _flags = _ammoClass >> "aiAmmoUsageFlags";

				if (isNull _flags) exitWith {};

				_flags = switch true do {
					case (isText _flags) : {getText _flags splitString "+ "};
					case (isNumber _flags) : {[str getNumber _flags]};
					default {[]};
				};

				// AT launcher check 1
				if (_flags isNotEqualTo [] && {"128" in _flags || "512" in _flags}) exitWith {
					_ATLaunchers pushBack configName _weapon;
					breakTo "weapon";
				};

				private _subAmmoClass = getText (_cfgAmmoClass >> "submunitionAmmo");
					
				if (_subAmmoClass isEqualTo "") exitWith {};
				
				_flags = _cfgAmmo >> _subAmmoClass >> "aiAmmoUsageFlags";
				
				if (isNull _flags) exitWith {};

				_flags = switch true do {
					case (isText _flags) : {getText _flags splitString "+ "};
					case (isNumber _flags) : {[str getNumber _flags]};
					default {[]};
				};

				// AT launcher check 2
				if (_flags isNotEqualTo [] && {"128" in _flags || "512" in _flags}) exitWith {
					_ATLaunchers pushBack configName _weapon;
					breakTo "weapon";
				};
			};
		} forEach getArray (_weapon >> "magazines");
	};
} forEach configProperties [configFile >> "CfgWeapons","isClass _x",true];

uiNamespace setVariable [QGVAR(ATLauncherTypes),_ATLaunchers];
