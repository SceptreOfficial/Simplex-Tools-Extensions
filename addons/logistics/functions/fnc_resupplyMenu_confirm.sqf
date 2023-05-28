#include "script_component.hpp"

private _ctrlGroup = _display displayCtrl IDC_GROUP;
private _ctrlApplication = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_APPLICATION;
private _ctrlApplicationGroup = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_APPLICATION_GROUP;
private _ctrlBoxClass = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_BOX_CLASS;
private _ctrlCargoType = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_CARGO_TYPE;
private _ctrlUnloadTime = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_UNLOAD_TIME;
private _ctrlHeight = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_HEIGHT;
private _ctrlSignal1 = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_SIGNAL1;
private _ctrlSignal2 = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_SIGNAL2;
private _ctrlVehicle = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_VEHICLE;
private _ctrlContents = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_CONTENTS;
private _ctrlContentsGroup = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_CONTENTS_GROUP;
private _ctrlWhitelist = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_WHITELIST;
private _ctrlBlacklist = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_BLACKLIST;
private _ctrlMunitions = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MUNITIONS;
private _ctrlMedical = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MEDICAL;
private _ctrlMagazineCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MAGAZINE_COUNT;
private _ctrlUnderbarrelCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNDERBARREL_COUNT;
private _ctrlRocketCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_ROCKET_COUNT;
private _ctrlThrowableCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_THROWABLE_COUNT;
private _ctrlPlaceableCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PLACEABLE_COUNT;
private _ctrlMedicalCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MEDICAL_COUNT;
private _ctrlUnitsToolbox = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNITS_TOOLBOX;
private _ctrlUnitsListbox = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNITS_LISTBOX;
private _ctrlCapacityLimit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_CAPACITY_LIMIT;

private _boxClass = ctrlText _ctrlBoxClass;

private _box = _boxClass createVehicle [0,0,0];
_box allowDamage false;
clearItemCargoGlobal _box;
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearBackpackCargoGlobal _box;

