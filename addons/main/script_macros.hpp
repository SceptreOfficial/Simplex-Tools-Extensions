#include "\x\cba\addons\main\script_macros_common.hpp"
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#ifdef DISABLE_COMPILE_CACHE
	#undef PREP
	#define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
	#undef PREP
	#define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

///////////////////////////////////////////////////////////////////////////////////////////////////

// Prefix Variables
#define PVAR(VAR) DOUBLES(PREFIX,VAR)
#define QPVAR(VAR) QUOTE(PVAR(VAR))
#define QQPVAR(VAR) QUOTE(QPVAR(VAR))
#define OPTION(VAR) PVAR(option)##VAR
#define QOPTION(VAR) QUOTE(OPTION(VAR))

// Logging
#define LOG_PREFIX QUOTE(ADDON) + ": " + ((__FILE__ regexFind ["[a-z_]+\.sqf"]) select 0 select 0 select 0 regexReplace ["\.sqf",""]) + ": "
#define LOG_MESSAGE(MSG) (LOG_PREFIX + MSG) call EFUNC(common,log)

#define LOG_ERROR(MSG) 							LOG_MESSAGE("Error: " + MSG)
#define LOG_ERROR_1(MSG,N1) 					LOG_ERROR(FORMAT_1(MSG,N1))
#define LOG_ERROR_2(MSG,N1,N2) 					LOG_ERROR(FORMAT_2(MSG,N1,N2))
#define LOG_ERROR_3(MSG,N1,N2,N3) 				LOG_ERROR(FORMAT_3(MSG,N1,N2,N3))
#define LOG_ERROR_4(MSG,N1,N2,N3,N4) 			LOG_ERROR(FORMAT_4(MSG,N1,N2,N3,N4))
#define LOG_ERROR_5(MSG,N1,N2,N3,N4,N5) 		LOG_ERROR(FORMAT_5(MSG,N1,N2,N3,N4,N5))

#define LOG_WARNING(MSG) 						LOG_MESSAGE("Warning: " + MSG)
#define LOG_WARNING_1(MSG,N1) 					LOG_WARNING(FORMAT_1(MSG,N1))
#define LOG_WARNING_2(MSG,N1,N2) 				LOG_WARNING(FORMAT_2(MSG,N1,N2))
#define LOG_WARNING_3(MSG,N1,N2,N3) 			LOG_WARNING(FORMAT_3(MSG,N1,N2,N3))
#define LOG_WARNING_4(MSG,N1,N2,N3,N4) 			LOG_WARNING(FORMAT_4(MSG,N1,N2,N3,N4))
#define LOG_WARNING_5(MSG,N1,N2,N3,N4,N5) 		LOG_WARNING(FORMAT_5(MSG,N1,N2,N3,N4,N5))

#define DEBUG(MSG) 								if (OPTION(debug)) then {LOG_MESSAGE(MSG)}
#define DEBUG_1(MSG,A1) 						DEBUG(FORMAT_1(MSG,A1))
#define DEBUG_2(MSG,ARG1,ARG2) 					DEBUG(FORMAT_2(MSG,ARG1,ARG2))
#define DEBUG_3(MSG,ARG1,ARG2,ARG3) 			DEBUG(FORMAT_3(MSG,ARG1,ARG2,ARG3))
#define DEBUG_4(MSG,ARG1,ARG2,ARG3,ARG4) 		DEBUG(FORMAT_4(MSG,ARG1,ARG2,ARG3,ARG4))
#define DEBUG_5(MSG,ARG1,ARG2,ARG3,ARG4,ARG5) 	DEBUG(FORMAT_5(MSG,ARG1,ARG2,ARG3,ARG4,ARG5))

// Notifications
#define ZEUS_MESSAGE(MSG) [objNull,MSG] call BIS_fnc_showCuratorFeedbackMessage
#define ZEUS_ERROR(MSG) ZEUS_MESSAGE(MSG); playSound QPVAR(failure)

// Command macros
#define PRIMARY_CREW(VEH) (crew VEH arrayIntersect units group VEH)

// Misc constants
#define GRAVITY 9.8066
#define HELO_PILOT_DISTANCE 650
#define VTOL_PILOT_DISTANCE 1300

// Module macros
#define LNAME(V1) QUOTE(TRIPLES(STR,ADDON,DOUBLES(V1,name)))
#define LINFO(V1) QUOTE(TRIPLES(STR,ADDON,DOUBLES(V1,info)))
#define ELNAME(V1,V2) QUOTE(TRIPLES(STR,DOUBLES(PREFIX,V1),DOUBLES(V2,name)))
#define ELINFO(V1,V2) QUOTE(TRIPLES(STR,DOUBLES(PREFIX,V1),DOUBLES(V2,info)))
#define CNAME(V1) QUOTE(TRIPLES($STR,ADDON,DOUBLES(V1,name)))
#define CINFO(V1) QUOTE(TRIPLES($STR,ADDON,DOUBLES(V1,info)))
#define ECNAME(V1,V2) QUOTE(TRIPLES($STR,DOUBLES(PREFIX,V1),DOUBLES(V2,name)))
#define ECINFO(V1,V2) QUOTE(TRIPLES($STR,DOUBLES(PREFIX,V1),DOUBLES(V2,info)))
#define DESC(V1) [LNAME(V1),LINFO(V1)]
#define EDESC(V1,V2) [ELNAME(V1,V2),ELINFO(V1,V2)]
#define ATTRIBUTE(V1) displayName = CNAME(V1); tooltip = CINFO(V1); property = QGVAR(V1)
#define EATTRIBUTE(V1,V2) displayName = ECNAME(V1,V2); tooltip = ECINFO(V1,V2); property = QGVAR(V2)
