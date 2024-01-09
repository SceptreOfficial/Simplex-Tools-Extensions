[
	QGVAR(medicalClassesStr),
	"EDITBOX",
	["Medical item classes","Array of every available medical item class"],
	[LSTRING(category),"Resupply"],
	str [
		"FirstAidKit",
		"Medikit",
		"ACE_fieldDressing",
		"ACE_packingBandage",
		"ACE_elasticBandage",
		"ACE_tourniquet",
		"ACE_splint",
		"ACE_morphine",
		"ACE_adenosine",
		//"ACE_atropine",
		"ACE_epinephrine",
		"ACE_plasmaIV",
		"ACE_plasmaIV_500",
		"ACE_plasmaIV_250",
		"ACE_bloodIV",
		"ACE_bloodIV_500",
		"ACE_bloodIV_250",
		"ACE_salineIV",
		"ACE_salineIV_500",
		"ACE_salineIV_250",
		"ACE_quikclot",
		"ACE_personalAidKit",
		"ACE_surgicalKit",
		"ACE_bodyBag"
	],
	true,
	{GVAR(medicalClasses) = _this call EFUNC(common,parseArray)},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(medicalDefaultsStr),
	"EDITBOX",
	["Medical defaults","Array of default medical items players should have"],
	[LSTRING(category),"Resupply"],
	str [
		"ACE_fieldDressing",
		"ACE_packingBandage",
		"ACE_elasticBandage",
		"ACE_tourniquet",
		"ACE_splint",
		"ACE_morphine",
		"ACE_adenosine",
		"ACE_epinephrine",
		"ACE_bloodIV",
		"ACE_bloodIV_500",
		"ACE_bloodIV_250",
		"ACE_surgicalKit",
		"ACE_bodyBag"
	],
	true,
	{GVAR(medicalDefaults) = _this call EFUNC(common,parseArray)},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(deployableResupplyClass),
	"EDITBOX",
	["Deployable resupply box class","The type of box deployed"],
	[LSTRING(category),"Resupply"],
	"Box_NATO_Ammo_F",
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(deployableResupplyCooldown),
	"EDITBOX",
	["Deployable resupply cooldown","Cooldown between using the action"],
	[LSTRING(category),"Resupply"],
	"0",
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(deployableResupplyExpiration),
	"EDITBOX",
	["Deployable resupply expiration","Lifetime of deployed resupply. 0 disables expiration"],
	[LSTRING(category),"Resupply"],
	"300",
	true,
	{},
	false
] call CBA_fnc_addSetting;

