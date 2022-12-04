#include "script_component.hpp"

params ["_civ","_firer"];

if (!local _civ || !alive _civ || {side group vehicle _civ != civilian}) exitWith {};

if (_civ in _civ) then {
	if !(_civ getVariable [QGVAR(panicking),false]) then {
		switch (round random 2) do {
			case 0 : {_civ switchMove "ApanPercMstpSnonWnonDnon_G01"};
			case 1 : {_civ playMoveNow "ApanPknlMstpSnonWnonDnon_G01"};
			case 2 : {_civ playMoveNow "ApanPpneMstpSnonWnonDnon_G01"};
		};
	};
} else {
	// 50/50 chance to get out of vehicle
	if (!(_civ getVariable [QGVAR(panicking),false]) && random 1 < 0.5) then {
		unassignVehicle _civ;
		[_civ] orderGetIn false;

		[{!alive _this || _this in _this},{
			if (!alive _this) exitWith {};

			switch (round random 2) do {
				case 0 : {_this switchMove "ApanPercMstpSnonWnonDnon_G01"};
				case 1 : {_this playMoveNow "ApanPknlMstpSnonWnonDnon_G01"};
				case 2 : {_this playMoveNow "ApanPpneMstpSnonWnonDnon_G01"};
			};
		},_civ] call CBA_fnc_waitUntilAndExecute;
	};
};

// Flee
doStop _civ;
_civ doFollow _civ;
_civ forceSpeed 999;
_civ doMove (_civ getPos [150 + random 150,(_firer getDir _civ) + random [-75,0,75]]);

#ifdef DEBUG_MODE_FULL
	systemChat format ["%1 - Panicking",name _civ];
#endif

// Return to normal state after it's safe
_civ setVariable [QGVAR(panicTimeout),CBA_missionTime + GVAR(minPanicTime)];

if (_civ getVariable [QGVAR(panicPFHID),-1] != -1) exitWith {};

_civ setVariable [QGVAR(panicking),true,true];
_civ setVariable [QGVAR(panicPFHID),
	[{
		params ["_civ","_PFHID"];

		if (_civ getVariable [QGVAR(panicTimeout),-1] < CBA_missionTime) then {
			_civ switchMove "";
			_civ forceSpeed -1;
			_civ setSpeedMode "LIMITED";
			_civ setVariable [QGVAR(panicPFHID),nil];
			_civ setVariable [QGVAR(panicTimeout),nil];
			_civ setVariable [QGVAR(panicking),nil,true];
			_PFHID call CBA_fnc_removePerFrameHandler;
		};
	},30,_civ] call CBA_fnc_addPerFrameHandler
];

