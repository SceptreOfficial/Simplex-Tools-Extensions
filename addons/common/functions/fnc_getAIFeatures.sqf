#include "..\script_component.hpp"

params ["_unit"];

private _hash = createHashMap;

{_hash set [_x,_unit checkAIFeature _x]} forEach [
	"AIMINGERROR",
	"ANIM",
	"AUTOCOMBAT",
	"AUTOTARGET",
	"CHECKVISIBLE",
	"COVER",
	"FSM",
	"LIGHTS",
	"MINEDETECTION",
	"MOVE",
	"NVG",
	"PATH",
	"RADIOPROTOCOL",
	"SUPPRESSION",
	"TARGET",
	"TEAMSWITCH",
	"WEAPONAIM"
	//"FIREWEAPON"
];

_hash
