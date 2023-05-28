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
			size3[] = {25,25,-1};
		};

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};
		
		class ModuleDescription: ModuleDescription {
			description = CSTRING(ModuleBlacklistAreaInfo);
		};
	};

	class GVAR(Module_Populate) : GVAR(Module_Base) {
		displayName = CSTRING(Module_Populate);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa";
		function = QFUNC(modulePopulate);
		scopeCurator = 2;
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
