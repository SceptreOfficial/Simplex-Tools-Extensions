class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class ModuleDescription;
	};

	class GVAR(Module_Base): Module_F {
		category = QGVAR(Modules);
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

	class GVAR(Module_AddPanic) : GVAR(Module_Base) {
		displayName = CSTRING(Module_AddPanic);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\danger_ca.paa";
		function = QFUNC(moduleAddPanic);
		scopeCurator = 2;
	};

	class GVAR(Module_BlacklistArea) : GVAR(Module_Base) {
		displayName = CSTRING(Module_BlacklistArea);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
		function = QFUNC(moduleBlacklistArea);
		scopeCurator = 2;
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
