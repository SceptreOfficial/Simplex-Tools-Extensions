#include "script_component.hpp"

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

				if (getMass _cargo <= 0 || !simulationEnabled _cargo || isSimpleObject _cargo) then {
					_cargo = objNull;
				};

				if (!isNull _cargo) then {
					private _cargoID = format ["%1$%2",QGVAR(slingload),[CBA_missionTime,random 1]];
					_vehicle setVariable [_cargoID,_cargo,true];

					private _waypoint = (group driver _vehicle) addWaypoint [ASLtoAGL _posASL,0];
					_waypoint setWaypointType "SCRIPTED";
					_waypoint setWaypointScript format ["%1 %2",QPATHTOEF(common,functions\fnc_wpSlingloadPickup.sqf),[_cargoID]];
					_waypoint setWaypointPosition [_posASL,-1];
					
					"SLINGLOAD PICKUP CONFIRMED" call EFUNC(common,zeusMessage);
				} else {
					"NO CARGO SELECTED" call EFUNC(common,zeusMessage);
				};
			} else {
				private _waypoint = (group driver _vehicle) addWaypoint [ASLtoAGL _posASL,0];
				_waypoint setWaypointType "SCRIPTED";
				_waypoint setWaypointScript format ["%1 %2",QPATHTOEF(common,functions\fnc_wpSlingloadDropoff.sqf),[_posASL]];
				_waypoint setWaypointPosition [_posASL,-1];

				"SLINGLOAD DROPOFF CONFIRMED" call EFUNC(common,zeusMessage);
			};
		},_this] call CBA_fnc_execNextFrame;
	}] call zen_common_fnc_selectPosition;
},_this] call CBA_fnc_execNextFrame;
