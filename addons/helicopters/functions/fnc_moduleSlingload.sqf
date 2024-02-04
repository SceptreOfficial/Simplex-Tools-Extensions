#include "..\script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _vehicle = attachedTo _logic;
	deleteVehicle _logic;

	if (!alive _vehicle || !(_vehicle isKindOf "Helicopter")) exitWith {
		"NO HELICOPTER SELECTED" call EFUNC(common,zeusMessage);
	};

	if (!alive driver _vehicle || isPlayer driver _vehicle) exitWith {
		"HELICOPTER HAS NO AI PILOT" call EFUNC(common,zeusMessage);
	};

	[_vehicle,{
		// execNextFrame to capture curatorSelected
		[{
			params ["_success","_vehicle","_posASL"];

			if (!_success) exitWith {};

			private _ix = lineIntersectsSurfaces [ATLtoASL positionCameraToWorld [0,0,0],_posASL,_vehicle,objNull,true,1,"GEOM","FIRE"];
			if (_ix isNotEqualTo []) then {_posASL = _ix # 0 # 0};

			private _cargo = _vehicle getVariable [QEGVAR(common,slingloadCargo),objNull];

			if (isNull _cargo) then {
				private _cargo = (curatorSelected # 0) param [0,objNull];

				if !([_vehicle,_cargo,EGVAR(common,slingloadMassOverride)] call EFUNC(common,canSlingLoad)) then {
					_cargo = objNull;
				};

				if (!isNull _cargo) then {
					private _waypoint = (group driver _vehicle) addWaypoint [ASLtoAGL _posASL,0];
					_waypoint setWaypointType "SCRIPTED";
					_waypoint setWaypointScript QPATHTOEF(common,functions\fnc_wpSlingloadPickup.sqf);
					_waypoint setWaypointPosition [_posASL,-1];
					_waypoint waypointAttachVehicle _cargo;
					
					"SLINGLOAD PICKUP CONFIRMED" call EFUNC(common,zeusMessage);
				} else {
					"NO VALID CARGO SELECTED" call EFUNC(common,zeusMessage);
				};
			} else {
				private _waypoint = (group driver _vehicle) addWaypoint [ASLtoAGL _posASL,0];
				_waypoint setWaypointType "SCRIPTED";
				_waypoint setWaypointScript QPATHTOEF(common,functions\fnc_wpSlingloadDropoff.sqf);
				_waypoint setWaypointPosition [_posASL,-1];

				"SLINGLOAD DROPOFF CONFIRMED" call EFUNC(common,zeusMessage);
			};
		},_this] call CBA_fnc_execNextFrame;
	}] call zen_common_fnc_selectPosition;
},_this] call CBA_fnc_execNextFrame;
