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

	class GVAR(moduleLand): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleLandName);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\land_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\land_ca.paa";
		function = QFUNC(moduleLand);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};

	class GVAR(moduleHover): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleHoverName);
		icon = "\a3\3DEN\Data\cfgwrapperui\cursors\3denplacewaypointattach_ca.paa";
		portrait = "\a3\3DEN\Data\cfgwrapperui\cursors\3denplacewaypointattach_ca.paa";
		function = QFUNC(moduleHover);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};

	class GVAR(moduleHelocast): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleHelocastName);
		icon = QPATHTOF(data\helocast.paa);
		portrait = QPATHTOF(data\helocast.paa);
		function = QFUNC(moduleHelocast);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};

	class GVAR(moduleSlingload): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleSlingloadName);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\container_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\container_ca.paa";
		function = QFUNC(moduleSlingload);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};

	class GVAR(moduleRelease): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleReleaseName);
		icon = QPATHTOF(data\release.paa);
		portrait = QPATHTOF(data\release.paa);
		function = QFUNC(moduleRelease);
		isGlobal = 1;
		scope = 1;
		scopeCurator = 2;
		curatorCanAttach = 1;
	};
};
