#include "..\script_component.hpp"

params [["_aircraftClass","",[""]],["_startPos",[],[[]]],["_endPos",[],[[]]],["_altitude",500,[0]]];

_startPos set [2,_altitude];

// Spawn vehicle
private _aircraft = createVehicle [_aircraftClass,[0,0,_altitude],[],0,"FLY"];
if (isNull _aircraft) exitWith {};
{_aircraft removeWeapon _x} forEach weapons _aircraft;
_aircraft setDir (_startPos getDir _endPos);
_aircraft setPos _startPos;
_aircraft setVelocityModelSpace [0,100,0];

// Spawn AI pilot
private _group = createGroup [civilian,true];
_group call EFUNC(common,AICompat);
private _pilot = _group createUnit ["C_man_pilot_F",[0,0,0],[],0,"CAN_COLLIDE"];
_pilot moveInDriver _aircraft;
_pilot setBehaviour "CARELESS";
_pilot setSkill 1;
_pilot allowFleeing 0;
_pilot disableAI "AUTOCOMBAT";
_pilot disableAI "AUTOTARGET";
_pilot disableAI "FSM";

// Move to the end pos
private _wp = _group addWaypoint [_endPos,0];
_wp setWaypointType "MOVE";
_wp setWaypointCompletionRadius 300;
_wp setWaypointStatements ["true","
	private _group = group this;
	private _vehicle = vehicle this;

	if (local _group) then {
		deleteVehicleCrew _vehicle;
		deleteGroup	_group;
		deleteVehicle _vehicle;
	};
"];

// Time to live
if (GVAR(aircraftTTL) >= 1) then {
	[{
		params ["_group","_vehicle"];

		if (isNull _vehicle) exitWith {};

		deleteVehicleCrew _vehicle;
		deleteGroup	_group;
		deleteVehicle _vehicle;
	},[_group,_aircraft],GVAR(aircraftTTL)] call CBA_fnc_waitAndExecute;
};

_aircraft flyInHeight _altitude;
