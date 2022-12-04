#include "script_component.hpp"

params [["_target",grpNull,[grpNull,objNull]]];

if (_target isEqualType objNull) then {_target = group _target};

(waypoints _target) apply {[
	waypointPosition _x,
	0,
	waypointType _x,
	waypointBehaviour _x,
	waypointCombatMode _x,
	waypointSpeed _x,
	waypointFormation _x,
	waypointStatements _x,
	waypointTimeout _x,
	waypointCompletionRadius _x
]}
