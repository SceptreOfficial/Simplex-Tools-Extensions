#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	[{
		params ["_curatorSelected","_modulePos"];
		_curatorSelected params ["_objects","_groups","_waypoints","_markers"];

		_objects = _objects select {_x isKindOf "CAManBase"};

		if (_objects isEqualTo []) exitWith {
			[LELSTRING(common,zeusNothingSelected),QEGVAR(common,failure)] call EFUNC(common,zeusMessage);
		};

		[LLSTRING(moduleHALOName),[
			["COMBOBOX","Drop method",[["Instant","Module position (simple)","Module position (flyby)"],1],false],
			["EDITBOX","Flyby aircraft class","B_T_VTOL_01_infantry_F",false,{},{0 call EFUNC(sdf,getValue) == 2}],
			["EDITBOX","Flyby distance","4000",false,{},{0 call EFUNC(sdf,getValue) == 2}],
			["SLIDER","Jump delay",[[0.1,3,1],0.8],false,{},{0 call EFUNC(sdf,getValue) == 2}],
			["EDITBOX","Drop altitude","2000",false],
			["EDITBOX","AI opening altitude","150",false]
		],{
			params ["_values","_args"];
			_values params ["_method","_aircraftClass","_flybyDistance","_jumpDelay","_altitude","_AIOpenAltitude"];
			_args params ["_objects","_modulePos"];

			_flybyDistance = (parseNumber _flybyDistance) max 10;
			_altitude = (parseNumber _altitude) max 10;
			_AIOpenAltitude = parseNumber _AIOpenAltitude;

			switch _method do {
				case 0 : {
					{
						private _pos = getPosATLVisual _x;
						_pos set [2,_altitude];
						[QGVAR(haloPos),[_x,_pos,_AIOpenAltitude],_x] call CBA_fnc_targetEvent;
					} forEach _objects;
				};
				case 1 : {
					{
						private _pos = _modulePos getPos [_forEachIndex * 10 min 150 max 20,_forEachIndex * 50];
						_pos set [2,_altitude];
						[QGVAR(haloPos),[_x,_pos,_AIOpenAltitude],_x] call CBA_fnc_targetEvent;
					} forEach _objects;
				};
				case 2 : {
					private _speed = getNumber (configFile >> "CfgVehicles" >> _aircraftClass >> "maxSpeed");
					//private _G = 9.80665;
					//private _distance = _speed * 0.27 * sqrt (2 * _G * _altitude) / _G;
					private _offset = _speed * 0.45 * (count _objects / 2 max 1) * _jumpDelay;
					private _aircraft = [_modulePos,random 360,_flybyDistance,_altitude,_aircraftClass,_offset] call EFUNC(common,flyby);
					
					_aircraft setVariable [QGVAR(HALO),[_jumpDelay,_AIOpenAltitude],true];

					{
						[QEGVAR(common,execute),[[_x,_aircraft],{
							(_this # 0) moveInCargo (_this # 1)
						}],_x] call CBA_fnc_targetEvent;
					} forEach _objects;
				};
			};
		},[_objects,_modulePos]] call EFUNC(sdf,dialog);
	},getPosVisual _logic,LELSTRING(common,zeusSelectionUnits)] call EFUNC(common,zeusSelection);

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
