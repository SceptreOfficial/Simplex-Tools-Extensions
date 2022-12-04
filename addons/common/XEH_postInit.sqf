#include "script_component.hpp"

// Headless Clients
if (isServer) then {
	addMissionEventHandler ["HandleDisconnect",{
		params ["_entity"];

		if (_entity in GVAR(headlessClients)) then {
			GVAR(headlessClients) deleteAt (GVAR(headlessClients) find _entity);
			publicVariable QGVAR(headlessClients);
		};

		false
	}];
};

if (!isServer && !hasInterface) then {
	[QGVAR(headlessClientJoined),player] call CBA_fnc_serverEvent;
};

// Throw grenade feature
[QGVAR(throwGrenade),FUNC(throwGrenade)] call CBA_fnc_addEventHandler;

// Arsenal dummy handling
["ace_arsenal_displayClosed",{
	if (isNil QGVAR(arsenalDummy) || isNil QGVAR(arsenalUnit)) exitWith {};

	GVAR(arsenalUnit) setUnitLoadout getUnitLoadout GVAR(arsenalDummy);	

	deleteVehicle GVAR(arsenalDummy);
	deleteVehicle GVAR(arsenalLight);
	GVAR(arsenalUnit) = nil;
	GVAR(arsenalDummy) = nil;
}] call CBA_fnc_addEventHandler;

// Arsenal dummy default animations
["ace_arsenal_leftPanelFilled",{
	if (GVAR(arsenalAnimEnabled) || isNil QGVAR(arsenalDummy) || {isNull GVAR(arsenalDummy)}) exitWith {};

	GVAR(arsenalDummy) switchMove (switch (_this # 1) do {
		case 2002 : {"amovpercmstpsraswrfldnon"};
		case 2004 : {"amovpercmstpsraswpstdnon"};
		case 2006 : {"amovpercmstpsraswlnrdnon"};
		default {"amovpercmstpsnonwnondnon"};
	});
}] call CBA_fnc_addEventHandler;

// Arsenal idle animations
["ace_arsenal_leftPanelFilled",{
	params ["_display","_leftIDC","_rightIDC"];

	if (!GVAR(arsenalAnimEnabled)) exitWith {};

	private _unit = ace_arsenal_center;
	if (isNil "_unit" || {isNull _unit}) exitWith {};

	if !(_leftIDC in [2002,2004]) then {
		_leftIDC = selectRandom [2002,_leftIDC];
	};

	private _animation = _leftIDC call FUNC(getArsenalAnimation);

	_unit setVariable [QGVAR(arsenalAnim),_animation];
	_unit setVariable [QGVAR(arsenalAnimIDC),_leftIDC];
	_unit switchMove "";

	if (isNil {_unit getVariable QGVAR(arsenalAnimEHID)}) then {
		_unit setVariable [QGVAR(arsenalAnimEHID),_unit addEventHandler ["AnimDone",{
			params ["_unit","_finishedAnim"];
			
			private _IDC = _unit getVariable [QGVAR(arsenalAnimIDC),-1];
			private _animation = if (_IDC == 2002) then {
				// Smooth rifle transitions
				private _animation = _finishedAnim;
				
				while {
					_animation = _IDC call FUNC(getArsenalAnimation);
					_animation == _finishedAnim
				} do {};

				_animation
			} else {
				// Repeat
				_unit getVariable [QGVAR(arsenalAnim),""];
			};

			_unit switchMove _animation;
			_unit playMoveNow _animation;
		}]];
	};

	_unit switchMove _animation;
	_unit playMoveNow _animation;
}] call CBA_fnc_addEventHandler;

["ace_arsenal_displayClosed",{
	private _unit = ace_arsenal_center;
	if (isNil "_unit" || {isNull _unit}) exitWith {};

	_unit removeEventHandler ["AnimDone",_unit getVariable [QGVAR(arsenalAnimEHID),-1]];
	_unit setVariable [QGVAR(arsenalAnimEHID),nil];
	_unit setVariable [QGVAR(arsenalAnimIDC),nil];
	_unit setVariable [QGVAR(arsenalAnim),nil];
	_unit switchMove "";
}] call CBA_fnc_addEventHandler;

// F1 key arsenal animation reset
["ace_arsenal_displayOpened",{
	params ["_display"];

	_display displayAddEventHandler ["KeyDown",{
		if (_this # 1 isEqualTo 59) then {
			private _animation = switch (ace_arsenal_currentLeftPanel) do {
				case 2002 : {"amovpercmstpsraswrfldnon"};
				case 2004 : {"amovpercmstpsraswpstdnon"};
				case 2006 : {"amovpercmstpsraswlnrdnon"};
				default {"amovpercmstpsnonwnondnon"};
			};
			
			ace_arsenal_center setVariable [QGVAR(arsenalAnim),_animation];
			ace_arsenal_center switchMove _animation;
		};

		false
	}];
}] call CBA_fnc_addEventHandler;
