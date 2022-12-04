#include "script_component.hpp"

params [
	["_object",objNull,[objNull]],
	["_whitelistUsage",0,[0]],
	["_whitelist",[],[[]]],
	["_blacklistUsage",1,[0]],
	["_blacklist",[],[[]]]
];

switch _whitelistUsage do {
	case 0 : {_whitelist = true};
	case 1 : {_whitelist = GVAR(arsenalWhitelist)};
	case 3 : {_whitelist = GVAR(arsenalWhitelist) + _whitelist};
};

[_object,_whitelist,true] call ace_arsenal_fnc_addVirtualItems;

switch _blacklistUsage do {
	case 0 : {_blacklist = []};
	case 1 : {_blacklist = GVAR(arsenalBlacklist)};
	case 3 : {_blacklist = GVAR(arsenalBlacklist + _blacklist)};
};

[_object,_blacklist,true] call ace_arsenal_fnc_removeVirtualItems;

private _jipID = [QGVAR(arsenalInit),[_object]] call CBA_fnc_globalEventJIP;
[_jipID,_object] call CBA_fnc_removeGlobalEventJIP;
