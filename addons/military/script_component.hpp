#define COMPONENT military
#include "\z\stx\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
 #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_MILITARY
	#define DEBUG_MODE_FULL
#endif
	#ifdef DEBUG_SETTINGS_MILITARY
	#define DEBUG_SETTINGS DEBUG_SETTINGS_MILITARY
#endif

#include "\z\stx\addons\main\script_macros.hpp"

///////////////////////////////////////////////////////////////////////////////////////////////////

#define ICON_FREE QPATHTOF(data\free.paa)
#define ICON_GARRISON QPATHTOF(data\garrison.paa)
#define ICON_PATROL QPATHTOF(data\patrol.paa)
#define ICON_QRF QPATHTOF(data\qrf.paa)
#define ICON_SENTRY QPATHTOF(data\sentry.paa)
#define ICON_OCCUPY "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\meet_ca.paa"
//#define ICON_OCCUPYMANAGE "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa"
#define ICON_TOGGLECACHING "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\download_ca.paa"
#define ICON_UNASSIGN "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa"
#define ICON_TRASH "\A3\3DEN\Data\cfg3den\history\deleteitems_ca.paa"
#define ICON_INHERIT "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\upload_ca.paa"

#define SMOKE_TYPES [ \
	["SmokeShell","SmokeShellMuzzle"], \
	["SmokeShellBlue","SmokeShellBlueMuzzle"], \
	["SmokeShellGreen","SmokeShellGreenMuzzle"], \
	["SmokeShellYellow","SmokeShellYellowMuzzle"], \
	["SmokeShellRed","SmokeShellRedMuzzle"] \
]

#define SIDE_TARGETS(var1) format ["%1_%2",QGVAR(targets),var1]