#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	private _pos = getPos _logic;
	deleteVehicle _logic;

	GVAR(blacklistTempMarkers) = GVAR(blacklist) apply {
		private _marker = str _x + str CBA_missionTime;
		createMarkerLocal [_marker,_x # 0];
		_marker setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select (_x # 4));
		_marker setMarkerSizeLocal [_x # 1,_x # 2];
		_marker setMarkerDirLocal (_x # 3);
		_marker setMarkerBrushLocal "FDiagonal";
		_marker setMarkerColorLocal "ColorWhite";
		_marker setMarkerAlphaLocal 0.8;
		_marker
	};

	[[36,32],[
		[[0,0,36,1],"STRUCTUREDTEXT",format ["<t align='center'>%1</t>",LLSTRING(Module_BlacklistArea)],EGVAR(SDF,profileRGBA)],
		[[0,1,36,30],"MAP","",[[],[[_pos,100,100,0,true]],[],1]],
		[[0,31,18,1],"BUTTON",localize "STR_SDF_CANCEL",{{
			{deleteMarkerLocal _x} forEach GVAR(blacklistTempMarkers);
		} call EFUNC(SDF,close)}],
		[[18,31,18,1],"BUTTON",localize "STR_SDF_CONFIRM",{[{
			{deleteMarkerLocal _x} forEach GVAR(blacklistTempMarkers);

			params ["_values","_pos"];
			_values params ["","_area"];

			[QGVAR(addBlacklist),[_area]] call CBA_fnc_serverEvent;

			[objNull,LLSTRING(Module_BlacklistArea_Added)] call BIS_fnc_showCuratorFeedbackMessage;
		},true] call EFUNC(SDF,close)}]
	],{{deleteMarkerLocal _x} forEach GVAR(blacklistTempMarkers)}] call EFUNC(SDF,dialog);

	[1,"Shape",{},{[1,!((1 call EFUNC(sdf,getValue)) # 4)] call EFUNC(sdf,mapAreaShape)}] call EFUNC(sdf,mapAreaSpecial);
},_this] call CBA_fnc_directCall;
