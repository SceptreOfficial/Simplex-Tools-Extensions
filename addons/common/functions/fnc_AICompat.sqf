#include "script_component.hpp"

params ["_group"];

// ACEX Headless balance compat
_group setVariable ["acex_headless_blacklist",true,true];

// AI mod compat
_group setVariable ["Vcm_Disable",true,true];
_group setVariable ["lambs_danger_disableGroupAI",true,true];
