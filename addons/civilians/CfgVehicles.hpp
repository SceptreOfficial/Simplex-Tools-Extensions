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

	class GVAR(Module_Base): Module_F {
		category = QGVAR(modules);
		author = "Simplex Team";
		displayName = "";
		icon = "";
		portrait = "";
		side = 7;
		scope = 1;
		scopeCurator = 1;
		curatorCanAttach = 1;
		function = "";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 0;
	};

	class GVAR(ModuleAddPanic) : Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(ModuleAddPanicName);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\danger_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\danger_ca.paa";
		function = QFUNC(moduleAddPanic);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};

	class GVAR(ModuleBlacklistArea): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(ModuleBlacklistAreaName);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
		function = QFUNC(ModuleBlacklistArea);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;
		canSetArea = 1;
		canSetAreaHeight = 0;
		canSetAreaShape = 1;

		class AttributeValues {
			isRectangle = 1;
			size3[] = {50,50,-1};
		};

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};
		
		class ModuleDescription: ModuleDescription {
			description = CSTRING(ModuleBlacklistAreaInfo);
		};
	};

	class GVAR(ModulePopulate): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(ModulePopulateName);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa";
		function = QFUNC(ModulePopulate);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;
		canSetArea = 1;
		canSetAreaHeight = 0;
		canSetAreaShape = 1;

		class AttributeValues {
			isRectangle = 1;
			size3[] = {50,50,-1};
		};

		class Attributes: AttributesBase {
			class UnitClasses : Edit {
				displayName = CSTRING(SettingName_unitClassesStr);
				property = QGVAR(ModulePopulate_UnitClasses);
				typeName = "STRING";
				defaultValue = "[""C_Man_casual_2_F"",""C_Man_casual_3_F"",""C_man_w_worker_F"",""C_man_polo_2_F"",""C_Man_casual_1_F"",""C_man_polo_4_F""]";
			};
			class VehicleClasses : Edit {
				displayName = CSTRING(SettingName_vehClassesStr);
				property = QGVAR(ModulePopulate_VehicleClasses);
				typeName = "STRING";
				defaultValue = "[""C_Truck_02_fuel_F"",""C_Truck_02_box_F"",""C_Truck_02_covered_F"",""C_Offroad_01_repair_F"",""C_Van_01_box_F"",""C_Offroad_01_F"",""C_Offroad_01_covered_F"",""C_SUV_01_F""]";
			};
			class Pedestrians : Edit {
				displayName = CSTRING(SettingName_pedestrianCount);
				property = QGVAR(ModulePopulate_Pedestrians);
				typeName = "STRING";
				defaultValue = "0";
			};
			class Driving : Edit {
				displayName = CSTRING(SettingName_driverCount);
				property = QGVAR(ModulePopulate_Driving);
				typeName = "STRING";
				defaultValue = "0";
			};
			class Parked : Edit {
				displayName = CSTRING(SettingName_parkedCount);
				property = QGVAR(ModulePopulate_Parked);
				typeName = "STRING";
				defaultValue = "0";
			};

			class ModuleDescription: ModuleDescription {};
		};
		
		class ModuleDescription: ModuleDescription {
			description = CSTRING(ModulePopulateInfo);
		};
	};

	class GVAR(Module_ToggleAircraft) : GVAR(Module_Base) {
		displayName = CSTRING(Module_ToggleAircraft);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\intel_ca.paa";
		function = QFUNC(moduleToggleAircraft);
		scopeCurator = 2;
	};

	class GVAR(Module_ToggleCivilians) : GVAR(Module_Base) {
		displayName = CSTRING(Module_ToggleCivilians);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\intel_ca.paa";
		function = QFUNC(moduleToggleCivilians);
		scopeCurator = 2;
	};
};
