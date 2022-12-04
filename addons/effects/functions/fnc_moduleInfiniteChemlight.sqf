#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		private _class = _logic getVariable ["Color","Chemlight_blue_Infinite"],
		private _object = _class createVehicle [0,0,0];
		_object allowDamage false;
		_object attachTo [_logic,[0,0,0]];
		[QGVAR(infiniteItemCreated),[_object,_logic]] call CBA_fnc_globalEvent;
	} else {
		[LLSTRING(moduleInfiniteChemlightName),[
			["COMBOBOX",[LLSTRING(ColorName),LLSTRING(ColorInfo)],[[
				[LLSTRING(Blue),"","\a3\Modules_F_Curator\Data\portraitchemlightblue_ca.paa"],
				[LLSTRING(Green),"","\a3\Modules_F_Curator\Data\portraitchemlightgreen_ca.paa"],
				[LLSTRING(Red),"","\a3\Modules_F_Curator\Data\portraitchemlightred_ca.paa"],
				[LLSTRING(Yellow),"","\a3\Modules_F_Curator\Data\portraitchemlightyellow_ca.paa"]
			],0,[
				"Chemlight_blue_Infinite",
				"Chemlight_green_Infinite",
				"Chemlight_red_Infinite",
				"Chemlight_yellow_Infinite"
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
