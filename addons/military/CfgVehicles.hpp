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

	class GVAR(Module_AssignFree) : GVAR(Module_Base) {
		displayName = CSTRING(Module_AssignFree);
		icon = ICON_FREE;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		GVAR(assignment) = "FREE";
	};

	class GVAR(Module_AssignGarrison) : GVAR(Module_Base) {
		displayName = CSTRING(Module_AssignGarrison);
		icon = ICON_GARRISON;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		GVAR(assignment) = "GARRISON";
	};

	class GVAR(Module_AssignPatrol) : GVAR(Module_Base) {
		displayName = CSTRING(Module_AssignPatrol);
		icon = ICON_PATROL;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		GVAR(assignment) = "PATROL";
	};

	class GVAR(Module_AssignQRF) : GVAR(Module_Base) {
		displayName = CSTRING(Module_AssignQRF);
		icon = ICON_QRF;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		GVAR(assignment) = "QRF";
	};

	class GVAR(Module_AssignSentry) : GVAR(Module_Base) {
		displayName = CSTRING(Module_AssignSentry);
		icon = ICON_SENTRY;
		function = QFUNC(moduleAssign);
		scopeCurator = 2;
		GVAR(assignment) = "SENTRY";
	};

	class GVAR(Module_Occupy) : GVAR(Module_Base) {
		displayName = CSTRING(Module_Occupy);
		icon = ICON_OCCUPY;
		function = QFUNC(moduleOccupy);
		scopeCurator = 2;
	};
	
	//class GVAR(Module_OccupyManage) : GVAR(Module_Base) {
	//	displayName = "Occupy/Manage";
	//	icon = ICON_OCCUPYMANAGE;
	//	function = QFUNC(moduleOccupyManage);
	//	scopeCurator = 2;
	//};

	class GVAR(Module_ToggleCaching) : GVAR(Module_Base) {
		displayName = CSTRING(Module_ToggleCaching);
		icon = ICON_TOGGLECACHING;
		function = QFUNC(moduleToggleCaching);
		scopeCurator = 2;
	};

	class GVAR(Module_Unassign) : GVAR(Module_Base) {
		displayName = CSTRING(Module_Unassign);
		icon = ICON_UNASSIGN;
		function = QFUNC(moduleUnassign);
		scopeCurator = 2;
	};
};
