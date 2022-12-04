#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

deleteVehicle _logic;

[{
	if (GVAR(ambientAircraft)) then {
		[QGVAR(toggle),[0,FUNC(toggleAircraft),QGVAR(ambientAircraft),QGVAR(aircraftRunner)]] call CBA_fnc_serverEvent;
		[objNull,LLSTRING(Module_ToggleAircraft_Disabled)] call BIS_fnc_showCuratorFeedbackMessage;
	} else {
		[LLSTRING(Module_ToggleAircraft_Title),[
			["COMBOBOX",[LLSTRING(Locality),LLSTRING(LocalityToggleInfo)],[[LLSTRING(Server)] + (EGVAR(common,headlessClients) apply {LLSTRING(HC) + str _x}),0],false]
		],{
			(_this # 0) params ["_localitySelection"];
			[QGVAR(toggle),[_localitySelection,FUNC(toggleAircraft),QGVAR(ambientAircraft),QGVAR(aircraftRunner)]] call CBA_fnc_serverEvent;
			[objNull,LLSTRING(Module_ToggleAircraft_Enabled)] call BIS_fnc_showCuratorFeedbackMessage;
		},_pos] call EFUNC(SDF,dialog);
	};
}] call CBA_fnc_directCall;
