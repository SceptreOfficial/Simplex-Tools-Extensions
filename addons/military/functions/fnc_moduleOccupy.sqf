#include "script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};
	
[{
	params ["_logic","_synced"];
	
	private _pos = getPos _logic;
	deleteVehicle _logic;

	GVAR(density) = [[],[],[],[]];
	GVAR(classList) = [[],[]];

	[[36,26],[
		[[0,0,36,1],"STRUCTUREDTEXT","<t align='center'>Occupy</t>",EGVAR(SDF,profileRGBA)],
		[[18,1,18,25],"MAP","",[[],[[_pos,100,100,0,true]],[],1]],
		[[0,1,18,24],"GROUP","",[
			[[0,0,6,1],"TEXT","Side:"],
			[[6,0,12,1],"COMBOBOX","Side",[[["OPFOR","","",[1,0,0,1]],["BLUFOR","","",[0,0,1,1]],["INDEPENDENT","","",[0,1,0,1]]],0],false,{
				params ["_sideSelection"];
				
				private _classesTree = [];
				private _cfgFactions = configFile >> "CfgFactionClasses";
				private _factionHash = (uiNamespace getVariable QGVAR(sideHash)) get _sideSelection;
				
				{
					private _classes = (_factionHash get _x) apply {[_x,"",_y]};
					_classes sort true;
					_classesTree pushBack [getText (_cfgFactions >> _x >> "displayName"),"",_classes];

					//private _categoryKeys = keys _categoryHash;
					//_categoryKeys sort true;
					//_classesTree pushBack [
					//	getText (_cfgFactions >> _x >> "displayName"),"",_categoryKeys apply {[_x,"",_categoryHash get _x]}
					//];
				} forEach keys _factionHash;
				
				_classesTree sort true;
				
				[5,[_classesTree]] call EFUNC(SDF,setValueData);
				[17,[(GVAR(occupationPresets) # _sideSelection) apply {_x # 0},0]] call EFUNC(SDF,setValueData);
			}],
			[[0,1,18,8],"TREE","AllClasses",[[],nil,{_this call ([6] call EFUNC(SDF,getValue))}]],
			[[0,9,9,1],"BUTTON","Add unit type",{
				private _class = 5 call EFUNC(SDF,getValue);

				if (_class isEqualTo "") exitWith {};

				private _classCfg = configFile >> "CfgVehicles" >> _class;
				private _picture = getText (_classCfg >> "picture");

				if (toLower _picture in ["picturething","picturerepair","pictureheal","pictureexplosive"]) then {_picture = ""};

				private _index = GVAR(classList) # 0 pushBack [[getText (_classCfg >> "displayName"),_picture]];
				GVAR(classList) # 1 pushBack _class;
				[8,[GVAR(classList) # 0,_index]] call EFUNC(SDF,setValueData);
			}],
			[[9,9,9,1],"BUTTON","Remove unit type",{
				private _classSelection = 8 call EFUNC(SDF,getValue);
				GVAR(classList) # 0 deleteAt _classSelection;
				GVAR(classList) # 1 deleteAt _classSelection;
				[8,[GVAR(classList) # 0,_classSelection]] call EFUNC(SDF,setValueData);
			}],
			[[0,11,18,7],"LISTNBOX","ClassList",[[],nil,[],{_this call (7 call EFUNC(SDF,getValue))}]],
			[[0,18,2,1],"TEXT",["Min:","Minimum amount of groups to randomly spawn"]],
			[[2,18,7,1],"SLIDER","Min",[[0,25,0],1]],
			[[9,18,2,1],"TEXT",["Max:","Maximum amount of groups to randomly spawn"]],
			[[11,18,7,1],"SLIDER","Max",[[1,25,0],1]],
			[[0,19,7,1],"BUTTON","Add config",{
				[10 call EFUNC(SDF,getValue),12 call EFUNC(SDF,getValue)] params ["_min","_max"];
				15 call EFUNC(SDF,getValue) params ["_densitySelection","_groupSelection"];
				
				(GVAR(density) # _densitySelection) pushBack [+(GVAR(classList) # 1),[_min,_max]];

				[15,[_densitySelection],[format [
					"%1 / %2 : %3",
					_min,
					_max,
					GVAR(classList) # 0 apply {_x # 0 # 0}
				]]] call EFUNC(SDF,treeAdd);

				([15] call EFUNC(sdf,getControl)) tvExpand [_densitySelection];

			}],
			[[7,19,7,1],"BUTTON","Remove config",{
				15 call EFUNC(SDF,getValue) params ["_densitySelection","_groupSelection"];

				(GVAR(density) # _densitySelection) deleteAt _groupSelection;

				[15,[_densitySelection,_groupSelection]] call EFUNC(SDF,treeDelete);
			}],
			[[0,20,18,5],"TREE","Density config",[[
				["Patrol Density","",[]],
				["Garrison Density","",[]],
				["Sentry Density","",[]],
				["QRF Density","",[]]
			],true]],
			[[0,25,6,1],"TEXT","Side presets"],
			[[6,25,12,1],"COMBOBOX","Presets",[[],0],false,{
				params ["_presetSelection"];
				
				private _presets = GVAR(occupationPresets) # (4 call EFUNC(SDF,getValue));
				
				if (_presets isEqualTo []) then {
					[18,[]] call EFUNC(SDF,setValueData);
				} else {
					[18,_presets # _presetSelection # 0] call EFUNC(SDF,setValueData);
				};
			}],
			[[0,26,18,1],"EDITBOX","Name",""],
			[[0,27,6,1],"BUTTON","Load",{
				[4 call EFUNC(SDF,getValue),17 call EFUNC(SDF,getValue)] params ["_sideSelection","_presetSelection"];

				if (_presetSelection == -1) exitWith {};

				GVAR(density) = +(GVAR(occupationPresets) # _sideSelection # _presetSelection # 1);
				
				[15,[[
					["Patrol Density","",[]],
					["Garrison Density","",[]],
					["Sentry Density","",[]],
					["QRF Density","",[]]
				],true]] call EFUNC(SDF,setValueData);

				private _cfgVehicles = configFile >> "CfgVehicles";

				{
					private _densitySelection = _forEachIndex;
					
					{
						_x params ["_classes","_minMax"];
						_minMax params ["_min","_max"];

						[15,[_densitySelection],[format [
							"%1 / %2 : %3",
							_min,
							_max,
							_classes apply {getText (_cfgVehicles >> _x >> "displayName")}
						]]] call EFUNC(SDF,treeAdd);
					} forEach _x;
				} forEach GVAR(density);

				tvExpandAll ([15] call EFUNC(sdf,getControl));
			}],
			[[6,27,6,1],"BUTTON","Save",{
				[4 call EFUNC(SDF,getValue),17 call EFUNC(SDF,getValue),18 call EFUNC(SDF,getValue)] params [
					"_sideSelection","_presetSelection","_newName"
				];

				if (_newName isEqualTo "") exitWith {};

				// Save new
				if (_presetSelection == -1) exitWith {
					(GVAR(occupationPresets) # _sideSelection) pushBack [_newName,+GVAR(density)];
					(GVAR(occupationPresets) # _sideSelection) sort true;

					private _names = (GVAR(occupationPresets) # _sideSelection) apply {_x # 0};
					[17,[_names,_names find _newName]] call EFUNC(SDF,setValueData);

					profileNamespace setVariable [QGVAR(occupationPresets),GVAR(occupationPresets)];
					saveProfileNamespace;
				};

				private _name = GVAR(occupationPresets) # _sideSelection # _presetSelection # 0;
				
				if (_name == _newName) then {
					// Overwrite
					(GVAR(occupationPresets) # _sideSelection) set [_presetSelection,[_name,+GVAR(density)]];
					[17,[(GVAR(occupationPresets) # _sideSelection) apply {_x # 0},_presetSelection]] call EFUNC(SDF,setValueData);

					profileNamespace setVariable [QGVAR(occupationPresets),GVAR(occupationPresets)];
					saveProfileNamespace;
				} else {
					// Save new
					(GVAR(occupationPresets) # _sideSelection) pushBack [_newName,+GVAR(density)];
					(GVAR(occupationPresets) # _sideSelection) sort true;

					private _names = (GVAR(occupationPresets) # _sideSelection) apply {_x # 0};
					[17,[_names,_names find _newName]] call EFUNC(SDF,setValueData);

					profileNamespace setVariable [QGVAR(occupationPresets),GVAR(occupationPresets)];
					saveProfileNamespace;
				};
			}],
			[[12,27,6,1],"BUTTON","Delete",{
				[4 call EFUNC(SDF,getValue),17 call EFUNC(SDF,getValue)] params ["_sideSelection","_presetSelection"];

				if (_presetSelection == -1) exitWith {};

				(GVAR(occupationPresets) # _sideSelection) deleteAt _presetSelection;
				[17,[(GVAR(occupationPresets) # _sideSelection) apply {_x # 0},_presetSelection - 1]] call EFUNC(SDF,setValueData);

				profileNamespace setVariable [QGVAR(occupationPresets),GVAR(occupationPresets)];
				saveProfileNamespace;
			}],
			[[14,19,2,1],"BUTTON",format ["<img image='%1'/>",ICON_INHERIT],{
				15 call EFUNC(SDF,getValue) params ["_densitySelection","_groupSelection"];

				GVAR(classList) = [[],[]];

				private _cfgVehicles = configFile >> "CfgVehicles";

				{
					private _picture = getText (_cfgVehicles >> _x >> "picture");
					
					if (toLower _picture in ["picturething","picturerepair","pictureheal","pictureexplosive"]) then {_picture = ""};
					
					GVAR(classList) # 0 pushBack [[getText (_cfgVehicles >> _x >> "displayName"),_picture]];
					GVAR(classList) # 1 pushBack _x;
				} forEach (GVAR(density) # _densitySelection # _groupSelection # 0);

				[8,[GVAR(classList) # 0,0]] call EFUNC(SDF,setValueData);
				[10,[[0,25,0],GVAR(density) # _densitySelection # _groupSelection # 1 # 0]] call EFUNC(SDF,setValueData);
				[12,[[0,25,0],GVAR(density) # _densitySelection # _groupSelection # 1 # 1]] call EFUNC(SDF,setValueData);
			}],
			[[16,19,2,1],"BUTTON",format ["<img image='%1'/>",ICON_TRASH],{
				GVAR(density) = [[],[],[],[]];
				[15,[[
					["Patrol Density","",[]],
					["Garrison Density","",[]],
					["Sentry Density","",[]],
					["QRF Density","",[]]
				],true]] call EFUNC(SDF,setValueData);
			}],
			[[6,29,12,1],"SLIDER","PatrolCoef",[[0,1,2],1],false],
			[[6,30,12,1],"SLIDER","GarrisonCoef",[[0,1,2],1],false],
			[[6,31,12,1],"SLIDER","SentryCoef",[[0,1,2],1],false],
			[[6,32,12,1],"SLIDER","QRFCoef",[[0,1,2],1],false],
			[[6,33,12,1],"SLIDER","RequestDist",[[0,10000,0],800],false],
			[[6,34,12,1],"SLIDER","ResponseDist",[[0,10000,0],800],false],
			[[6,35,12,1],"SLIDER","QRFRequestDist",[[0,10000,0],1600],false],
			[[6,36,12,1],"SLIDER","QRFResponseDist",[[0,10000,0],1600],false],
			[[6,37,12,1],"EDITBOX","PatrolRandom","[125,200,250]",false],
			[[6,38,12,1],"COMBOBOX","Locality",[["Local","Server"] + (EGVAR(common,headlessClients) apply {"HC: " + str _x}),0],false],
			[[0,29,6,1],"TEXT","Patrol coefficient"],
			[[0,30,6,1],"TEXT","Garrison coefficient"],
			[[0,31,6,1],"TEXT","Sentry coefficient"],
			[[0,32,6,1],"TEXT","QRF coefficient"],
			[[0,33,6,1],"TEXT",["Request distance","Group(s) will request assistance from other groups within this distance"]],
			[[0,34,6,1],"TEXT",["Response distance","Group(s) will only respond to assistance requests that are within this distance"]],
			[[0,35,6,1],"TEXT",["QRF request distance","Group(s) will request assistance from other groups within this distance"]],
			[[0,36,6,1],"TEXT",["QRF response distance","Group(s) will only respond to assistance requests that are within this distance"]],
			[[0,37,6,1],"TEXT",["Patrol radius random","Random patrol radii in format: [min,mid,max]"]],
			[[0,38,6,1],"TEXT",["Locality","Spawns groups on specified machine"]],
			[[0,28,18,1],"TEXT","Occupation parameters",EGVAR(SDF,profileRGBA)],
			[[0,10,18,1],"TEXT","Group config"]
		]],
		[[0,25,9,1],"BUTTON","CANCEL",EFUNC(SDF,close)],
		[[9,25,9,1],"BUTTON","CONFIRM",{[{
			_values params ["","_area","","","_sideSelection"];
			+GVAR(density) params ["_patrolDensity","_garrisonDensity","_sentryDensity","_QRFDensity"];
			(_values select [24,10]) params [
				"_patrolCoef",
				"_garrisonCoef",
				"_sentryCoef",
				"_QRFCoef",
				"_requestDistance",
				"_responseDistance",
				"_QRFRequestDistance",
				"_QRFResponseDistance",
				"_patrolRadiusRandom",
				"_localitySelection"
			];

			GVAR(densityCache) = +GVAR(density);

			private _occupyParams = [
				_area,
				[east,west,independent] # _sideSelection,
				_patrolDensity,
				_garrisonDensity,
				_sentryDensity,
				_QRFDensity,
				[_patrolCoef,_garrisonCoef,_sentryCoef,_QRFCoef],
				_requestDistance,
				_responseDistance,
				_QRFRequestDistance,
				_QRFResponseDistance,
				parseSimpleArray _patrolRadiusRandom,
				player
			];

			if (_localitySelection > 0) then {
				[QGVAR(localityExec),[_localitySelection,_occupyParams,QFUNC(occupy)]] call CBA_fnc_serverEvent;
			} else {
				_occupyParams call FUNC(occupy);
			};
		},true] call EFUNC(SDF,close)}]
	]] call EFUNC(SDF,dialog);

	if (isNil QGVAR(densityCache)) exitWith {};

	GVAR(density) = +GVAR(densityCache);

	private _cfgVehicles = configFile >> "CfgVehicles";

	{
		private _densitySelection = _forEachIndex;
		
		{
			_x params ["_classes","_minMax"];
			_minMax params ["_min","_max"];

			[15,[_densitySelection],[format [
				"%1 / %2 : %3",
				_min,
				_max,
				_classes apply {getText (_cfgVehicles >> _x >> "displayName")}
			]]] call EFUNC(SDF,treeAdd);
		} forEach _x;
	} forEach GVAR(density);
},_this] call CBA_fnc_directCall;
