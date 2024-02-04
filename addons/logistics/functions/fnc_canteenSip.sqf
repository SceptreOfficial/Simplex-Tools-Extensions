#include "..\script_component.hpp"
#define MAX_AE1RESERVE 4000000
#define MAX_AE2RESERVE 84000
#define MAX_ANRESERVE 2300
#define MAX_ANFATIGUE 0
#define MAX_MUSCLEDAMAGE 0

params ["_unit"];

if (!isNil QGVAR(canteenPFHID)) exitWith {
	LLSTRING(canteenBusy) call EFUNC(common,hint);
};

private _sips = _unit getVariable [QGVAR(canteenSips),GVAR(canteenCapacity)];

if (_sips <= 0) exitWith {
	LLSTRING(canteenEmpty) call EFUNC(common,hint);
};

// Animation
if (_unit in _unit && !(_unit call ace_common_fnc_isSwimming)) then {
	private _config = configFile >> "CfgWeapons" >> "ACE_Canteen";
	private _stanceIndex = ["STAND","CROUCH","PRONE"] find stance _unit;
	private _consumeAnim = getArray (_config >> "acex_field_rations_consumeAnims") param [_stanceIndex,"",[""]];
	
	if (_consumeAnim != "") then {
		[_unit,_consumeAnim,1] call ace_common_fnc_doAnimation;

		[{
			params ["_unit","_animSpeedCoef"];
			
			["ace_common_setAnimSpeedCoef",[_unit,_animSpeedCoef]] call CBA_fnc_globalEvent;
			
			if (!isNil "ace_advanced_fatigue_setAnimExclusions") then {
				ace_advanced_fatigue_setAnimExclusions deleteAt (ace_advanced_fatigue_setAnimExclusions find QUOTE(ADDON));
			};
		},[_unit,getAnimSpeedCoef _unit],1.5] call CBA_fnc_waitAndExecute;

		["ace_common_setAnimSpeedCoef",[_unit,2]] call CBA_fnc_globalEvent;

		if (!isNil "ace_advanced_fatigue_setAnimExclusions") then {
			ace_advanced_fatigue_setAnimExclusions pushBack QUOTE(ADDON);
		};
	};
};

// Reduce canteen capacity
_sips = _sips - 1;
_unit setVariable [QGVAR(canteenSips),_sips];

// Reset stamina over a period of time
GVAR(canteenPFHID) = [{
	params ["_args","_PFHID"];
	_args params ["_unit","_sips","_start","_end","_vanilla","_ace"];

	private _time = CBA_missionTime;

	if (_time >= _end) exitWith {
		_PFHID call CBA_fnc_removePerFrameHandler;
		GVAR(canteenPFHID) = nil;

		// Vanilla stamina
		_unit setStamina (_vanilla # 1);

		// ACE Adv Fatigue
		if (missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]) then {
			_unit setVariable ["ace_advanced_fatigue_ae1Reserve",nil];
			_unit setVariable ["ace_advanced_fatigue_ae2Reserve",nil];
			_unit setVariable ["ace_advanced_fatigue_anReserve",nil];
			_unit setVariable ["ace_advanced_fatigue_anFatigue",nil];
			_unit setVariable ["ace_advanced_fatigue_muscleDamage",nil];

			ace_advanced_fatigue_ae1Reserve = MAX_AE1RESERVE;
			ace_advanced_fatigue_ae2Reserve = MAX_AE2RESERVE;
			ace_advanced_fatigue_anReserve = MAX_ANRESERVE;
			ace_advanced_fatigue_anFatigue = MAX_ANFATIGUE;
			ace_advanced_fatigue_muscleDamage = MAX_MUSCLEDAMAGE;

			[_unit,0,vectorMagnitude velocity _unit min 6,false] call ace_advanced_fatigue_fnc_handleEffects;
			[_unit,_unit] call ace_advanced_fatigue_fnc_handlePlayerChanged;
		};

		if (_sips <= 0) then {
			LLSTRING(canteenDoneEmpty) call EFUNC(common,hint);
		} else {
			format [LLSTRING(canteenDoneFormat),round (_sips / GVAR(canteenCapacity) * 100),"%"] call EFUNC(common,hint);
		};
	};

	// Vanilla stamina
	_unit setStamina linearConversion [_start,_end,_time,_vanilla # 0,_vanilla # 1];

	// ACE Adv Fatigue
	if (missionNamespace getVariable ["ace_advanced_fatigue_enabled",false]) then {
		ace_advanced_fatigue_ae1Reserve = linearConversion [_start,_end,_time,_ace # 0,MAX_AE1RESERVE];
		ace_advanced_fatigue_ae2Reserve = linearConversion [_start,_end,_time,_ace # 1,MAX_AE2RESERVE];
		ace_advanced_fatigue_anReserve = linearConversion [_start,_end,_time,_ace # 2,MAX_ANRESERVE];
		ace_advanced_fatigue_anFatigue = linearConversion [_start,_end,_time,_ace # 3,MAX_ANFATIGUE];
		ace_advanced_fatigue_muscleDamage = linearConversion [_start,_end,_time,_ace # 4,MAX_MUSCLEDAMAGE];
	};
},0.3,[
	_unit,
	_sips,
	CBA_missionTime,
	CBA_missionTime + 10,
	[getStamina _unit,getNumber (configFile >> "CfgMovesFatigue" >> "staminaDuration")],
	[
		ace_advanced_fatigue_ae1Reserve,
		ace_advanced_fatigue_ae2Reserve,
		ace_advanced_fatigue_anReserve,
		ace_advanced_fatigue_anFatigue,
		ace_advanced_fatigue_muscleDamage
	]
]] call CBA_fnc_addPerFrameHandler;
