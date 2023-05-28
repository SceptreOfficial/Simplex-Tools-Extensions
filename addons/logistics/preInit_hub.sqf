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

					private _pos = getPosASL _target;
					private _box = "Box_NATO_Equip_F" createVehicle [0,0,0];
					[_box,_pos vectorAdd ((getPosASL _caller vectorDiff _pos) vectorMultiply 0.5)] call EFUNC(common,getSafePosAndUp) params ["_safePos","_safeUp"];

					_box setDir (getDirVisual (_this # 1) - 90);

					if (_safePos isNotEqualTo []) then {
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
					{
						if (_x getVariable [QGVAR(constructionVehicle),false]) then {
							_x setVariable [QGVAR(constructionBudget),_x getVariable QGVAR(constructionMaxBudget),true];
							format [LLSTRING(constructionResupplied),getText (configOf _x >> "displayName")] call EFUNC(common,hint);
						};
					} forEach (_this # 0 nearEntities 20);
				},
				{true}
			] call ace_interact_menu_fnc_createAction
		] call ace_interact_menu_fnc_addActionToObject;
	};
}] call CBA_fnc_addEventHandler;
