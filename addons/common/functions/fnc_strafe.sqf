#include "script_component.hpp"

if (canSuspend) exitWith {[FUNC(strafe),_this] call CBA_fnc_directCall};

params [
	["_vehicle",objNull,[objNull]],
	["_target",[0,0,0],[[],objNull],3],
	["_weapon","",[""]],
	["_infiniteAmmo",true,[false]],
	["_approachDir",-1,[0]],
	["_spread",0,[0]],
	["_duration",4,[0]],
	["_delay",0,[0]],
	["_minRange",2000,[0]]
];

if (!alive _vehicle || !canMove _vehicle || {!(_vehicle isKindOf "Air")}) exitWith {
	ERROR("Invalid vehicle");
};

if (!local _vehicle) exitWith {
	[QGVAR(execute),[_this,QFUNC(strafe)],_vehicle] call CBA_fnc_targetEvent;
};

if (_vehicle getVariable [QGVAR(strafe),false]) exitWith {
	_vehicle setVariable [QGVAR(strafeCancel),true,true];
	
	[{isNil {_vehicle getVariable QGVAR(strafeCancel)}},FUNC(strafe),_this,5,{
		params ["_vehicle"];
		call FUNC(strafeCleanup);
		_this call FUNC(strafe);
	}] call CBA_fnc_waitUntilAndExecute;
};

if (_target in [[0,0,0],objNull]) exitWith {};

_vehicle setVariable [QGVAR(strafe),true,true];

if (_weapon isEqualTo "") then {
	_weapon = _vehicle currentWeaponTurret [-1];
};

if (_weapon isEqualTo "") exitWith {
	ERROR("Invalid vehicle");
};

if (_approachDir < 0) then {
	_approachDir = _target getDir _vehicle;
};

_duration = _duration max 0.1;
_minRange = [2500,800] select (_vehicle isKindOf "Helicopter");

// Prep approach
private _maxSpeed = (getNumber (configOf _vehicle >> "maxSpeed")) / 3.6;
private _hBuffer = getPosASL _vehicle # 2 / 2;
private _simDist = 500 max (_maxSpeed * (_duration + 3) + _hBuffer);
private _prepDist = 1000 max (_maxSpeed * (_duration + 12) + _hBuffer);

private _flyHeightASL = if (_target isEqualType objNull) then {
	(getPosASL _vehicle # 2) max (getPosASL _target # 2 + 400)
} else {
	(getPosASL _vehicle # 2) max (_target # 2 + 400)
};

_vehicle flyInHeightASL [_flyHeightASL,_flyHeightASL,_flyHeightASL];

// Disable AI targeting
private _driver = driver _vehicle;

_driver setVariable [QGVAR(strafeAIFeatures),[
	["AUTOTARGET",_driver checkAIFeature "AUTOTARGET"],
	["TARGET",_driver checkAIFeature "TARGET"]
],true];

[QGVAR(enableAIFeature),[_driver,["AUTOTARGET",false]],_driver] call CBA_fnc_targetEvent;
[QGVAR(enableAIFeature),[_driver,["TARGET",false]],_driver] call CBA_fnc_targetEvent;

_vehicle setVariable [QGVAR(strafeHeight),getPos _vehicle # 2,true];

// Begin approach
[{
	params ["_vehicle","_target","","","_approachDir","","","","","_simDist","_prepDist","_moveTick","_movePos"];

	private _aligned = abs (_approachDir - (_target getDir _vehicle)) < 45;
	private _aimed = abs (getDir _vehicle - (_vehicle getDir _target)) < [45,70] select (_vehicle isKindOf "Helicopter");

	if (_vehicle distance2D _movePos < 400 && _aligned && _aimed) exitWith {true};

	if (CBA_missionTime > _moveTick) then {
		private _distance = _vehicle distance2D _target;
		private _movePos = if (_distance > _simDist && _distance < _prepDist) then {
			if (_aligned && _aimed) then {
				_target getPos [_simDist,_approachDir]
			} else {
				_target getPos [_prepDist,_approachDir]
			};
		} else {
			if (_distance >= _prepDist && _aligned) then {
				_target getPos [_simDist,_approachDir]
			} else {
				_target getPos [_prepDist,_approachDir]
			};
		};

		_this set [11,CBA_missionTime + 3];
		_this set [12,_movePos];

		_vehicle doMove (_movePos getPos [[0,250] select (_vehicle isKindOf "Helicopter"),_vehicle getDir _movePos]);
	};

	!alive _vehicle || !canMove _vehicle || !local _vehicle || _vehicle getVariable [QGVAR(strafeCancel),false]
},{
	params ["_vehicle","_target","_weapon","_infiniteAmmo","_approachDir","_spread","_duration","_delay","_minRange"];

	if (!alive _vehicle || !canMove _vehicle || !local _vehicle || _vehicle getVariable [QGVAR(strafeCancel),false]) exitWith {
		call FUNC(strafeCleanup);
	};

	private _magazine = (weaponState [_vehicle,[-1],_weapon]) # 3;
	
	if (_magazine isEqualTo "") then {
		_magazine = compatibleMagazines _weapon arrayIntersect magazines _vehicle param [0,""];

		if (_magazine isEqualTo "" && _infiniteAmmo) then {
			_magazine = compatibleMagazines _weapon param [0,""];
			_vehicle addMagazineTurret [_magazine,[-1]];
			_vehicle loadMagazine [[-1],_weapon,_magazine];
		};
	};

	private _ammoData = [_weapon,_magazine] call FUNC(strafeAmmoData);

	_delay = _delay max getNumber (configFile >> "CfgWeapons" >> _weapon >> weaponState [_vehicle,[-1],_weapon] # 2 >> "reloadTime");

	private _yRelVel = velocityModelSpace _vehicle # 1;
	private _maxSpeed = getNumber (configOf _vehicle >> "maxSpeed") / 3.6;
	private _minSpeed = [
		getNumber (configOf _vehicle >> "stallSpeed") * 1.6 / 3.6,
		(_maxSpeed * 0.7) max 30
	] select (_vehicle isKindOf "Helicopter");

	if (_ammoData # 0 <= 0 && isNil {_vehicle getVariable QGVAR(strafeFiredEHID)}) then {
		_vehicle setVariable [QGVAR(strafeFiredEHID),
			[_vehicle,"Fired",FUNC(strafeBombFired),_weapon] call CBA_fnc_addBISEventHandler
		];
	};

	if (!isNil {_vehicle getVariable QGVAR(strafeSimEHID)}) exitWith {
		call FUNC(strafeCleanup);
		ERROR("Invalid vehicle");
	};

	// Begin simulation
	private _ID = addMissionEventHandler ["EachFrame",{call FUNC(strafeSim)},[
		_vehicle,
		_target,
		_weapon,
		_infiniteAmmo,
		_spread,
		_duration,
		_delay,
		_minRange,
		_magazine,
		_ammoData,
		[_minSpeed,_maxSpeed],
		[[],[],[],CBA_missionTime - 2],
		velocityModelSpace _vehicle,
		getPosASL _vehicle,
		velocity _vehicle,
		0,
		0,
		[vectorDir _vehicle,vectorUp _vehicle] call FUNC(yawPitchBank),
		CBA_missionTime
	]];

	_vehicle setVariable [QGVAR(strafeSimEHID),_ID];
},[
	_vehicle,
	_target,
	_weapon,
	_infiniteAmmo,
	_approachDir,
	_spread,
	_duration,
	_delay,
	_minRange,
	_simDist,
	_prepDist,
	0,
	_target getPos [_prepDist / 2,_approachDir]
]] call CBA_fnc_waitUntilAndExecute;
