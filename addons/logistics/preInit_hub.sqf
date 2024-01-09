[
	QGVAR(boxSpawnerClassesStr),
	"EDITBOX",
	[LSTRING(boxSpawnerClassesStrName),LSTRING(boxSpawnerClassesStrInfo)],
	[LSTRING(category),"Logistics Hub"],
	"Box_NATO_Equip_F,B_supplyCrate_F,Box_NATO_Ammo_F,Box_NATO_Support_F,Box_NATO_Wps_F",
	true,
	{GVAR(boxSpawnerClasses) = _this call EFUNC(common,parseList)},
	false
] call CBA_fnc_addSetting;

[QGVAR(hubCreated),{
	params ["_hub"];

	if (_hub getVariable [QGVAR(hubEditInventories),true]) then {
		[{
			params ["_hub","_PFHID"];

			if (!alive _hub) exitWith {_PFHID call CBA_fnc_removePerFrameHandler};

			private _nearSupplies = _hub nearSupplies 20;
			private _prevSupplies = _hub getVariable [QGVAR(prevSupplies),[]];
			_hub setVariable [QGVAR(prevSupplies),_nearSupplies];

			{
				[_x,0,["ACE_MainActions",QGVAR(hubEdit)]] call ace_interact_menu_fnc_removeActionFromObject;
				_x setVariable [QGVAR(editInventory),nil];
			} forEach (_prevSupplies - _nearSupplies);

			{
				if !(_x getVariable [QGVAR(editInventory),false] || _x isKindOf "CAManBase") then {
					[_x,0,["ACE_MainActions"],
						[
							QGVAR(hubEdit),
							LLSTRING(editInventory),
							"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa",
							{_this # 0 call zen_inventory_fnc_configure},
							{true}
						] call ace_interact_menu_fnc_createAction
					] call ace_interact_menu_fnc_addActionToObject;

					_x setVariable [QGVAR(editInventory),true];

					//_x setVariable [QGVAR(hasEditAction),true];
					//_x addAction [
					//	format ["<img image='%1'/>Edit Inventory",
					//	"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa"],
					//	{_this # 0 call zen_inventory_fnc_configure},
					//	[],
					//	1.5,
					//	true,
					//	true,
					//	"",
					//	format ["%1 findIf {_originalTarget distance _x <= 15} > -1",QGVAR(logisticsHubs)],
					//	5
					//];
				};
			} forEach _nearSupplies;
		},1,_hub] call CBA_fnc_addPerFrameHandler;
	};

	if (_hub getVariable [QGVAR(hubBoxSpawn),true]) then {
		[_hub,0,["ACE_MainActions"],
			[
				QGVAR(hubBoxSpawn),
				LLSTRING(spawnBox),
				"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\box_ca.paa",
				{
					params ["_target","_caller"];

					private _cfgVehicles = configFile >> "CfgVehicles";
					private _boxNames = GVAR(boxSpawnerClasses) apply {getText (_cfgVehicles >> _x >> "displayName")};

					[LLSTRING(spawnBox),[
						["LISTNBOX","Box",[_boxNames,0,8,GVAR(boxSpawnerClasses)]]
					],{
						params ["_values","_args"];
						_values params ["_boxClass"];
						_args params ["_pos","_caller"];

						private _box = _boxClass createVehicle [0,0,0];
						[_box,_pos vectorAdd ((getPosASL _caller vectorDiff _pos) vectorMultiply 0.5)] call EFUNC(common,getSafePosAndUp) params ["_safePos","_safeUp"];

						_box setDir (getDirVisual _caller - 180);

						if (_safePos isNotEqualTo [] && _safeUp isNotEqualTo []) then {
							_box setPosASL _safePos;
							_box setVectorUp _safeUp;
						} else {
							_box setVehiclePosition [_caller modelToWorldVisual [0,1.5,0],[],0,"NONE"];
						};

						clearItemCargoGlobal _box;
						clearWeaponCargoGlobal _box;
						clearMagazineCargoGlobal _box;
						clearBackpackCargoGlobal _box;

						"Box spawned nearby" call EFUNC(common,hint);
					},[getPosASL _target,_caller]] call EFUNC(sdf,dialog);
				},
				{true}
			] call ace_interact_menu_fnc_createAction
		] call ace_interact_menu_fnc_addActionToObject;
	};

	if (_hub getVariable [QGVAR(hubConstructionResupply),true]) then {
		[_hub,0,["ACE_MainActions"],
			[
				QGVAR(hubConstructionResupply),
				LLSTRING(ConstructionResupplyName),
				"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\container_ca.paa",
				{
					params ["_hub"];

					private _pool = _hub call FUNC(constructionPool);

					if (_pool == 0) exitWith {
						"No supplies left in global pool" call EFUNC(common,hint);
					};

					private _vehicles = [];
					private _vehicleRows = [];

					{
						if (_x getVariable [QGVAR(constructionVehicle),false]) then {
							private _budget = _x getVariable [QGVAR(constructionBudget),1e39];
							private _maxBudget = _x getVariable [QGVAR(constructionMaxBudget),1e39];

							if (_budget >= _maxBudget) then {continue};

							_vehicles pushBack _x;
							_vehicleRows pushBack [
								getText (configOf _x >> "displayName"),
								"",
								format ["($%1 / $%2)",_budget,_maxBudget]
							];

							//_x setVariable [QGVAR(constructionBudget),_x getVariable [QGVAR(constructionMaxBudget),1000],true];
							//format [LLSTRING(constructionResupplied),getText (configOf _x >> "displayName")] call EFUNC(common,hint);
						};
					} forEach (_this # 0 nearEntities 20);

					[LLSTRING(ConstructionResupplyName),[
						["LISTNBOX",["Construction vehicle",""],[_vehicleRows,0,5,_vehicles]]
					],{
						params ["_values","_hub"];
						_values params ["_vehicle"];

						private _pool = _hub call FUNC(constructionPool);

						if (_pool == 0) exitWith {
							"No supplies left in global pool" call EFUNC(common,hint);
						};

						private _budget = _vehicle getVariable [QGVAR(constructionBudget),1e39];
						private _maxBudget = _vehicle getVariable [QGVAR(constructionMaxBudget),1e39];
						private _supply = (_maxBudget - _budget) min ([_pool,1e39] select (_pool == -1));

						_vehicle setVariable [QGVAR(constructionBudget),_budget + _supply,true];
						[_hub,-_supply] call FUNC(constructionPoolUpdate);
						
						format [LLSTRING(constructionResupplied),getText (configOf _vehicle >> "displayName")] call EFUNC(common,hint);
					},_hub] call EFUNC(sdf,dialog);

				},
				{true},
				{},
				[],
				nil,
				nil,
				nil,
				{
					params ["_hub","","","_actionData"];
					private _pool = _hub call FUNC(constructionPool);
					_actionData set [1,format [LLSTRING(ConstructionResupplyFormat),["(∞)",format ["($%1)",_pool]] select (_pool != -1)]];
				}
			] call ace_interact_menu_fnc_createAction
		] call ace_interact_menu_fnc_addActionToObject;
	};
}] call CBA_fnc_addEventHandler;
