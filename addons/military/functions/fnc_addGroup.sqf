#include "script_component.hpp"

params [
	["_group",grpNull,[grpNull]],
	["_assignment","PATROL",[""]],
	["_requestDistance",800,[0]],
	["_responseDistance",800,[0]],
	["_extras",[]],
	["_origin",[]]
];

if (isNull _group) exitWith {
	DEBUG("Null group");
};

_assignment = toUpper _assignment;

// Start clockwork if not runnning on current machine
if (isNil QGVAR(EFID)) then {
	GVAR(cache) = [];
	GVAR(cacheHash) = createHashMap;
	GVAR(list) = [];
	GVAR(EFID) = addMissionEventHandler ["EachFrame",{call FUNC(clockwork)}];
};


// Setup group
_group call EFUNC(common,AICompat);

{
	_x setSkill ["general",1];
	_x setSkill ["commanding",1];
	_x setSkill ["courage",1];
} forEach units _group;

_group allowFleeing 0;

_group setVariable [QGVAR(assignment),_assignment,true];
_group setVariable [QGVAR(requestDistance),_requestDistance,true];
_group setVariable [QGVAR(responseDistance),_responseDistance,true];
_group setVariable [QGVAR(side),side _group,true];
_group setVariable [QGVAR(targetsToReport),[],true];
_group setVariable [QGVAR(target),objNull,true];

if (_origin isEqualTo []) then {
	_group setVariable [QGVAR(origin),[getPosVisual leader _group,getDirVisual leader _group],true];
} else {
	_group setVariable [QGVAR(origin),_origin,true];
};

if (!GVAR(cachingDefault)) then {
	_group setVariable [QGVAR(allowCaching),false,true];
};

switch (_assignment) do {
	case "FREE" : {
		_group setVariable [QGVAR(available),true,true];
	};

	case "GARRISON" : {
		_extras params ["_teleport","_garrisonType"];

		if (_garrisonType in [1,2]) then {
			_group setVariable [QGVAR(available),false,true];
		} else {
			_group setVariable [QGVAR(available),true,true];
		};

		_group setVariable [QGVAR(garrisonType),_garrisonType,true];

		[FUNC(garrison),[_group,_teleport],1] call CBA_fnc_waitAndExecute; // Delay for locality transfer issue
	};

	case "PATROL" : {
		_extras params ["_routeStyle","_routeType","_patrolRadius"];

		_group setVariable [QGVAR(available),true,true];

		_group setVariable [QGVAR(routeStyle),_routeStyle,true];
		_group setVariable [QGVAR(routeType),_routeType,true];
		_group setVariable [QGVAR(patrolRadius),_patrolRadius,true];
		
		_group call FUNC(patrol);
	};

	case "QRF" : {
		_group setVariable [QGVAR(available),true,true];

		if ((_group getVariable QGVAR(origin)) # 0 distance leader _group > 20) then {
			_group call FUNC(returnToOrigin);
		} else {
			[FUNC(mountQRF),_group,1] call CBA_fnc_waitAndExecute; // Delay for locality transfer issue
		};
	};

	case "SENTRY" : {
		_group setVariable [QGVAR(available),true,true];

		if ((_group getVariable QGVAR(origin)) # 0 distance leader _group > 20) then {
			_group call FUNC(returnToOrigin);
		};
	};
};

DEBUG_2("%1: %2",_assignment,_group);

[QGVAR(groupAdded),[_group,_assignment]] call CBA_fnc_globalEvent;
