#include "script_component.hpp"

params ["_group",["_immediate",false]];

if (_immediate) then {
	private _currentWP = [_group,currentWaypoint _group];
	_currentWP setWaypointPosition [waypointPosition _currentWP,20];
	units _group doFollow leader _group;

	DEBUG_1("%1: Nudged",_group);
} else {
	[{
		if ({alive _x} count units _this isEqualTo 0) exitWith {};

		[{
			params ["_group","_oldPos"];

			if ({alive _x} count units _group isEqualTo 0) exitWith {};

			if (_oldPos distance getPos leader _group < 20 && count (waypoints _group) != 0) then {
				private _currentWP = [_group,currentWaypoint _group];
				_currentWP setWaypointPosition [waypointPosition _currentWP,20];
				units _group doFollow leader _group;
				
				DEBUG_1("%1: Nudged",_group);
			};
		},[_this,getPosATL leader _this],25] call CBA_fnc_waitAndExecute;
	},_group,15] call CBA_fnc_waitAndExecute;	
};