if (isServer) then {
	[QEGVAR(common,flybyPosReached),{
		params ["_aircraft"];

		if (isNil {_aircraft getVariable QGVAR(resupplyArgs)}) exitWith {};
			
		_aircraft getVariable QGVAR(resupplyArgs) params ["_box","_signal1Class","_signal2Class"];

		if (_aircraft isKindOf "Helicopter") then {
			[{
				params ["_box"];	
				isNull _box || isTouchingGround _box
			},{
				params ["_box","_parachute","_signal1Class","_signal2Class"];

				if (isNull _box) exitWith {};
				
				private _offset = (boundingBoxReal _box) # 0;
				private _signal1 = _signal1Class createVehicle [0,0,0];
				_signal1 attachTo [_box,_offset];
				private _signal2 = _signal2Class createVehicle [0,0,0];
				_signal2 attachTo [_box,_offset];
			},[_box,_signal1Class,_signal2Class]] call CBA_fnc_waitUntilAndExecute;
		} else {
			_box setDir getDir _aircraft;
			_box setPosWorld (_aircraft modelToWorldVisualWorld [0,-((sizeOf typeOf _aircraft + sizeOf typeOf _box) / 2),-0.5]);
			private _parachute = [_box,getPos _box # 2,"",_signal1Class,_signal2Class] call EFUNC(common,paradropObject);
			_parachute setVelocity (velocity _aircraft vectorMultiply 0.9);
		};
	}] call CBA_fnc_addEventHandler;
};

// Deployable resupply
["CAManBase",1,["ACE_SelfActions"],[
	QGVAR(deployResupply),
	"Deploy resupply",
	"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa",
	FUNC(deployResupply),
	{(_this # 0) getVariable [QGVAR(hasResupply),false]}
] call ace_interact_menu_fnc_createAction,true] call ace_interact_menu_fnc_addActionToClass;

[QGVAR(cargoLoaded),{
	params ["_transport","_cargo"];

	if (_cargo isEqualType "" || isNil {_cargo getVariable QGVAR(resupplyUnloadTime)}) exitWith {};

	_transport addAction ["<img image='\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\getout_ca.paa'/>Unload Resupply",{
		params ["_transport","_caller","_id","_args"];
		_args params ["_cargo","_unloadTime"];

		["Unloading...",_unloadTime,{true},{
			(_this # 0) params ["_transport","_caller","_id","_args"];
			_args params ["_cargo","_unloadTime"];

			_transport removeAction _id;

			private _pos = getPosASL _transport;
			[_cargo,_pos vectorAdd ((getPosASL _caller vectorDiff _pos) vectorMultiply 0.5)] call EFUNC(common,getSafePosAndUp) params ["_safePos","_safeUp"];

			if (_safePos isNotEqualTo []) then {
				[_cargo,_safePos,[vectorDir _caller,_safeUp]] call FUNC(cargoUnload);
			} else {
				[_cargo,ATLToASL [0,0,0],[vectorDir _caller,[0,0,1]]] call FUNC(cargoUnload);
				_cargo setVehiclePosition [_caller modelToWorldVisual [0,1.5,0],[],0,"NONE"];
			};
		},{},_this] spawn CBA_fnc_progressBar;
	},[_cargo,_cargo getVariable [QGVAR(resupplyUnloadTime),0]],999,false,true,"","alive _originalTarget",5];
}] call CBA_fnc_addEventHandler;

/*
if (isServer) then {
	[QGVAR(addResupply),{
		params [
			["_vehicle",objNull,[objNull]],
			["_class","Box_NATO_Support_F",[""]],
			["_unloadTime",3,[0]],
			["_lifetime",300,[0]],
			["_autoSetup",{},[{}]],
			["_onUnload",{},[{}]],
			["_onDelete",{},[{}]]
		];
		
		if (isNull _vehicle) exitWith {};

		_vehicle setVariable [QGVAR(resupply),true,true];
		_vehicle setVariable [QGVAR(resupplyOptions),[
			_class,
			_unloadTime,
			_lifetime,
			_autoSetup,
			_onUnload,
			_onDelete
		],true];

		if (_vehicle getVariable [QGVAR(resupply),false]) exitWith {};

		private _JIPID = [QGVAR(resupplyAdded),[_vehicle]] call CBA_fnc_globalEventJIP;
		[_JIPID,_vehicle] call CBA_fnc_removeGlobalEventJIP;
		_vehicle setVariable [QGVAR(resupplyJIPID),_JIPID,true];
	}] call CBA_fnc_addEventHandler;

	[QGVAR(resupplyUnloaded),{
		params ["_crate","_vehicle","_unit"];

		(_crate getVariable [QGVAR(resupplyOptions)) params ["","","_lifetime","_autoSetup","","_onDelete"];

		_crate addEventHandler ["Deleted",_onDelete];

		_this call _autoSetup;

		if (_lifetime >= 0) then {
			[{deleteVehicle _this},_crate,_lifetime] call CBA_fnc_waitAndExecute;	
		};
	}] call CBA_fnc_addEventHandler;
};

[QGVAR(resupplyAdded),{
	params ["_vehicle"];

	if (!isNil {_vehicle getVariable QGVAR(resupplyActions)}) exitWith {};

	private _id = _vehicle addAction ["<img image='\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\getout_ca.paa'/>Unload resupply crate",{
		params ["_target","_caller","_id","_args"];
		[_target,_caller] call FUNC(resupplyUnload);
	},[],999,false,true,"",QUOTE(_originalTarget getVariable [ARR_2(QGVAR(resupply),false)]),10];

	private _path = [_vehicle,0,["ACE_MainActions"],
		[QGVAR(resupply),"Unload resupply crate","\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\getout_ca.paa",{
			params ["_target","_caller","_args"];
			[_target,_caller] call FUNC(resupplyUnload);
		},{
			params ["_target","_caller","_args"];
			_target getVariable [QGVAR(resupply),false]
		}] call ace_interact_menu_fnc_createAction
	] call ace_interact_menu_fnc_addActionToObject;

	_vehicle setVariable [QGVAR(resupplyActions),[_id,_path]];
}] call CBA_fnc_addEventHandler;
*/
