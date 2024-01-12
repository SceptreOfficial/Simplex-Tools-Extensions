#include "script_component.hpp"
#include "\a3\ui_f_curator\ui\defineresincldesign.inc"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		_logic getVariable ["ObjectArea",[]] params ["_width","_length","_direction","_isRectangle"];

		[FUNC(populate),[
			[getPos _logic,_width,_length,_direction,_isRectangle],
			(_logic getVariable "UnitClasses") call EFUNC(common,parseArray),
			(_logic getVariable "VehicleClasses") call EFUNC(common,parseArray),
			[
				parseNumber (_logic getVariable "Pedestrians"),
				parseNumber (_logic getVariable "Driving"),
				parseNumber (_logic getVariable "Parked")
			],
			[],
			{},
			[],
			false,
			[0.3,0.5,0.5]
		],2] call CBA_fnc_waitAndExecute;
	} else {
		GVAR(blacklistTempMarkers) = GVAR(blacklist) apply {
			private _marker = str _x + str CBA_missionTime;
			createMarkerLocal [_marker,_x # 0];
			_marker setMarkerShapeLocal (["ELLIPSE","RECTANGLE"] select (_x # 4));
			_marker setMarkerSizeLocal [_x # 1,_x # 2];
			_marker setMarkerDirLocal (_x # 3);
			_marker setMarkerBrushLocal "DiagGrid";
			_marker setMarkerColorLocal "ColorBlack";
			_marker setMarkerAlphaLocal 0.8;
			_marker
		};

		[[36,20],[
			[[0,0,36,1],"STRUCTUREDTEXT",format ["<t align='center'>%1</t>",LLSTRING(ModulePopulateName)],EGVAR(SDF,profileRGBA)],
			[[18,1,18,19],"MAP","",[[],[[getPos _logic,100,100,0,true]],[],1]],
			[[6,1,12,1],"EDITBOX","Units",GVAR(unitClassesStr),false],
			[[6,2,12,1],"EDITBOX","Vehicles",GVAR(vehClassesStr),false],
			[[6,3,12,1],"SLIDER","Pedestrians",[[0,100,0],0],false],
			[[6,4,12,1],"SLIDER","Driving",[[0,50,0],0],false],
			[[6,5,12,1],"SLIDER","Parked",[[0,50,0],0],false],
			[[6,6,12,1],"COMBOBOX","Locality",[[LLSTRING(Local),LLSTRING(Server)] + (EGVAR(common,headlessClients) apply {LLSTRING(HC) + str _x}),0],false],
			[[0,1,6,1],"TEXT",LLSTRING(SettingName_unitClassesStr)],
			[[0,2,6,1],"TEXT",LLSTRING(SettingName_vehClassesStr)],
			[[0,3,6,1],"TEXT",LLSTRING(SettingName_pedestrianCount)],
			[[0,4,6,1],"TEXT",LLSTRING(SettingName_driverCount)],
			[[0,5,6,1],"TEXT",LLSTRING(SettingName_parkedCount)],
			[[0,6,6,1],"TEXT",[LLSTRING(Locality),LLSTRING(LocalityGroupsInfo)]],
			[[0,19,9,1],"BUTTON",LELSTRING(sdf,cancel),{{
				{deleteMarkerLocal _x} forEach GVAR(blacklistTempMarkers);
			} call EFUNC(SDF,close)}],
			[[9,19,9,1],"BUTTON",LELSTRING(sdf,confirm),{[{
				{deleteMarkerLocal _x} forEach GVAR(blacklistTempMarkers);

				params ["_values","_pos"];
				_values params ["","_area","_unitClasses","_vehClasses","_pedestrians","_drivers","_parked","_localitySelection"];

				_unitClasses = _unitClasses call EFUNC(common,parseArray);
				_vehClasses = _vehClasses call EFUNC(common,parseArray);

				private _params = [_area,_unitClasses,_vehClasses,[_pedestrians,_drivers,_parked],[],{},[],false,[0.2,0.2,0.3]];

				if (_localitySelection > 0) then {
					[QGVAR(localityExec),[_localitySelection,_params,QFUNC(populate)]] call CBA_fnc_serverEvent;
				} else {
					_params call FUNC(populate);
				};

				[objNull,LLSTRING(ModulePopulate_AreaPopulated)] call BIS_fnc_showCuratorFeedbackMessage;
			},true] call EFUNC(SDF,close)}]
		],{{deleteMarkerLocal _x} forEach GVAR(blacklistTempMarkers)}] call EFUNC(SDF,dialog);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_directCall;
