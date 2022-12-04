#include "script_component.hpp"
#define COMPLETION_RADIUS_VEHICLE 200

params ["_respondingGroups","_side","_regroupPos"];

{
	private _group = _x;
	private _target = _group getVariable QGVAR(target);
	private _targetPos = getPos _target;

	_group setVariable [QGVAR(available),false,true];
	[_group,true] call EFUNC(common,clearWaypoints);
	{_x disableAI "AUTOCOMBAT"} forEach units _group;

	// Mount up
	private _completionRadius = call FUNC(embark);

	// Regroup and attack
	_group setVariable [QGVAR(regroupComplete),false];

	[_group,_regroupPos,20,"UNLOAD","AWARE","GREEN","NORMAL","WEDGE",[format ["(group this) getVariable %1",QGVAR(available)],"
		{
			_x enableAI 'AUTOCOMBAT';
			if (!(_x in _x) && {(assignedVehicleRole _x) # 0 == 'cargo'}) then {
				unassignVehicle _x;
				[_x] orderGetIn false;
			};
		} forEach units group this;
	"],[0,0,0],50] call EFUNC(common,addWaypoint);

	[_group,_targetPos,0,"SAD","AWARE","YELLOW","NORMAL","WEDGE",[
		format ["(group this) getVariable %1",QGVAR(available)],
		format ["[%1,group this,group this] call CBA_fnc_targetEvent;",QGVAR(returnToOrigin)]
	],[0,0,0],10] call EFUNC(common,addWaypoint);

	_group call EFUNC(common,nudge);
} forEach _respondingGroups;

[{
	params ["_respondingGroups","_regroupPos"];
	{(leader _x distance2D _regroupPos) > 150 || ({alive _x} count units _x) != 0} count _respondingGroups == 0
},{
	{_x setVariable [QGVAR(regroupComplete),true]} forEach (_this # 0);
},[_respondingGroups,_regroupPos],120 + round random 30,{
	{_x setVariable [QGVAR(regroupComplete),true]} forEach (_this # 0);
}] call CBA_fnc_waitUntilAndExecute;

DEBUG_1("%1: Regrouping",_respondingGroups);
