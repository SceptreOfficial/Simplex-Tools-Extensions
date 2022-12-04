#include "script_component.hpp"

params ["_targets","_checkAT"];

private _infantry = [];
private _ATInfantry = [];
private _tanks = [];
private _cars = [];
private _helis = [];
private _ATLaunchers = uiNamespace getVariable [QGVAR(ATLauncherTypes),[]];

{
	private _vehicle = vehicle _x;

	switch true do { 
		case (_vehicle isKindOf "CAManBase" || _vehicle isKindOf "StaticWeapon") : {
			if (_checkAT && {secondaryWeapon _x in _ATLaunchers}) then {
				_ATInfantry pushBack _x
			} else {
				_infantry pushBack _x;
			};
		};
		case (_vehicle isKindOf "Tank" || _vehicle isKindOf "Wheeled_APC_F") : {
			_tanks pushBack _x;
		};
		case (_vehicle isKindOf "Car") : {
			_cars pushBack _x;
		};
		case (_vehicle isKindOf "Helicopter") : {
			_helis pushBack _x;
		};
	};
} forEach _targets;

[_infantry,_ATInfantry,_tanks,_cars,_helis]
