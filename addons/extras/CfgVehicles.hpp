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

	class GVAR(moduleGetClass): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleGetClassName);
		icon = "\a3\Modules_F\Data\iconTaskSetDescription_ca.paa";
		portrait = "\a3\Modules_F\Data\iconTaskSetDescription_ca.paa";
		function = QFUNC(moduleGetClass);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};

	class GVAR(moduleResetObjects): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleResetObjectsName);
		icon = QPATHTOF(data\reset.paa);
		portrait = QPATHTOF(data\reset.paa);
		function = QFUNC(moduleResetObjects);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};

	class GVAR(moduleHALO): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleHALOName);
		icon = QPATHTOF(data\halo.paa);
		portrait = QPATHTOF(data\halo.paa);
		function = QFUNC(moduleHALO);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
};
