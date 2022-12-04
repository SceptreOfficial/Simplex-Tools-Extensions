#include "script_component.hpp"

params ["_group",["_teleport",false,[false]]];

_group enableAttack false;

private _startPos = getPos leader _group;
private _units = (units _group) select {alive _x};
private _buildingPositions = [];
{_buildingPositions append ([_x] call CBA_fnc_buildingPositions)} forEach (nearestObjects [_startPos,["Building"],80,true]);

{
	_unit setVariable [QGVAR(garrisonDone),nil];

	if (vehicle _x isKindOf "CAManBase") then {
		private "_position";
		
		if (_buildingPositions isNotEqualTo []) then {
			while {
				_position = _buildingPositions deleteAt (floor random (count _buildingPositions));
				_buildingPositions isNotEqualTo [] && (_position nearEntities ["CAManBase",2]) isNotEqualTo []
			} do {};

			_x setUnitPos "UP";
		} else {
			// If no nearby buildings positions to occupy, send units to random positions in a 40m radius
			_position = _startPos getPos [40 * sqrt random 1, random 360];
		};

		if (_teleport) then {
			_x setPos _position;
			doStop _x;
		} else {
			_x setVariable [QGVAR(garrisonDone),false];
			_x doMove _position;

			[{
				params ["_unit","_pos","_group"];

				if (_group getVariable QGVAR(garrisonType) isEqualTo 0 && {!(_group getVariable QGVAR(available))}) exitWith {true};
				if (!alive _unit || unitReady _unit || {_unit distance _pos < 3}) then {
					doStop _unit;
					_unit setVariable [QGVAR(garrisonDone),true];
					true
				} else {false};
			},{},[_x,_position,_group]] call CBA_fnc_waitUntilAndExecute;
		};
	} else {
		doStop _x; // stop vehicles
	};
} forEach _units;

// 0 : Responsive 		- Units garrison until engaged or requested
// 1 : Repositioning 	- Units move around the area when engaged. Will not respond to requests
// 2 : Static 			- Units remain stationary. Will not respond to requests
switch (_group getVariable [QGVAR(garrisonType),0]) do {
	case 0 : {};
	case 1 : {
		[{
			({!alive _x || _x getVariable [QGVAR(garrisonDone),true]} count (_this # 1)) isEqualTo count (_this # 1)
		},{
			private _group = _this # 0;
			private _units = (units _group) select {alive _x};
			if (_units isEqualTo []) exitWith {};

			private _leader = leader _group;
			if (!alive _leader) then {
				_leader = _units # 0;
				_group selectLeader _leader;
			};

			[_leader,"FiredNear",{
				private _leader = _this # 0;
				private _group = _thisArgs;

				_leader removeEventHandler [_thisType,_thisID];

				private _waitTime = [5 + round random 30,600] select (count ((units _group) select {alive _x}) < 4 && random 1 < 0.5);

				[{
					params ["_leader","_group"];

					private _units = (units _group) select {alive _x};
					
					if (_units isEqualTo []) exitWith {};

					if (!alive _leader) then {
						_leader = _units # 0;
						_group selectLeader _leader;
					};

					private _reactingUnits = [_leader];
					for "_i" from 0 to (floor ((count _units) / (2 + floor random 3))) do {
						_reactingUnits pushBackUnique (selectRandom _units);
					};

					_reactingUnits doFollow _leader;
					{_x setUnitPos "AUTO"} forEach _reactingUnits;

					[_group,(_group getVariable QGVAR(origin)) # 0,15,"SAD","AWARE","RED","NORMAL","WEDGE",["true",""],[0,0,0],15] call EFUNC(common,addWaypoint);
					
					[{
						_this call EFUNC(common,clearWaypoints);
						[QGVAR(returnToOrigin),_this,_this] call CBA_fnc_targetEvent;
					},_group,180 + round random 60] call CBA_fnc_waitAndExecute;
				},[_leader,_group],_waitTime] call CBA_fnc_waitAndExecute;
			},group _leader] call CBA_fnc_addBISEventHandler;
		},[_group,_units]] call CBA_fnc_waitUntilAndExecute;
	};
	case 2 : {
		[{
			({!alive _x || _x getVariable [QGVAR(garrisonDone),true]} count (_this # 1)) isEqualTo count (_this # 1)
		},{
			{_x disableAI "PATH"} forEach (_this # 1);
		},[_group,_units]] call CBA_fnc_waitUntilAndExecute;
	};
};
