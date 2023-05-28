#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _vehicle = attachedTo _logic;
	deleteVehicle _logic;

	if (!alive _vehicle || !(_vehicle isKindOf "Air")) exitWith {
		"NO AIR VEHICLE SELECTED" call EFUNC(common,zeusMessage);
	};

	if (!alive driver _vehicle || isPlayer driver _vehicle) exitWith {
		"VEHICLE HAS NO AI PILOT" call EFUNC(common,zeusMessage);
	};

	[_vehicle,{
		// execNextFrame to capture curatorSelected
		[{
			params ["_success","_vehicle","_posASL"];

			if (!_success) exitWith {};

			private _ix = lineIntersectsSurfaces [ATLtoASL positionCameraToWorld [0,0,0],_posASL,_vehicle,objNull,true,1,"GEOM","FIRE"];
			if (_ix isNotEqualTo []) then {_posASL = _ix # 0 # 0};

			private _cfgWeapons = configFile >> "CfgWeapons";
			private _weaponNames = [];
			private _weapons = [];
			private _magazines = _vehicle magazinesTurret [-1];

			{
				if (compatibleMagazines _x arrayIntersect _magazines isNotEqualTo []) then {
					_weaponNames pushBack getText (_cfgWeapons >> _x >> "displayName");
					_weapons pushBack _x;
				};
			} forEach (_vehicle weaponsTurret [-1]);

			[LLSTRING(moduleStrafeName),[
				["COMBOBOX",["Weapon",""],[_weaponNames,0,_weapons]],
				["CHECKBOX",["Infinite ammo",""],true],
				["SLIDER",["Approch direction","-1 for auto"],[[-1,360,0],-1]],
				["SLIDER",["Spread length","Length of target area"],[[0,50,0],0]],
				["SLIDER",["Duration","Firing duration"],[[1,10,0],3]],
				["SLIDER",["Trigger delay","Minimum time between each pull of the trigger"],[[0,10,1],0]]
			],{
				_values params ["_weapon","_infiniteAmmo","_approachDir","_spread","_duration","_triggerDelay"];
				_arguments params ["_vehicle","_posASL","_object"];

				private _waypoint = (group driver _vehicle) addWaypoint [ASLtoAGL _posASL,0];
				_waypoint setWaypointType "SCRIPTED";
				_waypoint setWaypointScript format ["%1 %2",QPATHTOF(waypoints\wpStrafe.sqf),[
					_weapon,
					_infiniteAmmo,
					_approachDir,
					_spread,
					_duration,
					_triggerDelay
				]];
				_waypoint setWaypointPosition [_posASL,-1];

				if (!isNull _object) then {
					_waypoint waypointAttachVehicle _object;
				};

				"STRAFE CONFIRMED" call EFUNC(common,zeusMessage);
			},[_vehicle,_posASL,(curatorSelected # 0) param [0,objNull]]] call EFUNC(sdf,dialog);
		},_this] call CBA_fnc_execNextFrame;
	}] call zen_common_fnc_selectPosition;
},_this] call CBA_fnc_execNextFrame;
