#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = QUOTE(COMPONENT);
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "";
		units[] = {
			QGVAR(moduleCanteenTap),
			QGVAR(moduleConstructionVehicle),
			QGVAR(moduleHub),
			QGVAR(moduleResupply),
			QGVAR(moduleDeployableResupply),
			QGVAR(moduleSaveCargo)
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
#include "gui.hpp"
