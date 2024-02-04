#include "..\script_component.hpp"

params [
	["_unit",objNull,[objNull]],
	["_grenadeMagazine","SmokeShell",[""]],
	["_grenadeMuzzle","SmokeShellMuzzle",[""]],
	["_targetPos",[0,0,0],[[],objNull]]
];

if (!alive _unit) exitWith {};

if (!local _unit) then {
	[QGVAR(throwGrenade),_this,_unit] call CBA_fnc_targetEvent;
};

if (_targetPos isEqualType objNull) then {
	_targetPos = getPosASL _targetPos;
};

if (_targetPos isEqualTo [0,0,0]) then {
	_targetPos = AGLtoASL (_unit getRelPos [20,0]);
};

private _fireDelay = 1;

if !(_grenadeMagazine in magazines _unit) then {
	_fireDelay = 4;
	_unit addMagazine _grenadeMagazine;
};

_unit addMagazine _grenadeMagazine;

private _enableFSM = _unit checkAIFeature "FSM";
private _enablePath = _unit checkAIFeature "PATH";
private _behavior = behaviour _unit;

doStop _unit;
_unit disableAI "FSM";
_unit disableAI "PATH";
_unit setBehaviour "CARELESS";

private _target = "SoundSetSource_01_base_F" createVehicleLocal [0,0,0];
_target setPosASL (_targetPos vectorAdd [0,0,(getPosASL _unit distance _targetPos) * 0.15]);
_target enableSimulation false;

_unit reveal _target;
_unit doTarget _target;
_unit doWatch _target;

private _fnc_throw = {
	[{
		params ["_unit","_target","_grenadeMuzzle"];
		_unit forceWeaponFire [_grenadeMuzzle,_grenadeMuzzle];
		
		[{
			params ["_unit","_target","_grenadeMuzzle","","_enableFSM","_enablePath","_behavior"];

			deleteVehicle _target;
			_unit doFollow _unit;
			_unit doWatch objNull;
			_unit enableAIFeature ["FSM",_enableFSM];
			_unit enableAIFeature ["PATH",_enablePath];
			_unit setBehaviour _behavior;
		},_this,1.5] call CBA_fnc_waitAndExecute;
	},_this,_this # 3] call CBA_fnc_waitAndExecute;
};

[{
	params ["_unit","_target"];
	private _beg = eyePos _unit;
	private _end = getPosASL _target;

	!alive _unit || !(_unit in _unit) || 
	(_beg vectorAdd ((_unit weaponDirection currentWeapon _unit) vectorMultiply (_beg distance _end))) distance _end < 20
},_fnc_throw,[_unit,_target,_grenadeMuzzle,_fireDelay,_enableFSM,_enablePath,_behavior],4,_fnc_throw] call CBA_fnc_waitUntilAndExecute;
