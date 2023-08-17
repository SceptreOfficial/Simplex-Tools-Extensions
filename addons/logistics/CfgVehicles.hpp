class CBA_Extended_EventHandlers_base;

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

	class GVAR(moduleCanteenTap): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleCanteenTapName);
		icon = "\z\ace\addons\field_rations\ui\icon_water_tap.paa";
		portrait = "\z\ace\addons\field_rations\ui\icon_water_tap.paa";
		function = QFUNC(moduleCanteenTap);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CSTRING(moduleCanteenTapInfo);
		};
	};

	class GVAR(moduleHub): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleHubName);
		icon = "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\modeModules_ca.paa";
		portrait = "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\modeModules_ca.paa";
		function = QFUNC(moduleHub);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class EditInventories : Checkbox {
				displayName = CSTRING(EditInventoriesName);
				tooltip = CSTRING(EditInventoriesInfo);
				property = QGVAR(moduleHub_EditInventories);
				typeName = "BOOL";
				defaultValue = "true";
			};
			class BoxSpawn : Checkbox {
				displayName = CSTRING(BoxSpawnName);
				tooltip = CSTRING(BoxSpawnInfo);
				property = QGVAR(moduleHub_BoxSpawn);
				typeName = "BOOL";
				defaultValue = "true";
			};
			class CanteenTap : Checkbox {
				displayName = CSTRING(CanteenTapName);
				tooltip = CSTRING(CanteenTapInfo);
				property = QGVAR(moduleHub_CanteenTap);
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ConstructionResupply : Checkbox {
				displayName = CSTRING(ConstructionResupplyName);
				tooltip = CSTRING(ConstructionResupplyInfo);
				property = QGVAR(moduleHub_ConstructionResupply);
				typeName = "BOOL";
				defaultValue = "true";
			};
			class Arsenal : Checkbox {
				displayName = CSTRING(ArsenalName);
				tooltip = CSTRING(ArsenalInfo);
				property = QGVAR(moduleHub_Arsenal);
				typeName = "BOOL";
				defaultValue = "true";
			};
			class ArsenalWhitelistUsage : Combo {
				displayName = CSTRING(ArsenalWhitelistUsageName);
				tooltip = CSTRING(ArsenalWhitelistUsageInfo);
				property = QGVAR(moduleHub_ArsenalWhitelistUsage);
				typeName = "NUMBER";
				defaultValue = 0;

				class Values {
					class Disabled {
						name = CSTRING(Disabled);
						value = 0;
						default = 1;
					};
					class Setting {
						name = CSTRING(Setting);
						value = 1;
					};
					class Custom {
						name = CSTRING(Custom);
						value = 2;
					};
					class Both {
						name = CSTRING(Both);
						value = 3;
					};
				};
			};
			class ArsenalWhitelist : Edit {
				displayName = CSTRING(ArsenalWhitelistName);
				property = QGVAR(moduleHub_ArsenalWhitelist);
				typeName = "STRING";
				defaultValue = "''";
			};
			class ArsenalBlacklistUsage : Combo {
				displayName = CSTRING(ArsenalBlacklistUsageName);
				tooltip = CSTRING(ArsenalBlacklistUsageInfo);
				property = QGVAR(moduleHub_ArsenalBlacklistUsage);
				typeName = "NUMBER";
				defaultValue = 1;

				class Values {
					class Disabled {
						name = CSTRING(Disabled);
						value = 0;
					};
					class Setting {
						name = CSTRING(Setting);
						value = 1;
						default = 1;
					};
					class Custom {
						name = CSTRING(Custom);
						value = 2;
					};
					class Both {
						name = CSTRING(Both);
						value = 3;
					};
				};
			};
			class ArsenalBlacklist : Edit {
				displayName = CSTRING(ArsenalBlacklistName);
				property = QGVAR(moduleHub_ArsenalBlacklist);
				typeName = "STRING";
				defaultValue = "''";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CSTRING(moduleHubInfo);
		};
	};

	class GVAR(moduleConstructionVehicle): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleConstructionVehicleName);
		icon = QPATHTOF(data\hammer.paa);
		portrait = QPATHTOF(data\hammer.paa);
		function = QFUNC(moduleConstructionVehicle);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class MaxBudget : Edit {
				displayName = CSTRING(MaxBudgetName);
				tooltip = CSTRING(MaxBudgetInfo);
				property = QGVAR(moduleConstructionVehicle_MaxBudget);
				typeName = "NUMBER";
				defaultValue = 1000;
			};
			class ConstructionInventory : Default {
				displayName = CSTRING(ConstructionInventoryName);
				tooltip = CSTRING(ConstructionInventoryInfo);
				property = QGVAR(moduleConstructionVehicle_ConstructionInventory);
				typeName = "STRING";
				defaultValue = "[
					[""Land_BagFence_Round_F"","""",100,5,{}],
					[""Land_BagFence_Long_F"","""",100,5,{}],
					[""Land_BagBunker_Small_F"","""",1000,15,{}]
				]";
				control = "EditCodeMulti3";
				validate = "expression";
			};
			class InitFnc : Default {
				displayName = CSTRING(InitFncName);
				tooltip = CSTRING(InitFncInfo);
				property = QGVAR(moduleConstructionVehicle_InitFnc);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti3";
				validate = "expression";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CSTRING(moduleConstructionVehicleInfo);
		};
	};

	class GVAR(moduleResupply): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleResupplyName);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa";
		function = QFUNC(moduleResupply);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};

	class GVAR(moduleDeployableResupply): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleDeployableResupplyName);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa";
		function = QFUNC(moduleDeployableResupply);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class MunitionDefaultsOnly : Checkbox {
				displayName = CSTRING(MunitionDefaultsOnlyName);
				tooltip = CSTRING(MunitionDefaultsOnlyInfo);
				property = QGVAR(moduleDeployableResupply_MunitionDefaultsOnly);
				typeName = "BOOL";
				defaultValue = "false";
			};
			class MedicalDefaultsOnly : Checkbox {
				displayName = CSTRING(MedicalDefaultsOnlyName);
				tooltip = CSTRING(MedicalDefaultsOnlyInfo);
				property = QGVAR(moduleDeployableResupply_MedicalDefaultsOnly);
				typeName = "BOOL";
				defaultValue = "true";
			};
			class MagazineCount : Edit {
				displayName = CSTRING(MagazineCountName);
				property = QGVAR(moduleDeployableResupply_MagazineCount);
				typeName = "NUMBER";
				defaultValue = 20;
			};
			class UnderbarrelCount : Edit {
				displayName = CSTRING(UnderbarrelCountName);
				property = QGVAR(moduleDeployableResupply_UnderbarrelCount);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class RocketCount : Edit {
				displayName = CSTRING(RocketCountName);
				property = QGVAR(moduleDeployableResupply_RocketCount);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class ThrowableCount : Edit {
				displayName = CSTRING(ThrowableCountName);
				property = QGVAR(moduleDeployableResupply_ThrowableCount);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class PlaceableCount : Edit {
				displayName = CSTRING(PlaceableCountName);
				property = QGVAR(moduleDeployableResupply_PlaceableCount);
				typeName = "NUMBER";
				defaultValue = 10;
			};
			class MedicalCount : Edit {
				displayName = CSTRING(MedicalCountName);
				property = QGVAR(moduleDeployableResupply_MedicalCount);
				typeName = "NUMBER";
				defaultValue = 20;
			};
			class MagazinesMultiply : Checkbox {
				displayName = CSTRING(MagazinesMultiplyName);
				tooltip = CSTRING(countMultiply);
				property = QGVAR(moduleDeployableResupply_MagazinesMultiply);
				typeName = "BOOL";
				defaultValue = "false";
			};
			class UnderbarrelMultiply : Checkbox {
				displayName = CSTRING(UnderbarrelMultiplyName);
				tooltip = CSTRING(countMultiply);
				property = QGVAR(moduleDeployableResupply_UnderbarrelMultiply);
				typeName = "BOOL";
				defaultValue = "false";
			};
			class RocketMultiply : Checkbox {
				displayName = CSTRING(RocketMultiplyName);
				tooltip = CSTRING(countMultiply);
				property = QGVAR(moduleDeployableResupply_RocketMultiply);
				typeName = "BOOL";
				defaultValue = "false";
			};
			class ThrowableMultiply : Checkbox {
				displayName = CSTRING(ThrowableMultiplyName);
				tooltip = CSTRING(countMultiply);
				property = QGVAR(moduleDeployableResupply_ThrowableMultiply);
				typeName = "BOOL";
				defaultValue = "false";
			};
			class PlaceableMultiply : Checkbox {
				displayName = CSTRING(PlaceableMultiplyName);
				tooltip = CSTRING(countMultiply);
				property = QGVAR(moduleDeployableResupply_PlaceableMultiply);
				typeName = "BOOL";
				defaultValue = "false";
			};
			class MedicalMultiply : Checkbox {
				displayName = CSTRING(MedicalMultiplyName);
				tooltip = CSTRING(countMultiply);
				property = QGVAR(moduleDeployableResupply_MedicalMultiply);
				typeName = "BOOL";
				defaultValue = "false";
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CSTRING(moduleDeployableResupplyInfo);
		};
	};

	class GVAR(moduleSaveCargo): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleSaveCargoName);
		icon = "\A3\3den\data\displays\display3den\toolbar\save_ca.paa";
		portrait = "\A3\3den\data\displays\display3den\toolbar\save_ca.paa";
		function = QFUNC(moduleSaveCargo);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class Preset : Edit {
				displayName = CSTRING(PresetName);
				property = QGVAR(moduleSaveCargo_Preset);
				typeName = "STRING";
				defaultValue = "''";
			};
		};
	};
};
