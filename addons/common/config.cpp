#include "script_component.hpp"

class CfgPatches {
	class ADDON {
		name = QUOTE(COMPONENT);
		author = "Simplex Team";
		authors[] = {"Simplex Team"};
		url = "";
		units[] = {};
		weapons[] = {};
		requiredVersion = REQUIRED_VERSION;
		requiredAddons[] = {QPVAR(main),QPVAR(sdf)};
		VERSION_CONFIG;
	};
};

#include "CfgEventHandlers.hpp"
#include "CfgMoves.hpp"
#include "CfgSounds.hpp"
