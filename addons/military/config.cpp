#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "";
		units[] = {
			QGVAR(Module_AssignFree),
			QGVAR(Module_AssignGarrison),
			QGVAR(Module_AssignPatrol),
			QGVAR(Module_AssignQRF),
			QGVAR(Module_AssignSentry),
			QGVAR(Module_Occupy),
			//QGVAR(Module_OccupyManage),
			QGVAR(Module_Unassign)
		};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {QPVAR(common)};
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
