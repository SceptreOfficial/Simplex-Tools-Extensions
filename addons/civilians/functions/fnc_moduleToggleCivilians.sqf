#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

deleteVehicle _logic;

[{
	if (GVAR(ambientCivilians)) then {
		[QGVAR(toggle),[0,FUNC(toggleCivilians),QGVAR(ambientCivilians),QGVAR(civiliansRunner)]] call CBA_fnc_serverEvent;
		[objNull,LLSTRING(Module_ToggleCivilians_Disabled)] call BIS_fnc_showCuratorFeedbackMessage;
	} else {
		[LLSTRING(Module_ToggleCivilians_Title),[
			["COMBOBOX",[LLSTRING(Locality),LLSTRING(LocalityToggleInfo)],[[LLSTRING(Server)] + (EGVAR(common,headlessClients) apply {LLSTRING(HC) + str _x}),0],false]
		],{
			(_this # 0) params ["_localitySelection"];
			[QGVAR(toggle),[_localitySelection,FUNC(toggleCivilians),QGVAR(ambientCivilians),QGVAR(civiliansRunner)]] call CBA_fnc_serverEvent;
			[objNull,LLSTRING(Module_ToggleCivilians_Enabled)] call BIS_fnc_showCuratorFeedbackMessage;
		},_pos] call EFUNC(SDF,dialog);
	};
}] call CBA_fnc_directCall;
