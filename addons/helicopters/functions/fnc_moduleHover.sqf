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
		params ["_success","_vehicle","_posASL"];

		if (!_success) exitWith {};

		private _ix = lineIntersectsSurfaces [ATLtoASL positionCameraToWorld [0,0,0],_posASL,_vehicle,objNull,true,1,"GEOM","FIRE"];
		if (_ix isNotEqualTo []) then {_posASL = _ix # 0 # 0};

		_posASL = _posASL vectorAdd [0,0,1];

		// Create helper logic
		private _logic = createGroup [sideLogic,true] createUnit ["Logic",[0,0,0],[],0,"CAN_COLLIDE"];
		_logic setPosASL _posASL;
		_logic setDir 0;
		_logic setVariable [QGVAR(hoverData),[typeOf _vehicle,getModelInfo _vehicle # 3]];
		["zen_common_addObjects",[[_logic],getAssignedCuratorLogic player]] call CBA_fnc_serverEvent;
		
		[_logic,"Deleted",{
			params ["_logic"];
			{deleteVehicle _x} forEach (attachedObjects _logic);
		}] call CBA_fnc_addBISEventHandler;

		["PRESS ENTER TO CONFIRM MODULE POSITION","FD_Finish_F",2] call EFUNC(common,zeusMessage);

		[findDisplay IDD_RSCDISPLAYCURATOR,"KeyDown",{
			params ["_display","_key"];
			_thisArgs params ["_vehicle","_logic"];

			if (isNull _vehicle || isNull _logic) exitWith {
				_display displayRemoveEventHandler [_thisType,_thisID];
				false
			};

			// Escape
			if (_key == 0x01) exitWith {
				_display displayRemoveEventHandler [_thisType,_thisID];
				"CANCELLED" call EFUNC(common,zeusMessage);
				deleteVehicle _logic;
				true
			};

			private _endDir = [getDirVisual _logic,-1] select (isNull (_logic getVariable [QGVAR(hoverHelper),objNull]));

			// Enter
			if (_key == 0x1C) exitWith {
				_display displayRemoveEventHandler [_thisType,_thisID];

				[LLSTRING(moduleHoverName),[
					["SLIDER",["Hold time","Minimum hold time. -1 for indefinite / require manual release"],[[-1,600,0],30]],
					["SLIDER",["End azimuth","-1 to ignore"],[[-1,360,0],_endDir]],
					["EDITBOX",["Fly height",""],"50"],
					["SLIDER",["Approach distance","Distance to start matching the target height"],[[10,600,0],100]]
				],{
					_values params ["_holdTime","_endDir","_flyHeight","_approachDistance"];
					_arguments params ["_vehicle","_posASL"];

					private _waypoint = (group driver _vehicle) addWaypoint [ASLtoAGL _posASL,0];
					_waypoint setWaypointType "SCRIPTED";
					_waypoint setWaypointScript format ["%1 %2",QPATHTOEF(common,functions\fnc_wpHover.sqf),[
						_posASL,
						_endDir,
						parseNumber _flyHeight,
						_approachDistance,
						nil,
						_holdTime
					]];
					_waypoint setWaypointPosition [_posASL,-1];
					
					"HOVER REQUEST CONFIRMED" call EFUNC(common,zeusMessage);
				},[_vehicle,getPosASLVisual _logic]] call EFUNC(sdf,dialog);

				deleteVehicle _logic;
				true
			};

			false
		},[_vehicle,_logic]] call CBA_fnc_addBISEventHandler;
	}] call zen_common_fnc_selectPosition;
},_this] call CBA_fnc_execNextFrame;
