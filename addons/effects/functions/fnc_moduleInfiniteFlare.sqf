#include "..\script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		private _class = _logic getVariable ["Color","F_40mm_White_Infinite"];
		private _object = _class createVehicle [0,0,0];
		_object allowDamage false;
		_object attachTo [_logic,[0,0,0]];
		[QGVAR(infiniteItemCreated),[_object,_logic]] call CBA_fnc_globalEvent;
	} else {
		[LLSTRING(moduleInfiniteFlareName),[
			["COMBOBOX",[LLSTRING(ColorName),LLSTRING(ColorInfo)],[[
				[LLSTRING(White),"","\a3\Modules_F_Curator\Data\portraitflarewhite_ca.paa"],
				[LLSTRING(Green),"","\a3\Modules_F_Curator\Data\portraitflaregreen_ca.paa"],
				[LLSTRING(Red),"","\a3\Modules_F_Curator\Data\portraitflarered_ca.paa"],
				[LLSTRING(Yellow),"","\a3\Modules_F_Curator\Data\portraitflareyellow_ca.paa"]
			],0,[
				"F_40mm_White_Infinite",
				"F_40mm_Green_Infinite",
				"F_40mm_Red_Infinite",
				"F_40mm_Yellow_Infinite"
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
