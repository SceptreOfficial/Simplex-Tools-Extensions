#include "..\script_component.hpp"

params ["_unit","_firer"];

if (!local _unit || !alive _unit || {side vehicle _unit != civilian}) exitWith {};

if !(_unit isKindOf "CAManBase") then {
	_unit = driver _unit;
};

if (_unit getVariable [QGVAR(panicking),false]) exitWith {};

if (_unit in _unit) then {
	switch (round random 2) do {
		case 0 : {_unit switchMove "ApanPercMstpSnonWnonDnon_G01"};
		case 1 : {_unit playMoveNow "ApanPknlMstpSnonWnonDnon_G01"};
		case 2 : {_unit playMoveNow "ApanPpneMstpSnonWnonDnon_G01"};
	};
} else {
	// 50/50 chance to get out of vehicle
	if (random 1 < 0.5) exitWith {};

	if (isNull group _unit) then {
		moveOut _unit;
	} else {
		unassignVehicle _unit;
		[_unit] orderGetIn false;
	};

	[{!alive _this || _this in _this},{
		if (!alive _this) exitWith {};

		switch (round random 2) do {
			case 0 : {_this switchMove "ApanPercMstpSnonWnonDnon_G01"};
			case 1 : {_this playMoveNow "ApanPknlMstpSnonWnonDnon_G01"};
			case 2 : {_this playMoveNow "ApanPpneMstpSnonWnonDnon_G01"};
		};
	},_unit] call CBA_fnc_waitUntilAndExecute;
};

// Flee
private _pos = _unit getPos [150 + random 150,(_firer getDir _unit) + random [-60,0,60]];

_unit forceSpeed 999;

if (isNull group _unit) then {
	_unit moveTo _pos;
} else {
	doStop _unit;

	[{
		params ["_unit","_pos"];
		_unit doFollow _unit;
		_unit doMove _pos;
	},[_unit,_pos],1] call CBA_fnc_waitAndExecute;
};

// Return to normal state after it's safe
_unit setVariable [QGVAR(panicTimeout),CBA_missionTime + GVAR(minPanicTime)];

if (_unit getVariable [QGVAR(panicPFHID),-1] != -1) exitWith {};

_unit setVariable [QGVAR(panicking),true,true];
_unit setVariable [QGVAR(panicPFHID),
	[{
		params ["_unit","_PFHID"];

		if (_unit getVariable [QGVAR(panicTimeout),-1] < CBA_missionTime) then {
			_unit switchMove "";
			_unit forceSpeed -1;
			_unit setSpeedMode "LIMITED";
			_unit setVariable [QGVAR(panicPFHID),nil];
			_unit setVariable [QGVAR(panicTimeout),nil];
			_unit setVariable [QGVAR(panicking),nil,true];
			_PFHID call CBA_fnc_removePerFrameHandler;
		};
	},30,_unit] call CBA_fnc_addPerFrameHandler
];

