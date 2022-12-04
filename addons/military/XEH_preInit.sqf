#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "cba_settings.sqf"

///////////////////////////////////////////////////////////////////////////////////////////////////
// Occupation

GVAR(occupationPresets) = profileNamespace getVariable [QGVAR(occupationPresets),
	#include "default_occupy_presets.sqf"
];

[QGVAR(occupationETA),{
	params ["_queueCount"];

	if (!isNil QGVAR(ETAPFHID)) then {
		[GVAR(ETAPFHID)] call CBA_fnc_removePerFrameHandler;
	};

	GVAR(ETAPFHID) = [{
		params ["_queueCount","_PFHID"];

		private _ETA = ceil (_queueCount * 0.3);

		if (_ETA > 0) then {
			hintSilent ("Occupation completion ETA: " + str _ETA);
		} else {
			[_PFHID] call CBA_fnc_removePerFrameHandler;
			GVAR(ETAPFHID) = nil;
			hintSilent "";
		};

		_x set [4,_queueCount - 1];
	},0.3,_queueCount] call CBA_fnc_addPerFrameHandler;
}] call CBA_fnc_addEventHandler;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Handle waypoint deletion

["ModuleCurator_F","init",{
	[_this # 0,"CuratorWaypointDeleted",{
		params ["_curator","_group"];

		if (isNil {_group getVariable QGVAR(assignment)}) exitWith {};

		if ((_group getVariable QGVAR(assignment)) == "FREE" && _group getVariable QGVAR(available)) exitWith {};

		if ((_group getVariable [QGVAR(garrisonType),0]) in [1,2]) then {
			_group setVariable [QGVAR(available),false,true];
		} else {
			_group setVariable [QGVAR(available),true,true];
		};

		[QGVAR(returnToOrigin),_group,_group] call CBA_fnc_targetEvent;
		
		[{
			if ({alive _x} count units _this isEqualTo 0) exitWith {};
			CHAT_WARNING_1("%1: Waypoint deleted. Resetting group.",_this);
		},_group] call CBA_fnc_execNextFrame;
	}] call CBA_fnc_addBISEventHandler;
}] call CBA_fnc_addClassEventHandler;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Core functionality

[QGVAR(addGroups),{
	params ["_groups","_assignment","_requestDistance","_responseDistance","_extras"];
	{[_x,_assignment,_requestDistance,_responseDistance,_extras] call FUNC(addGroup)} forEach _groups;
}] call CBA_fnc_addEventHandler;

[QGVAR(returnToOrigin),FUNC(returnToOrigin)] call CBA_fnc_addEventHandler;

[QGVAR(checkUnknownTargets),{
	params ["_group","_targets"];
	_group setVariable [QGVAR(unknownTargets),_targets select {_group knowsAbout _x < 0.5},true];
}] call CBA_fnc_addEventHandler;

if (isServer) then {
	[QGVAR(assignmentDialogConfirmed),FUNC(assignmentDialogConfirm)] call CBA_fnc_addEventHandler;

	[QGVAR(report),{
		params ["_side","_targets"];
		private _sideTargets = missionNamespace getVariable [SIDE_TARGETS(_side),[]];
		_sideTargets append _targets;
		missionNamespace setVariable [SIDE_TARGETS(_side),_sideTargets,true];
		DEBUG_2("%1: Reported targets: %2",_side,_targets);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(engagementStarted),{
		params ["_side","_respondingGroups","_targets"];
		[FUNC(trackEngagement),[_side,_respondingGroups,_targets],60] call CBA_fnc_waitAndExecute;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(cleanupTargets),{
		params ["_side","_targets"];
		private _sideTargets = missionNamespace getVariable [SIDE_TARGETS(_side),[]];
		missionNamespace setVariable [SIDE_TARGETS(_side),_sideTargets - _targets,true];
		DEBUG_2("%1: Targets dismissed: %2",_side,_targets);
	}] call CBA_fnc_addEventHandler;

	if (isNil QGVAR(EFID)) then {
		GVAR(cache) = [];
		GVAR(cacheHash) = createHashMap;
		GVAR(list) = [];
		GVAR(EFID) = addMissionEventHandler ["EachFrame",{call FUNC(clockwork)}];
	};
};

///////////////////////////////////////////////////////////////////////////////////////////////////

ADDON = true;
