#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		private _class = _logic getVariable ["Color","SmokeShell_Infinite"],
		private _object = _class createVehicle [0,0,0];
		_object allowDamage false;
		_object attachTo [_logic,[0,0,0]];
		[QGVAR(infiniteItemCreated),[_object,_logic]] call CBA_fnc_globalEvent;
	} else {
		[LLSTRING(moduleInfiniteSmokeName),[
			["COMBOBOX",[LLSTRING(ColorName),LLSTRING(ColorInfo)],[[
				[LLSTRING(White),"","\a3\Modules_F_Curator\Data\portraitSmokeWhite_ca.paa"],
				[LLSTRING(Blue),"","\a3\Modules_F_Curator\Data\portraitSmokeBlue_ca.paa"],
				[LLSTRING(Green),"","\a3\Modules_F_Curator\Data\portraitSmokeGreen_ca.paa"],
				[LLSTRING(Purple),"","\a3\Modules_F_Curator\Data\portraitSmokePurple_ca.paa"],
				[LLSTRING(Red),"","\a3\Modules_F_Curator\Data\portraitSmokeRed_f_ca.paa"],
				[LLSTRING(Orange),"","\a3\Modules_F_Curator\Data\portraitSmokeOrange_ca.paa"],
				[LLSTRING(Yellow),"","\a3\Modules_F_Curator\Data\portraitSmokeYellow_ca.paa"]
			],0,[
				"SmokeShell_Infinite",
				"SmokeShellBlue_Infinite",
				"SmokeShellGreen_Infinite",
				"SmokeShellPurple_Infinite",
				"SmokeShellRed_Infinite",
				"SmokeShellOrange_Infinite",
				"SmokeShellYellow_Infinite"
			]],false]
		],[{
			params ["_values","_logic"];
			_values params ["_class"];

			private _object = _class createVehicle [0,0,0];
			_object allowDamage false;
			_object attachTo [_logic,[0,0,0]];
			[QGVAR(infiniteItemCreated),[_object,_logic]] call CBA_fnc_globalEvent;
		},{deleteVehicle (_this # 1)}],_logic] call EFUNC(sdf,dialog);
	};
},_this] call CBA_fnc_execNextFrame;
