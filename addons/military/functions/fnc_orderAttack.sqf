#include "..\script_component.hpp"

params ["_respondingGroups"];

{
	private _group = _x;
	private _target = _group getVariable QGVAR(target);
	private _targetPos = getPos _target;

	_group setVariable [QGVAR(available),false,true];
	[_group,true] call EFUNC(common,clearWaypoints);

	// Mount up
	private _completionRadius = call FUNC(embark);

	// Attack
	if ((random 1 < 0.5 && _completionRadius < 200) || leader _group distance2D _targetPos < 400) then {
		[_group,_targetPos,0,"SAD","AWARE","YELLOW","NORMAL","WEDGE",[
			format ["(group this) getVariable %1",QGVAR(available)],
			format ["[%1,group this,group this] call CBA_fnc_targetEvent;",QGVAR(returnToOrigin)]
		],[0,0,0],_completionRadius] call EFUNC(common,addWaypoint);
		
		_group call EFUNC(common,nudge);
	} else {
		private _leader = leader _group;
		private _flankPos = _target getPos [200,(_target getDir _leader) + selectRandom [-90,90]];

		[_group,_flankPos,0,"MOVE","SAFE","YELLOW","FULL","WEDGE",["true",""],[0,0,0],_completionRadius] call EFUNC(common,addWaypoint);

		[_group,_flankPos,0,"MOVE","SAFE","YELLOW","FULL","WEDGE",["true","
			{
				if (!(_x in _x) && {(assignedVehicleRole _x) # 0 == 'cargo'}) then {
					unassignVehicle _x;
					[_x] orderGetIn false;
				};
			} forEach units group this;
		"],[0,0,0],_completionRadius] call EFUNC(common,addWaypoint);
		
		[_group,_targetPos,0,"SAD","AWARE","YELLOW","NORMAL","WEDGE",[
			format ["(group this) getVariable %1",QGVAR(available)],
			format ["[%1,group this,group this] call CBA_fnc_targetEvent;",QGVAR(returnToOrigin)]
		],[0,0,0],10] call EFUNC(common,addWaypoint);
		
		_group call EFUNC(common,nudge);
	};
} forEach _respondingGroups;

DEBUG_1("%1: Attacking",_respondingGroups);
