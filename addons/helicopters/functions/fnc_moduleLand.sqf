#include "..\script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _vehicle = attachedTo _logic;
	deleteVehicle _logic;

	if (!alive _vehicle || !(_vehicle isKindOf "Helicopter" || _vehicle isKindOf "VTOL_Base_F")) exitWith {
		"NO HELICOPTER SELECTED" call EFUNC(common,zeusMessage);
	};

	if (!alive driver _vehicle || isPlayer driver _vehicle) exitWith {
		"HELICOPTER HAS NO AI PILOT" call EFUNC(common,zeusMessage);
	};

	[_vehicle,{
		params ["_success","_vehicle","_posASL"];

		if (!_success) exitWith {};

		private _ix = lineIntersectsSurfaces [ATLtoASL positionCameraToWorld [0,0,0],_posASL,_vehicle,objNull,true,1,"GEOM","FIRE"];
		if (_ix isNotEqualTo []) then {_posASL = _ix # 0 # 0};

		private _height = 1;
		if (getNumber (configOf _vehicle >> "gearRetracting") == 1) then {
			_height = _height + (1.5 max (1.5 * getNumber (configOf _vehicle >> "gearDownTime")));
		};

		_posASL = _posASL vectorAdd [0,0,_height];

		[LLSTRING(moduleLandName),[
			["SLIDER",["Timeout","Minimum hold time. -1 for indefinite / require manual release"],[[-1,600,0],30]],
			["CHECKBOX",["Engine on","Leaves engine running after landing"],true],
			["SLIDER",["Final azimuth","-1 for auto"],[[-1,360,0],-1]],
			["SLIDER",["Approach distance","Distance to start matching the target height"],[[10,600,0],100]]
		],{
			_values params ["_timeout","_engine","_endDir","_approach"];
			_arguments params ["_vehicle","_posASL"];

			private _waypoint = (group driver _vehicle) addWaypoint [ASLtoAGL _posASL,0];
			_waypoint setWaypointType "SCRIPTED";
			_waypoint setWaypointScript format ["%1 %2",QPATHTOEF(common,functions\fnc_wpLand.sqf),[
				_timeout,
				_engine,
				_endDir,
				_approach
			]];
			_waypoint setWaypointPosition [_posASL,-1];

			"LAND REQUEST CONFIRMED" call EFUNC(common,zeusMessage);
		},[_vehicle,_posASL]] call EFUNC(sdf,dialog);
	}] call zen_common_fnc_selectPosition;
},_this] call CBA_fnc_execNextFrame;
