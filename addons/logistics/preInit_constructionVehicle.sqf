[
	QGVAR(visualAid),
	"LIST",
	[LSTRING(visualAidName),LSTRING(visualAidInfo)],
	[LSTRING(category),LSTRING(construction)],
	[[0,1,2,3],[LSTRING(off),LSTRING(flashingAll),LSTRING(flashingSeq),LSTRING(static)],3],
	false,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(flashingFrequency),
	"SLIDER",
	[LSTRING(flashingFrequencyName),LSTRING(flashingFrequencyInfo)],
	[LSTRING(category),LSTRING(construction)],
	[0.1,2,0.4,1],
	false,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(nudgeSizeCoef),
	"SLIDER",
	[LSTRING(nudgeSizeCoefName),LSTRING(nudgeSizeCoefInfo)],
	[LSTRING(category),LSTRING(construction)],
	[0,3,0.3,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

GVAR(constructionBoxes) = [];

[QGVAR(constructionVehicleAdded),{
	params ["_vehicle","_maxBudget"];

	[_vehicle,0,["ACE_MainActions"],
		[QGVAR(construction),LLSTRING(construction),QPATHTOF(data\hammer.paa),{},{true},{},[],nil,nil,nil,{
			params ["_vehicle","","","_actionData"];

			_actionData set [1,format [LLSTRING(constructionFormat),_vehicle getVariable [QGVAR(constructionBudget),0]]];
			_actionData set [5,{
				private _vehicle = _this # 0;				
				private _actions = [];

				{
					_x params ["_class","_name","_cost","_buildTime","_initFnc"];

					_actions pushBack [[
						format ["%1_%2_%3",QGVAR(construction),_class,_forEachIndex],
						_name,
						"",
						FUNC(constructionAction),
						{true},
						{},
						_x
					] call ace_interact_menu_fnc_createAction,[],_vehicle];
				} forEach (_vehicle getVariable [QGVAR(constructionInventory),[]]);

				_actions
			}];
		}] call ace_interact_menu_fnc_createAction
	] call ace_interact_menu_fnc_addActionToObject;
}] call CBA_fnc_addEventHandler;

[QGVAR(constructionPlaced),FUNC(constructionPlaced)] call CBA_fnc_addEventHandler;

[QGVAR(objectBuilt),{
	params ["_object","_builder"];

	private _distance = 2.5 max (sizeOf typeOf _object * 0.65);
	private _actionTrees = ace_interact_menu_actNamespace getVariable [typeOf _object,[]];
	
	// Create a custom ace main action with extra distance if it doesn't already exist
	if (isNil {[_actionTrees,["ACE_MainActions"]] call ace_interact_menu_findActionNode}) then {
		[_object,0,[],
			["ACE_MainActions",localize "STR_ACE_Interaction_MainAction","",{},{true},{},[],nil,_distance] call ace_interact_menu_fnc_createAction
		] call ace_interact_menu_fnc_addActionToObject;
	};

	[_object,0,["ACE_MainActions"],
		[QGVAR(constructionActions),LLSTRING(constructionActions),QPATHTOF(data\hammer.paa),{},{true},{},[],nil,_distance] call ace_interact_menu_fnc_createAction
	] call ace_interact_menu_fnc_addActionToObject;

	[_object,0,["ACE_MainActions",QGVAR(constructionActions)],
		[QGVAR(constructionRemove),LLSTRING(remove),"\A3\3DEN\Data\cfg3den\history\deleteitems_ca.paa",{
			[LLSTRING(removing),5,{true},{
				(_this # 0) params ["_object","_unit"];

				// CBA Event
				[QGVAR(objectRemoved),[_object,_unit]] call CBA_fnc_globalEvent;

				// Delete object next frame
				[{
					deleteVehicleCrew _this;
					deleteVehicle _this;
				},_object] call CBA_fnc_execNextFrame;
			},{},_this] spawn CBA_fnc_progressBar;
		},{true},{},[],nil,_distance] call ace_interact_menu_fnc_createAction
	] call ace_interact_menu_fnc_addActionToObject;

	[_object,0,["ACE_MainActions",QGVAR(constructionActions)],
		[QGVAR(constructionNudge),LLSTRING(nudge),"\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\getin_ca.paa",{[{
			params ["_object","_unit"];

			GVAR(isPlacing) = PLACE_WAITING;

			["CONFIRM","CANCEL"] call ace_interaction_fnc_showMouseHint;
			private _mouseClickID = [_unit,"DefaultAction",{GVAR(isPlacing) == PLACE_WAITING},{GVAR(isPlacing) = PLACE_APPROVE}] call ace_common_fnc_addActionEventHandler;

			addMissionEventHandler ["Draw3D",{
				if (GVAR(isPlacing) != PLACE_WAITING) exitWith {
					removeMissionEventHandler [_thisEvent,_thisEventHandler];
				};

				_thisArgs params ["_unit","_object"];
				
				private _reach = ((AGLToASL positionCameraToWorld [0,0,0]) vectorDistance (_unit modelToWorldVisualWorld (_unit selectionPosition "Head"))) + 2;
				private _camPosASL = ATLToASL positionCameraToWorld [0,0,0];
				private _targetPosASL = ATLToASL positionCameraToWorld [0,0,_reach];
				private _ix = lineIntersectsSurfaces [_camPosASL,_targetPosASL,_unit,cameraOn,true,1,"GEOM","FIRE"];
				
				if (_ix isNotEqualTo [] && {_ix # 0 # 2 == _object}) then {
					drawIcon3D ["\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\interact_ca.paa",[1,1,1,1],ASLToAGL (_ix # 0 # 0),1,1,0];
				};
			},[_unit,_object]];

			[{GVAR(isPlacing) != PLACE_WAITING},{
				params ["","","_object","_unit","_mouseClickID"];

				call ace_interaction_fnc_hideMouseHint;
				[_unit,"DefaultAction",_mouseClickID] call ace_common_fnc_removeActionEventHandler;

				if (GVAR(isPlacing) == PLACE_CANCEL) exitWith {};

				private _reach = ((AGLToASL positionCameraToWorld [0,0,0]) vectorDistance (_unit modelToWorldVisualWorld (_unit selectionPosition "Head"))) + 2;
				private _camPosASL = ATLToASL positionCameraToWorld [0,0,0];
				private _targetPosASL = ATLToASL positionCameraToWorld [0,0,_reach];
				private _ix = lineIntersectsSurfaces [_camPosASL,_targetPosASL,_unit,cameraOn,true,1,"GEOM","FIRE"];

				if (_ix isEqualTo [] || {_ix # 0 # 2 != _object}) exitWith {
					LLSTRING(outOfReach) call EFUNC(common,hint);
				};

				[LLSTRING(nudging),1.5 max (sizeOf typeOf _object * GVAR(nudgeSizeCoef)),{true},{
					(_this # 0) params ["_object","_unit","_ixPosASL"];

					private _pos = getPosWorldVisual _object;
					private _cachedPos = _object getVariable [QGVAR(constructionPos),[0,0,0]];
					if (_pos distance _cachedPosASL < 2) then {_pos = _cachedPosASL}; // precision fix

					private _rotation = linearConversion [0,sizeOf typeOf _object / 2,_ixPosASL distance2D getPosASLVisual _object,0,10,true];
					private _vector = vectorDir _unit;
					private _newPos = _pos vectorAdd ([_vector # 0,_vector # 1,0] vectorMultiply 0.2);

					_object setDir getDirVisual _object + ([-_rotation,_rotation] select (_unit getRelDir _object < 180));
					_object setPosWorld _newPos;
					_object setVariable [QGVAR(constructionPos),_newPos,true];
					[QGVAR(objectNudged),[_object,_unit]] call CBA_fnc_globalEvent;
				},{},[_object,_unit,_ix # 0 # 0]] spawn CBA_fnc_progressBar;
			},[_camPosASL,_targetPosASL,_object,_unit,_mouseClickID]] call CBA_fnc_waitUntilAndExecute;
			
		},_this] call CBA_fnc_execNextFrame},{true},{},[],nil,_distance] call ace_interact_menu_fnc_createAction
	] call ace_interact_menu_fnc_addActionToObject;
}] call CBA_fnc_addEventHandler;

