#include "script_component.hpp"

params ["_dialogResults","_args"];
_args params ["_groups","_assignment"];
reverse _dialogResults;
_dialogResults params ["_localitySelection","_responseDistance","_requestDistance"];

private _extras = switch (_assignment) do {
	case "GARRISON" : {[_dialogResults # 3,_dialogResults # 4]};
	case "PATROL" : {[_dialogResults # 3,_dialogResults # 4,parseNumber (_dialogResults # 5)]};
	default {[]};
};

if (_localitySelection > (count EGVAR(common,headlessClients) + 1)) exitWith {
	LOG_ERROR("Headless client(s) disconnected during selection. Cancelling assignment.");
};

// Server transfer
if (_localitySelection == 1) exitWith {
	[
		[0,2] select isMultiplayer,
		_groups,
		[_groups,_assignment,_requestDistance,_responseDistance,_extras],
		{[QGVAR(addGroups),_this] call CBA_fnc_localEvent}
	] call EFUNC(common,transferGroups);
};

// HC transfer
if (_localitySelection > 1) exitWith {
	[
		owner (EGVAR(common,headlessClients) # (_localitySelection - 2)),
		_groups,
		[_groups,_assignment,_requestDistance,_responseDistance,_extras],
		{[QGVAR(addGroups),_this] call CBA_fnc_localEvent}
	] call EFUNC(common,transferGroups);
};

// Keep current localities
private _ownersAndGroups = []; // [ownerID,[groups]]

{
	private _owner = groupOwner _x;
	private _index = (_ownersAndGroups apply {_x # 0}) find _owner;
	
	if (_index != -1) then {
		((_ownersAndGroups select _index) select 1) pushBack _x;
	} else {
		_ownersAndGroups pushBack [_owner,[_x]];
	};
} forEach _groups;

{[QGVAR(addGroups),[_x # 1,_assignment,_requestDistance,_responseDistance,_extras],_x # 0] call CBA_fnc_ownerEvent} forEach _ownersAndGroups;
