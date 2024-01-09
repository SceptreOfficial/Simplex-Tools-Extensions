#include "script_component.hpp"

params ["_group"];

// ACEX Headless balance compat
_group setVariable ["acex_headless_blacklist",true,true];

// ALIVE headless compat
{_x setVariable ["alive_ignore_hc",true,true]} forEach units _group;

// ZHC headless compat
_group setVariable ["zhc_offload_blacklisted",true,true];

// AI mod compat
_group setVariable ["Vcm_Disable",true,true];
_group setVariable ["lambs_danger_disableGroupAI",true,true];
