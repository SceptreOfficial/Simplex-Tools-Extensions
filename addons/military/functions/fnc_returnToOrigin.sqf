#include "script_component.hpp"

params ["_group"];

private _assignment = _group getVariable QGVAR(assignment);

if (isNil "_assignment") exitWith {};

(_group getVariable QGVAR(origin)) params ["_originPos","_originDir"];

_group call EFUNC(common,clearWaypoints);

switch _assignment do {
	case "FREE" : {
		{([_group] + _x) call EFUNC(common,addWaypoint)} forEach (_group getVariable QGVAR(waypointsCache));
	};
	case "GARRISON" : {
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true",
			"(group this) call " + QFUNC(garrison)
		],[0,0,0],15] call EFUNC(common,addWaypoint);
	};
	case "PATROL" : {
		switch (_group getVariable QGVAR(routeType)) do {
			case 0 : {_group call FUNC(patrol)};
			case 1 : {{([_group] + _x) call EFUNC(common,addWaypoint)} forEach (_group getVariable QGVAR(waypointsCache))};
		};
	};
	case "QRF" : {
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true",
			format ["(group this) setFormDir (((group this) getVariable %1) # 1)",QGVAR(origin)]
		],[0,0,0],0] call EFUNC(common,addWaypoint);

		// Have air units land and turn off engines - then set status to open
		if (({vehicle _x isKindOf "Air"} count units _group) != 0) then {
			private _landWP = [_group,_originPos,0,"SCRIPTED","AWARE","GREEN","NORMAL","WEDGE",["true",""],[0,0,0],50] call EFUNC(common,addWaypoint);
			_landWP setWaypointScript "A3\functions_f\waypoints\fn_wpLand.sqf";
			
			[_group,_originPos,0,"MOVE","","","","",["true",format ["
				[{
					params ['_group'];

					if (_group getVariable %1) then {
						{
							if (vehicle _x isKindOf 'Air' && {driver vehicle _x in units _group}) then {
								vehicle _x engineOn false;
							};
						} forEach (units _group);

						_group call %2;
					};
				},group this,8] call CBA_fnc_waitAndExecute;
			",QGVAR(available),QFUNC(mountQRF)]],[0,0,0],250] call EFUNC(common,addWaypoint);
		};
	};
	case "SENTRY" : {
		// Try to get units facing the same way they were originally
		[_group,_originPos getPos [12,_originDir - 180],0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true",
			format ["(group this) setFormDir (((group this) getVariable %1) # 1)",QGVAR(origin)]
		],[0,0,0],0] call EFUNC(common,addWaypoint);
		[_group,_originPos,0,"MOVE","AWARE","GREEN","NORMAL","WEDGE",["true",
			format ["(group this) setFormDir (((group this) getVariable %1) # 1)",QGVAR(origin)]
		],[0,0,0],0] call EFUNC(common,addWaypoint);
	};
};
