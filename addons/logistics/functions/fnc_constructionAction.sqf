#include "..\script_component.hpp"
// Adapted from ACE3 - `ace_fortify_fnc_deployObject`
//https://github.com/acemod/ACE3/blob/master/addons/fortify/functions/fnc_deployObject.sqf
params ["_vehicle","_unit","_args"];
_args params ["_class","_name","_cost","_buildTime","_initFnc"];

if (_vehicle getVariable [QGVAR(constructionBudget),0] < _cost) exitWith {
	LLSTRING(constructionNoCredit) call EFUNC(common,hint);
};

private _construction = [_vehicle,_class,_name,_cost,_buildTime,_initFnc];

[{
	params ["_unit","_construction"];
	_construction params ["_vehicle","_class","_name","_cost","_buildTime","_initFnc"];

	if (isNil QGVAR(isPlacing)) then {
		disableSerialization;
		private _display = findDisplay 46;
		
		_display displayAddEventHandler ["MouseZChanged",{
			if (GVAR(isPlacing) != PLACE_WAITING) exitWith {false};
			switch true do {
				case cba_events_shift : {GVAR(objectRotationX) = GVAR(objectRotationX) + ((_this # 1) * 5)};
				case cba_events_control : {GVAR(objectRotationY) = GVAR(objectRotationY) + ((_this # 1) * 5)};
				default {GVAR(objectRotationZ) = GVAR(objectRotationZ) + ((_this # 1) * 5)};
			};
			true
		}];

		_display displayAddEventHandler ["MouseButtonDown",{
			if (GVAR(isPlacing) != PLACE_WAITING) exitWith {false};
			if ((_this # 1) != 1) exitWith {false};
			GVAR(isPlacing) = PLACE_CANCEL;
			true
		}];
	};

	GVAR(ghosts) = [];

	if (GVAR(visualAid) != 0) then {
		{
			private _xConstruction = _x getVariable [QGVAR(construction),[]];
			if (_xConstruction isEqualTo []) then {continue};
			
			private _ghost = (_xConstruction # 1) createVehicleLocal [0,0,0];
			_ghost disableCollisionWith _vehicle;
			_ghost disableCollisionWith _unit;
			_ghost setVectorDirAndUp [_xConstruction # 7,_xConstruction # 8];
			_ghost setPosWorld (_xConstruction # 6);
			GVAR(ghosts) pushBack _ghost;
		} forEach GVAR(constructionBoxes);

		if (GVAR(visualAid) == 1) then {
			GVAR(ghostsPFHID) = [{
				params ["_args","_PFHID"];
				_args params ["_hide"];

				if (GVAR(ghosts) isEqualTo []) exitWith {};

				{_x hideObject _hide} forEach GVAR(ghosts);
				_args set [0,!_hide];
			},GVAR(flashingFrequency),[true]] call CBA_fnc_addPerFrameHandler;
		};

		if (GVAR(visualAid) == 2) then {
			GVAR(ghostsPFHID) = [{
				params ["_args","_PFHID"];
				_args params ["_index","_lastGhost"];

				if (GVAR(ghosts) isEqualTo []) exitWith {};

				private _ghost = GVAR(ghosts) # _index;
				
				_index = _index + 1;
				_args set [0,[_index,0] select (_index >= count GVAR(ghosts))];

				if (!isNull _lastGhost) then {
					_lastGhost hideObject false;
				};

				if (_ghost == _lastGhost) exitWith {
					_args set [1,objNull];
				};

				_ghost hideObject true;
				_args set [1,_ghost];
			},GVAR(flashingFrequency),[0,objNull]] call CBA_fnc_addPerFrameHandler;
		};
	};

	GVAR(objectRotationX) = 0;
	GVAR(objectRotationY) = 0;
	GVAR(objectRotationZ) = 0;
	GVAR(isPlacing) = PLACE_WAITING;

	private _helper = "Logic" createVehicleLocal [0,0,0];
	private _object = _class createVehicleLocal [0,0,0];
	_object disableCollisionWith _vehicle;
	_object disableCollisionWith _unit;
	_object attachTo [_helper,[0,0,0]];

	["CONFIRM","CANCEL","ROTATE",[
		["alt",localize "str_3den_display3den_entitymenu_movesurface_text"],
		["shift",localize "str_disp_conf_xaxis"],
		["control", localize "str_disp_conf_yaxis"]
	]] call ace_interaction_fnc_showMouseHint;
	private _mouseClickID = [_unit,"DefaultAction",{GVAR(isPlacing) == PLACE_WAITING},{GVAR(isPlacing) = PLACE_APPROVE}] call ace_common_fnc_addActionEventHandler;
	[QGVAR(onDeployStart),[_unit,_helper,_object,_construction]] call CBA_fnc_localEvent;

	[{
		params ["_args","_PFHID"];
		_args params ["_unit","_helper","_object","_mouseClickID","_construction"];

		if (_unit != call CBA_fnc_currentUnit || isNull _helper || isNull _object || {!([_unit,_object,[]] call ace_common_fnc_canInteractWith)}) then {
			GVAR(isPlacing) = PLACE_CANCEL;
		};

		if (GVAR(isPlacing) != PLACE_WAITING) exitWith {
			_PFHID call CBA_fnc_removePerFrameHandler;
			call ace_interaction_fnc_hideMouseHint;
			[_unit,"DefaultAction",_mouseClickID] call ace_common_fnc_removeActionEventHandler;

			if (GVAR(isPlacing) == PLACE_APPROVE) then {
				GVAR(isPlacing) = PLACE_CANCEL;
				[_unit,_helper,_object,_construction] call FUNC(constructionDeploy);
			};
			
			deleteVehicle _object;
			deleteVehicle _helper;
			{deleteVehicle _x} forEach GVAR(ghosts);
			GVAR(ghosts) = [];
			GVAR(ghostsPFHID) call CBA_fnc_removePerFrameHandler;
		};

		([_object] call ace_fortify_fnc_axisLengths) params ["_width","_length","_height"];
		private _distance = (_width max _length) + 0.5;
		private _start = eyePos _unit;
		private _camViewDir = getCameraViewDirection _unit;
		private _basePos = _start vectorAdd (_camViewDir vectorMultiply _distance);
		_basePos set [2,(_basePos # 2 - _height * 0.3) max (getTerrainHeightASL _basePos + _height / 2 - 0.1)];

		_helper setPosASL _basePos;

		private _vZ =  180 + GVAR(objectRotationZ) + getDir _unit;
		
		if (cba_events_alt) then {
			_helper setDir _vZ;
			_helper setVectorUp (surfaceNormal _basePos);
		} else {
			[_helper,GVAR(objectRotationX),GVAR(objectRotationY),_vZ] call ace_common_fnc_setPitchBankYaw;
		};
	},0,[_unit,_helper,_object,_mouseClickID,_construction]] call CBA_fnc_addPerFrameHandler;
},[_unit,_construction]] call CBA_fnc_execNextFrame;
