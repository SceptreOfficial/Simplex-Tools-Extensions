#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = COMPONENT;
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "";
		units[] = {
			QGVAR(moduleInfiniteSmoke),
			QGVAR(moduleInfiniteChemlight),
			QGVAR(moduleInfiniteFlare),
			QGVAR(moduleInfiniteIR)
		};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {QPVAR(common)};
		VERSION_CONFIG;
	};
};

#include "CfgAmmo.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgVehicles.hpp"
