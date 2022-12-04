#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "";
		units[] = {
			QGVAR(moduleGetClass),
			QGVAR(moduleHALO),
			QGVAR(moduleResetObjects)
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
