#include "script_component.hpp"

_thisArgs params [
	"_vehicle",
	"_target",
	"_weapon",
	"_infiniteAmmo",
	"_spread",
	"_duration",
	"_delay",
	"_minRange",
	"_magazine",
	"_ammoData",
	"_speedLimits",
	"_path",
	"_relVel",
	"_lastPos",
	"_lastVelocity",
	"_fireStart",
	"_fireTick",
	"_rotations",
	"_tick"
];

if (!alive _vehicle ||
	!canMove _vehicle ||
	!local _vehicle ||
	_vehicle getVariable [QGVAR(strafeCancel),false] ||
	{_fireStart > 0 && (CBA_missionTime - _fireStart) / _duration > 1}
) exitWith {call FUNC(strafeCleanup)};

private _interval = CBA_missionTime - (_path # 3);
private _abort = false;

if (_interval >= 0.4) then {call FUNC(strafeUpdate)};

if (_abort) exitWith {call FUNC(strafeCleanup)};

_path params ["_posList","_dirList","_upList"];

if (_posList isEqualTo []) exitWith {};

private _pos = _interval bezierInterpolation _posList;
private _dir = _interval bezierInterpolation _dirList;
private _up = _interval bezierInterpolation _upList;
private _velocity = _pos vectorDiff _lastPos vectorMultiply 1 / diag_deltaTime / accTime;
_thisArgs set [13,_pos];
_thisArgs set [14,_velocity];
_thisArgs set [18,CBA_missionTime];

_vehicle setVelocityTransformation [_pos,_pos,_velocity,_velocity,_dir,_dir,_up,_up,_interval];
_vehicle setVelocity _velocity;

if (_fireStart > 0 && _fireStart < CBA_missionTime && _fireTick < CBA_missionTime) then {
	weaponState [_vehicle,[-1],_weapon] params ["","_muzzle","_firemode","","_ammoCount"];
	
	if (_infiniteAmmo && _ammoCount <= 0) then {
		//_vehicle addMagazineTurret [_magazine,[-1]];
		//_vehicle loadMagazine [[-1],_weapon,_magazine];
		//_vehicle setWeaponReloadingTime [driver _vehicle,_muzzle,0];
		_vehicle setVehicleAmmo 1;
		_ammoCount = 1;
	};

	if (_ammoCount <= 0) exitWith {
		_abort = true;
	};

	if ((_vehicle currentWeaponTurret [-1]) != _weapon) then {
		driver _vehicle selectWeapon [_weapon,_muzzle,_firemode];
	};

	[QGVAR(strafeFire),[_vehicle,_weapon,(CBA_missionTime - _fireStart) / _duration]] call CBA_fnc_localEvent;

	//_vehicle setVehicleAmmo 1;
	//_vehicle fireAtTarget [objNull,_muzzle];
	driver _vehicle forceWeaponFire [_muzzle,_firemode];
	
	_thisArgs set [16,CBA_missionTime + _delay];
};

if (_abort) then {call FUNC(strafeCleanup)};
