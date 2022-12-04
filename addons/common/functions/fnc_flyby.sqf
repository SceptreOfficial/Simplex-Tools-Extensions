#include "script_component.hpp"

params [
	["_pos",[0,0,0],[[]],3],
	["_dir",0,[0]],
	["_distance",4000,[0]],
	["_height",500,[0]],
	["_aircraftClass","",[""]],
	["_offset",0,[0]],
	["_scriptedWaypoint",[],[[]]]
];

if (_aircraftClass isEqualTo "") then {
	_aircraftClass = "C_Plane_Civil_01_F";
};

private _startPos = _pos getPos [_distance,_dir - 180];
_startPos set [2,_height];
private _endPos = _pos getPos [_distance,_dir];
_endPos set [2,_height];
_pos = _pos getPos [_offset,_dir - 180];
_pos set [2,_height];

private _aircraft = createVehicle [_aircraftClass,[0,0,1000],[],0,"FLY"];
_aircraft setDir _dir;
_aircraft setPos _startPos;
_aircraft setVectorUp [0,0,1];
_aircraft setVelocityModelSpace [0,getNumber (configOf _aircraft >> "maxSpeed") / 3.6,0];

private _group = createVehicleCrew _aircraft;
_group deleteGroupWhenEmpty true;
_group addVehicle _aircraft;

_aircraft flyInHeight _height;
_aircraft lockDriver true;
_group allowFleeing 0;
_group setBehaviour "CARELESS";
_group setCombatMode "BLUE";
_group call FUNC(AICompat);

{
	_x disableAI "TARGET";
	_x disableAI "AUTOTARGET";
	_x disableAI "AUTOCOMBAT";
} forEach units _group;

_group setVariable [QGVAR(aircraft),_aircraft,true];

if (_scriptedWaypoint isNotEqualTo []) then {
	_scriptedWaypoint params [["_script","",[""]],["_args",[],[[]]]];

	private _wp1 = _group addWaypoint [ASLToAGL _pos,0];
	_wp1 setWaypointType "SCRIPTED";
	_wp1 setWaypointScript format ["%1 %2",_script,_args];
	_wp1 setWaypointPosition [_pos,-1];
	_wp1 setWaypointDescription QGVAR(flyby1);
} else {
	private _wp1 = _group addWaypoint [ASLToAGL _pos,0];
	_wp1 setWaypointType "MOVE";
	_wp1 setWaypointDescription QGVAR(flyby1);
};

private _wp2 = _group addWaypoint [ASLToAGL _endPos,0];
_wp2 setWaypointType "MOVE";
_wp2 setWaypointDescription QGVAR(flyby2);

_group addEventHandler ["WaypointComplete",{
	params ["_group","_waypointIndex"];

	private _aircraft = _group getVariable [QGVAR(aircraft),objNull];

	if (waypointDescription _this == QGVAR(flyby1)) then {
		[QGVAR(flybyPosReached),[_aircraft]] call CBA_fnc_globalEvent;	
	};

	if (waypointDescription _this == QGVAR(flyby2)) then {
		[{
			deleteVehicleCrew (_this # 0);
			deleteVehicle (_this # 0);
			deleteGroup (_this # 1);
		},[_aircraft,_group],2] call CBA_fnc_waitAndExecute;

		[QGVAR(flybyEnd),[_aircraft]] call CBA_fnc_globalEvent;
	};
}];

[QGVAR(flybyStart)] call CBA_fnc_globalEvent;

_aircraft