switch (lbCurSel _ctrlContents) do {
	case 0 : {
		if (cbChecked _ctrlCapacityLimit) then {
			[_box,GVAR(resupplyInventory)] call EFUNC(common,validateCargo)
		} else {
			[{
				params ["_box","_defaultMax"];
				_box setMaxLoad (_defaultMax max loadAbs _box)
			},[_box,maxLoad _box],1] call CBA_fnc_waitAndExecute;

			_box setMaxLoad MAX_LOAD;
			
			GVAR(resupplyInventory)
		} params ["_itemCargo","_weaponCargo","_magazineCargo","_backpackCargo"];

		{_box addItemCargoGlobal _x} forEach _itemCargo;
		{_box addWeaponCargoGlobal _x} forEach _weaponCargo;
		{_box addMagazineCargoGlobal _x} forEach _magazineCargo;
		{_box addBackpackCargoGlobal _x} forEach _backpackCargo;
	};
	case 1 : {
		private _units = switch (lbCurSel _ctrlUnitsToolbox) do {
			case 0 : {
				private _sides = [];
				
				{
					if (_ctrlUnitsListbox lbValue _forEachIndex > 0) then {_sides pushBack _x};
				} forEach [west,east,independent,civilian];

				allPlayers select {side group _x in _sides}
			};
			case 1 : {
				private _groups = [];

				{
					if (_ctrlUnitsListbox lbValue _forEachIndex > 0) then {_groups append units _x};
				} forEach (_ctrlUnitsListbox getVariable QGVAR(groups));

				_groups
			};
			case 2 : {
				private _players = [];

				{
					if (_ctrlUnitsListbox lbValue _forEachIndex > 0) then {_players pushBack _x};
				} forEach (_ctrlUnitsListbox getVariable QGVAR(players));

				_players
			};

		};

		[{
			params ["_box","_defaultMax"];
			_box setMaxLoad (_defaultMax max loadAbs _box)
		},[_box,maxLoad _box],1] call CBA_fnc_waitAndExecute;
		
		_box setMaxLoad MAX_LOAD;
		
		{_box addItemCargoGlobal _x} forEach ([
			_units,
			lbCurSel _ctrlMunitions == 0,
			lbCurSel _ctrlMedical == 0,
			[sliderPosition _ctrlMagazineCount,cbChecked (_ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MAGAZINE_MULTIPLY)],
			[sliderPosition _ctrlUnderbarrelCount,cbChecked (_ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNDERBARREL_MULTIPLY)],
			[sliderPosition _ctrlRocketCount,cbChecked (_ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_ROCKET_MULTIPLY)],
			[sliderPosition _ctrlThrowableCount,cbChecked (_ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_THROWABLE_MULTIPLY)],
			[sliderPosition _ctrlPlaceableCount,cbChecked (_ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PLACEABLE_MULTIPLY)],
			[sliderPosition _ctrlMedicalCount,cbChecked (_ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MEDICAL_MULTIPLY)]
		] call FUNC(resupplyAutoFill));
	};
	case 2 : {
		[
			_box,
			lbCurSel _ctrlWhitelist,
			flatten (GVAR(resupplyWhitelist) apply {_x apply {_x # 0}}),
			lbCurSel _ctrlBlacklist,
			flatten (GVAR(resupplyBlacklist) apply {_x apply {_x # 0}})
		] call EFUNC(common,addArsenal);
	};
};


switch (lbCurSel _ctrlApplication) do {
	case 0 : {
		_box setPosASL GVAR(resupplyPosASL);
		_box setVectorUp surfaceNormal getPosWorld _box;
		_box allowDamage true;

		["RESUPPLY SPAWNED"] call EFUNC(common,zeusMessage);
	};
	case 1 : {
		if (!alive GVAR(resupplyVehicle)) exitWith {systemChat "No vehicle"};

		_box allowDamage true;

		switch (lbCurSel _ctrlCargoType) do {
			case 0 : {
				if !([_box,GVAR(resupplyVehicle),true] call ace_cargo_fnc_canLoadItemIn) exitWith {
					["CANNOT LOAD IN ACE CARGO",QEGVAR(common,failure)] call EFUNC(common,zeusMessage);
					deleteVehicle _box;
				};

				if (ace_cargo_loadTimeCoefficient != 0) then {
					_box setVariable ["ace_cargo_size",sliderPosition _ctrlUnloadTime / ace_cargo_loadTimeCoefficient,true];
				};
				
				[_box,GVAR(resupplyVehicle),true] call ace_cargo_fnc_loadItem;

				["RESUPPLY LOADED IN ACE CARGO"] call EFUNC(common,zeusMessage);
			};
			case 1 : {
				_box setVariable [QGVAR(resupplyUnloadTime),sliderPosition _ctrlUnloadTime,true];
				[GVAR(resupplyVehicle),_box] call FUNC(cargoLoad);

				["RESUPPLY LOADED IN VIRTUAL CARGO"] call EFUNC(common,zeusMessage);
			};
		};
	};
	case 2 : {
		GVAR(resupplyPosASL) set [2,parseNumber ctrlText _ctrlHeight];
		_box setPos GVAR(resupplyPosASL);
		[_box,getPos _box # 2,"",_ctrlSignal1 lbData lbCurSel _ctrlSignal1,_ctrlSignal2 lbData lbCurSel _ctrlSignal2] call EFUNC(common,paradropObject);
		_box allowDamage true;

		["RESUPPLY AIRDROPPED AT MODULE POSITION"] call EFUNC(common,zeusMessage);
	};
	case 3 : {
		private _aircraftClass = _ctrlVehicle lbData lbCurSel _ctrlVehicle;
		private _altitude = parseNumber ctrlText _ctrlHeight;
		
		if (_aircraftClass isKindOf "Helicopter") then {
			private _pos = +GVAR(resupplyPosASL);
			private _aircraft = [_pos,random 360,5000,_altitude,_aircraftClass,0,[QPATHTOEF(common,functions\fnc_wpSlingloadDropoff.sqf),[_pos,_altitude]]] call EFUNC(common,flyby);

			_box setDir getDirVisual _aircraft;
			[_aircraft,_box,true,true] call EFUNC(common,slingload);
			_box setVelocity velocity _aircraft;
			{
				{_x setVelocity velocity _aircraft} forEach (ropeSegments _x);
			} forEach (_aircraft getVariable [QEGVAR(common,slingloadRopes),[]]);

			_aircraft setVariable [QGVAR(resupplyArgs),[_box,_ctrlSignal1 lbData lbCurSel _ctrlSignal1,_ctrlSignal2 lbData lbCurSel _ctrlSignal2],true];
		} else {
			//_box hideObjectGlobal true;
			private _offset = (getNumber (configFile >> "CfgVehicles" >> _aircraftClass >> "maxSpeed")) * 0.14;
			//private _dir = random 360;
			//private _pos = GVAR(resupplyPosASL) getPos [_distance,_dir];//[_distance * 0.12,_dir];
			private _aircraft = [GVAR(resupplyPosASL),_dir - 180,5000,_altitude,_aircraftClass,_offset] call EFUNC(common,flyby);
			
			_aircraft setVariable [QGVAR(resupplyArgs),[_box,_ctrlSignal1 lbData lbCurSel _ctrlSignal1,_ctrlSignal2 lbData lbCurSel _ctrlSignal2],true];
		};

		_box allowDamage true;

		["RESUPPLY AIRDROP INBOUND"] call EFUNC(common,zeusMessage);
	};
};

closeDialog 0;

