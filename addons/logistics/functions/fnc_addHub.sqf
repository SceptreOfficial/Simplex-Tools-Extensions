#include "script_component.hpp"

[QEGVAR(common,execute),[_this,{
	params [
		["_hub",objNull,[objNull]],
		["_editInventories",true,[false]],
		["_boxSpawn",true,[false]],
		["_canteenTap",true,[false]],
		["_constructionResupply",true,[false]],
		["_arsenal",true,[false]],
		["_arsenalWhitelistUsage",0],
		["_arsenalWhitelist",[],[[]]],
		["_arsenalBlacklistUsage",1],
		["_arsenalBlacklist",[],[[]]]
	];

	if (isNull _hub) exitWith {};

	if (isNil QGVAR(hubs)) then {
		GVAR(hubs) = [];
	};

	if (_hub in GVAR(hubs)) exitWith {};

	GVAR(hubs) pushBack _hub;
	publicVariable QGVAR(hubs);

	_hub setVariable [QGVAR(hub),true,true];
	_hub setVariable [QGVAR(hubEditInventories),_editInventories,true];
	_hub setVariable [QGVAR(hubBoxSpawn),_boxSpawn,true];
	_hub setVariable [QGVAR(hubConstructionResupply),_constructionResupply,true];

	if (_canteenTap) then {
		_hub call FUNC(addCanteenTap);
	};

	if (_arsenal) then {
		if (_arsenalWhitelistUsage isEqualType "") then {_arsenalWhitelistUsage = 0};
		if (_arsenalBlacklistUsage isEqualType "") then {_arsenalBlacklistUsage = 1};
		[_hub,_arsenalWhitelistUsage,_arsenalWhitelist,_arsenalBlacklistUsage,_arsenalBlacklist] call EFUNC(common,addArsenal);
	};

	private _JIPID = [QGVAR(hubCreated),_hub] call CBA_fnc_globalEventJIP;
	[_JIPID,_hub] call CBA_fnc_removeGlobalEventJIP;
	_hub setVariable [QGVAR(hubJIPID),_JIPID,true];
}]] call CBA_fnc_serverEvent;
