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
		[_logic,true,getAssignedCuratorLogic player] call zen_common_fnc_updateEditableObjects;
		
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

			private _posASL = getPosASLVisual _logic;
			private _endDir = -1;
			private _hoverHeight = 15;
			
			if (!isNull (_logic getVariable [QGVAR(hoverHelper),objNull])) then {
				_endDir = getDirVisual _logic;
				private _ix = lineIntersectsSurfaces [_posASL vectorAdd [0,0,50],_posASL vectorAdd [0,0,-50],_logic,_logic getVariable [QGVAR(hoverHelper),objNull],true,1,"GEOM","FIRE"];
				_hoverHeight = if (_ix isNotEqualTo []) then {
					0 max (abs ((_ix # 0 # 0 # 2) - _posASL # 2)) min 50
				} else {50};
			};

			// Enter
			if (_key == 0x1C) exitWith {
				_display displayRemoveEventHandler [_thisType,_thisID];

				[LLSTRING(moduleHoverName),[
					["SLIDER",["Timeout","Minimum hold time. -1 for indefinite / require manual release"],[[-1,600,0],30]],
					["SLIDER",["Hover height","Helicopter will hover at this height above the surface"],[[0,50,1],_hoverHeight]],
					["SLIDER",["Final azimuth","-1 for auto"],[[-1,360,0],_endDir]],
					["SLIDER",["Approach distance","Distance to start matching the target height"],[[10,600,0],100]]
				],{
					_values params ["_timeout","_hoverHeight","_endDir","_approach"];
					_arguments params ["_vehicle","_posASL"];

					private _waypoint = (group driver _vehicle) addWaypoint [ASLtoAGL _posASL,0];
					_waypoint setWaypointType "SCRIPTED";
					_waypoint setWaypointScript format ["%1 %2",QPATHTOEF(common,functions\fnc_wpHover.sqf),[
						_timeout,
						_hoverHeight,
						_endDir,
						_approach
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
