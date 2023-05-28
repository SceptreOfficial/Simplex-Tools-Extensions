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

	class GVAR(moduleStrafe): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleStrafeName);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\target_ca.paa";
		function = QFUNC(moduleStrafe);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
};
