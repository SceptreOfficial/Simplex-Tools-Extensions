class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class AttributesBase {
			class Default;
			class Combo;
			class Edit;
			class Checkbox;
			class ModuleDescription;
		};
		class ModuleDescription;
	};

	class GVAR(moduleBase): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = "";
		function = "";
		isGlobal = 1;
		scope = 1;
		scopeCurator = 1;
		curatorCanAttach = 1;
	};

	class GVAR(moduleLogisticsHub) : GVAR(moduleBase) {
		displayName = "Add logistics hub";
		function = QFUNC(moduleLogisticsHub);
		scope = 2;
		scopeCurator = 2;
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\container_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\container_ca.paa";

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Makes synced objects logistics hubs";
		};
	};

	class GVAR(moduleLogisticsVehicle) : GVAR(moduleBase) {
		displayName = "Add logistics vehicle";
		function = QFUNC(moduleLogisticsVehicle);
		scope = 2;
		scopeCurator = 2;
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\car_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\car_ca.paa";

		class Attributes: AttributesBase {
			class Budget : Edit {
				displayName = "Budget";
				tooltip = "Fortify points the vehicle can use before it must resupply at a logistics hub";
				property = QGVAR(moduleLogisticsVehicle_Budget);
				typeName = "NUMBER";
				defaultValue = 1000;
			};
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Adds the logistics/fortify feature to vehicles";
		};
	};

	class GVAR(moduleResupply) : GVAR(moduleBase) {
		displayName = "Add arsenal resupply";
		function = QFUNC(moduleResupply);
		scope = 2;
		scopeCurator = 2;
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa";

		class Attributes: AttributesBase {
			class Lifetime : Edit {
				displayName = "Lifetime";
				tooltip = "";
				property = QGVAR(moduleResupply_Lifetime);
				typeName = "NUMBER";
				defaultValue = 720;
			};
			class AddHeal : Checkbox {
				displayName = "Add 'heal' action";
				tooltip = "";
				property = QGVAR(moduleResupply_AddHeal);
				typeName = "BOOL";
				defaultValue = true;
			};
			class AddMedicBag : Checkbox {
				displayName = "Add 'medic bag' action";
				tooltip = "";
				property = QGVAR(moduleResupply_AddMedicBag);
				typeName = "BOOL";
				defaultValue = false;
			};
			class RestockRespawn : Checkbox {
				displayName = "Restock on vehicle respawn";
				tooltip = "";
				property = QGVAR(moduleResupply_RestockRespawn);
				typeName = "BOOL";
				defaultValue = true;
			};
			class RestockRTB : Checkbox {
				displayName = "Restock on RTB order (SSS)";
				tooltip = "";
				property = QGVAR(moduleResupply_RestockRTB);
				typeName = "BOOL";
				defaultValue = true;
			};
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = "Adds arsenal box to ACE cargo. When unloaded, it despawns after configured lifetime.";
		};
	};
};
