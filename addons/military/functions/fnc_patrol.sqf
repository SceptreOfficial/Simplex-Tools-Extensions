#include "script_component.hpp"

params ["_group"];

private _originPos = (_group getVariable QGVAR(origin)) # 0;
private _patrolRadius = _group getVariable QGVAR(patrolRadius);

switch (_group getVariable QGVAR(routeType)) do {
	case 0 : {
		private _vehicle = vehicle (leader _group);
		private "_position";
		
		for "_i" from 0 to 99 do {
			_position = _originPos getPos [_patrolRadius * (1 - abs random [-1,0,1]),random 360]; // inverted normal distribution, random radius
			//_position = _originPos getPos [_patrolRadius * sqrt (1 - abs random [-1,0,1]), random 360]; // inverted normal distribution, random area
			if (!surfaceIsWater _position) exitWith {};
		};

		{deleteWaypoint [_group,0]} forEach (waypoints _group);

		[_group,_position,0,"MOVE","SAFE","GREEN","LIMITED",["FILE","STAG COLUMN"] select (random 1 < 0.5),["true",
			"(group this) call " + QFUNC(patrol)
		],[4,6,8],15] call EFUNC(common,addWaypoint);

		_group call EFUNC(common,nudge);
	};
	case 1 : { // For initial setup only
		switch (_group getVariable QGVAR(routeStyle)) do {
			case 0 : { // Clockwise Circle
				private _formation = ["FILE","STAG COLUMN"] select (random 1 < 0.5);
				private _dir = 60;
				
				for "_i" from 0 to 6 do {
					private _position = _originPos getPos [_patrolRadius,_dir];
					_dir = _dir + 60;
					
					if (_i != 6) then {
						[_group,_position,0,"MOVE","SAFE","GREEN","LIMITED",_formation,["true",""],[4,6,8],10] call EFUNC(common,addWaypoint);
						
						if (_i isEqualTo 0) then {
							_group call EFUNC(common,nudge);
						};
					} else {
						[_group,_position,0,"CYCLE","SAFE","GREEN","LIMITED",_formation,["true",""],[4,6,8],10] call EFUNC(common,addWaypoint);
					};
				};
			};
			case 1 : { // Counter-Clockwise Circle
				private _formation = ["FILE","STAG COLUMN"] select (random 1 < 0.5);
				private _dir = 300;
				
				for "_i" from 0 to 6 do {
					private _position = _originPos getPos [_patrolRadius,_dir];
					_dir = _dir - 60;
					
					if (_i != 6) then {
						[_group,_position,0,"MOVE","SAFE","GREEN","LIMITED",_formation,["true",""],[4,6,8],10] call EFUNC(common,addWaypoint);
						
						if (_i isEqualTo 0) then {
							_group call EFUNC(common,nudge);
						};
					} else {
						[_group,_position,0,"CYCLE","SAFE","GREEN","LIMITED",_formation,["true",""],[4,6,8],10] call EFUNC(common,addWaypoint);
					};
				};
			};
		};

		_group setVariable [QEGVAR(common,waypointsCache),_group call EFUNC(common,waypointData),true];
	};
};

