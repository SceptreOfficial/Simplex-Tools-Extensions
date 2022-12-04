#include "script_component.hpp"

params [
	["_area",[],["",objNull,locationNull,[]],5],
	["_side",sideEmpty,[sideEmpty]],
	["_patrolDensity",[],[[]]],
	["_garrisonDensity",[],[[]]],
	["_sentryDensity",[],[[]]],
	["_QRFDensity",[],[[]]],
	["_coefficients",[],[[]]],
	["_requestDistance",800,[0]],
	["_responseDistance",800,[0]],
	["_QRFRequestDistance",1600,[0]],
	["_QRFResponseDistance",1600,[0]],
	["_patrolRadiusRandom",[125,200,250],[[]],3],
	["_ETATarget",player,[objNull]]
];

_coefficients params [["_patrolCoef",1,[0]],["_garrisonCoef",1,[0]],["_sentryCoef",1,[0]],["_QRFCoef",1,[0]]];

private _settings = [_requestDistance,_responseDistance,_QRFRequestDistance,_QRFResponseDistance,_patrolRadiusRandom];

_area = [_area] call CBA_fnc_getArea;

if (_area isEqualTo []) exitWith {};

private _queueCount = 0;

{
	_x params ["_density","_coefficient"];

	private _assignmentType = _forEachIndex;

	{
		_x params [["_config",0,[configNull,[],0]],["_range",[],[[]]]];
		_range params [["_min",0,[0]],["_max",0,[0]]];

		if (_max > 0) then {
			if (_config isEqualType 0 && {_config <= 0}) exitWith {};
				
			_min = round linearConversion [0,1,_coefficient,0,_min,true];
			_max = round linearConversion [0,1,_coefficient,0,_max,true];

			for "_i" from 1 to ((_min + round random (_max - _min)) min _max) do {
				[_assignmentType,[_area,_side,_config,_settings]] call FUNC(occupyQueueAdd);
				_queueCount = _queueCount + 1;
			};
		};
	} forEach _density;
} forEach [[_patrolDensity,_patrolCoef],[_garrisonDensity,_garrisonCoef],[_sentryDensity,_sentryCoef],[_QRFDensity,_QRFCoef]];

// Start ETA tracker for client that submitted occupation
[QGVAR(occupationETA),_queueCount,_ETATarget] call CBA_fnc_targetEvent;
