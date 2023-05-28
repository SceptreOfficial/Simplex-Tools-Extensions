#include "script_component.hpp"

if (canSuspend) exitWith {
	[FUNC(fastrope),_this] call CBA_fnc_directCall;
};

if (!isServer) exitWith {
	[QGVAR(execute),[_this,FUNC(fastrope)]] call CBA_fnc_serverEvent;
};

params ["_vehicle",["_units",[],[[]]]];

if (_units isEqualTo []) then {
	_units = (crew _vehicle - units group driver _vehicle) select {alive _x};
} else {
	//_units = _units select {alive _x};
	_units = (_units arrayIntersect crew _vehicle) select {alive _x};
};

if (_units isEqualTo []) exitWith {
	_vehicle setVariable [QPVAR(fastropeCancel),true,true];
};

_vehicle setVariable [QPVAR(fastropeUnits),_units,true];

private _sources = _vehicle getVariable [QPVAR(fastropeSources),getArray (configOf _vehicle >> QPVAR(fastropeSources))];

if (_sources isEqualTo []) then {
	private _center = getCenterOfMass _vehicle;
	private _zOffset = (2 boundingBoxReal _vehicle) # 0 # 2;

	_sources = [[_center # 0 + 0.8,0,_zOffset],[_center # 0 - 0.8,0,_zOffset]] apply {
		private _ixStart = _vehicle modelToWorldVisualWorld _x;
		private _ixEnd = _vehicle modelToWorldVisualWorld _center;
		private _ix = lineIntersectsSurfaces [_ixStart,_ixEnd,objNull,objNull,true,-1,"GEOM","FIRE",false];
		private _index = _ix findIf {_x # 2 == _vehicle};

		if (_index > -1) then {
			[_x # 0,_x # 1,(_vehicle worldToModelVisual ASLToATL (_ix # _index # 0)) # 2]
		} else {
			_x
		};
	};

	//_vehicle setVariable [QPVAR(fastropeSources),_sources,true];
};

if (count _sources > count _units) then {
	_sources = _sources select [0,count _units];
};

private _length = round (getPos _vehicle # 2 - 1.5);
private _lines = _sources apply {
	private _hook = "SoundSetSource_01_base_F" createVehicle [0,0,0];
	_hook allowDamage false;
	_hook attachTo [_vehicle,_x];

	private _anchor = "Land_Battery_F" createVehicle [0,0,0];
	_anchor allowDamage false;
	_anchor setPosASL (_vehicle modelToWorldWorld _x vectorAdd [0,0,-3]);
	_anchor enableRopeAttach true;

	private _rope = ropeCreate [_hook,[0,0,0],_anchor,[0,0,0],8];
	ropeUnwind [_rope,20,_length,false];
	
	[_hook,_anchor,_rope,_length]
};

_vehicle setVariable [QPVAR(fastrope),true,true];
_vehicle setVariable [QPVAR(fastropeDone),false,true];
_vehicle setVariable [QPVAR(fastropeCancel),nil,true];

[{
	[{
		params ["_args","_PFHID"];
		_args params ["_vehicle","_lines"];
		
		private _units = _vehicle getVariable [QPVAR(fastropeUnits),[]] select {alive _x};

		if (_units isEqualTo [] || !alive _vehicle || !alive driver _vehicle || _vehicle getVariable [QPVAR(fastropeCancel),false]) exitWith {
			_PFHID call CBA_fnc_removePerFrameHandler;
			_vehicle setVariable [QPVAR(fastrope),nil,true];
			_vehicle setVariable [QPVAR(fastropeUnits),nil,true];
			_vehicle setVariable [QPVAR(fastropeCancel),nil,true];
			_vehicle setVariable [QPVAR(fastropeDone),true,true];
			
			// Remove ropes
			{
				detach (_x # 0);
				(_x # 0) setVelocity [0,0,-10];
			} forEach _lines;

			[{
				{
					ropeDestroy (_x # 2);
					deleteVehicle (_x # 0);
					deleteVehicle (_x # 1);
				} forEach _this;
			},_lines,5] call CBA_fnc_waitAndExecute;
		};

		// Have a unit fastrope (locally)
		private _unit = selectRandom (_units select {!(_x getVariable [QPVAR(fastroping),false])});
		
		if (!isNil "_unit") then {
			private _line = selectRandom (_lines select {(_x # 0) getVariable [QPVAR(fastroping),true]});
			
			if (isNil "_line") exitWith {};
			
			private _hook = _line # 0;
			_hook setVariable [QPVAR(fastroping),false];
			[{_this setVariable [QPVAR(fastroping),nil]},_hook,1.5] call CBA_fnc_waitAndExecute;

			_unit setVariable [QPVAR(fastroping),true,true];
			[QGVAR(fastroping),[_unit,_vehicle,_line],_unit] call CBA_fnc_targetEvent;
		};
	},1.5,_this] call CBA_fnc_addPerFrameHandler;
},[_vehicle,_lines],5] call CBA_fnc_waitAndExecute;
