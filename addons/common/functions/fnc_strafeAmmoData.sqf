#include "script_component.hpp"

params ["_weapon","_magazine"];

private _ammoCfg = configFile >> "CfgAmmo" >> getText (configFile >> "CfgMagazines" >> _magazine >> "ammo");
private _initSpeed = getNumber (configFile >> "CfgMagazines" >> _magazine >> "initSpeed");
private _simulation = getText (_ammoCfg >> "simulation");
private _airFriction = getNumber (_ammoCfg >> "airFriction");

if (_simulation == "shotMissile" || _simulation == "shotRocket") then {
	_initSpeed = _initSpeed + getNumber (_ammoCfg >> "thrust") * getNumber (_ammoCfg >> "thrustTime");

	if (_initSpeed > 0) then {
		_airFriction = _airFriction * -0.005;
	} else {
		_airFriction = 0;
	};
};

if (_simulation == "shotBullet") then {
	private _weaponInitSpeed = getNumber (configFile >> "CfgWeapons" >> _weapon >> "initSpeed");
	if (_weaponInitSpeed < 0) then {_initSpeed = _initSpeed * -_weaponInitSpeed};
	if (_weaponInitSpeed > 0) then {_initSpeed = _weaponInitSpeed};
};

if (_simulation == "shotSubmunitions") then {
	_airFriction = 0;
};

[
	_initSpeed,
	_airFriction,
	getNumber (_ammoCfg >> "timeToLive"),
	getNumber (_ammoCfg >> "simulationStep")
]
