#include "script_component.hpp"

// "Go Away" action
["CAManBase",1,["ACE_SelfActions"],[
	QGVAR(shoo),
	LLSTRING(GoAwayAction),
	"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa",
	{
		"ace_gestures_point" call ace_gestures_fnc_playSignal;
		
		private _dir = getDirVisual _player;
		private _center = _player getPos [18,_dir];
		private _area = [_center,10,18,_dir,false];

		{
			if (side _x isEqualTo civilian && {_x inArea _area}) then {
				[QGVAR(doMove),[_x,_x getPos [150 + random 150,_dir + random [-60,0,60]]],_x] call CBA_fnc_targetEvent;
			};
		} forEach (_center nearEntities 20);
	},
	{GVAR(goAwayAction)}
] call ace_interact_menu_fnc_createAction,true] call ace_interact_menu_fnc_addActionToClass;

// Ambient aircraft
if (isServer && GVAR(autoStartAircraft)) then {
	[{
		[QGVAR(toggle),[0,FUNC(toggleAircraft),QGVAR(ambientAircraft),QGVAR(aircraftRunner)]] call CBA_fnc_serverEvent;
	},[],5] call CBA_fnc_waitAndExecute;
};

// Ambient civ auto-start
if (isServer && GVAR(autoStart)) then {
	[{
		[QGVAR(toggle),[0,FUNC(toggleCivilians),QGVAR(ambientCivilians),QGVAR(civiliansRunner)]] call CBA_fnc_serverEvent;
	},[],5] call CBA_fnc_waitAndExecute;
};
