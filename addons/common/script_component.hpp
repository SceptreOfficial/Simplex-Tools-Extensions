#define COMPONENT common
#include "\z\stx\addons\main\script_mod.hpp"

//#define DEBUG_MODE_FULL
//#define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_COMMON
	#define DEBUG_MODE_FULL
#endif
	#ifdef DEBUG_SETTINGS_COMMON
	#define DEBUG_SETTINGS DEBUG_SETTINGS_COMMON
#endif

#include "\z\stx\addons\main\script_macros.hpp"

#define HELO_PILOT_DISTANCE 650
#define VTOL_PILOT_DISTANCE 800
