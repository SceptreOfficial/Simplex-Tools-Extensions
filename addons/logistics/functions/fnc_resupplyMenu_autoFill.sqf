#include "script_component.hpp"
#define SIDE_ICONS [ \
	"\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_west_ca.paa", \
	"\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_east_ca.paa", \
	"\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_guer_ca.paa", \
	"\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_civ_ca.paa" \
]
#define CHECK_ICONS [ \
	"\a3\3DEN\Data\Controls\ctrlCheckbox\textureUnchecked_ca.paa", \
	"\a3\3DEN\Data\Controls\ctrlCheckbox\textureChecked_ca.paa" \
]

private _ctrlMunitions = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MUNITIONS;
[_ctrlMunitions,"",1,true] call EFUNC(sdf,getCache);

private _ctrlMedical = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MEDICAL;
[_ctrlMedical,"",0,true] call EFUNC(sdf,getCache);

private _ctrlMagazineCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MAGAZINE_COUNT;
private _ctrlMagazineCountEdit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MAGAZINE_COUNT_EDIT;
[
	_ctrlMagazineCount,
	_ctrlMagazineCountEdit,
	[0,100,0],
	[_ctrlMagazineCount,"",missionNamespace getVariable [QGVAR(autoFillMagazineCount),20]] call EFUNC(sdf,getCache)
] call EFUNC(sdf,manageSlider);

private _ctrlUnderbarrelCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNDERBARREL_COUNT;
private _ctrlUnderbarrelCountEdit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNDERBARREL_COUNT_EDIT;
[
	_ctrlUnderbarrelCount,
	_ctrlUnderbarrelCountEdit,
	[0,100,0],
	[_ctrlUnderbarrelCount,"",missionNamespace getVariable [QGVAR(autoFillUnderbarrelCount),10]] call EFUNC(sdf,getCache)
] call EFUNC(sdf,manageSlider);

private _ctrlRocketCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_ROCKET_COUNT;
private _ctrlRocketCountEdit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_ROCKET_COUNT_EDIT;
[
	_ctrlRocketCount,
	_ctrlRocketCountEdit,
	[0,100,0],
	[_ctrlRocketCount,"",missionNamespace getVariable [QGVAR(autoFillRocketCount),10]] call EFUNC(sdf,getCache)
] call EFUNC(sdf,manageSlider);

private _ctrlThrowableCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_THROWABLE_COUNT;
private _ctrlThrowableCountEdit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_THROWABLE_COUNT_EDIT;
[
	_ctrlThrowableCount,
	_ctrlThrowableCountEdit,
	[0,100,0],
	[_ctrlThrowableCount,"",missionNamespace getVariable [QGVAR(autoFillThrowableCount),10]] call EFUNC(sdf,getCache)
] call EFUNC(sdf,manageSlider);

private _ctrlPlaceableCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PLACEABLE_COUNT;
private _ctrlPlaceableCountEdit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_PLACEABLE_COUNT_EDIT;
[
	_ctrlPlaceableCount,
	_ctrlPlaceableCountEdit,
	[0,100,0],
	[_ctrlPlaceableCount,"",missionNamespace getVariable [QGVAR(autoFillPlaceableCount),10]] call EFUNC(sdf,getCache)
] call EFUNC(sdf,manageSlider);

private _ctrlMedicalCount = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MEDICAL_COUNT;
private _ctrlMedicalCountEdit = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_MEDICAL_COUNT_EDIT;
[
	_ctrlMedicalCount,
	_ctrlMedicalCountEdit,
	[0,100,0],
	[_ctrlMedicalCount,"",missionNamespace getVariable [QGVAR(autoFillMedicalCount),20]] call EFUNC(sdf,getCache)
] call EFUNC(sdf,manageSlider);

{[_ctrlContentsGroup controlsGroupCtrl (_x # 0),"",_x # 1,true] call EFUNC(sdf,getCache)} forEach [
	[IDC_RESUPPLY_MAGAZINE_MULTIPLY,missionNamespace getVariable [QGVAR(autoFillMagazineMultiply),false]],
	[IDC_RESUPPLY_UNDERBARREL_MULTIPLY,missionNamespace getVariable [QGVAR(autoFillUnderbarrelMultiply),false]],
	[IDC_RESUPPLY_ROCKET_MULTIPLY,missionNamespace getVariable [QGVAR(autoFillRocketMultiply),false]],
	[IDC_RESUPPLY_THROWABLE_MULTIPLY,missionNamespace getVariable [QGVAR(autoFillThrowableMultiply),false]],
	[IDC_RESUPPLY_PLACEABLE_MULTIPLY,missionNamespace getVariable [QGVAR(autoFillPlaceableMultiply),false]],
	[IDC_RESUPPLY_MEDICAL_MULTIPLY,missionNamespace getVariable [QGVAR(autoFillMedicalMultiply),false]]
];

private _ctrlUnitsToolbox = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNITS_TOOLBOX;
private _ctrlUnitsListbox = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNITS_LISTBOX;

private _fnc_toolBoxSelChanged = {
	params ["_ctrlUnitsToolbox","_lbCurSel"];
	_thisArgs params ["_ctrlUnitsListbox"];

	lbClear _ctrlUnitsListbox;

	switch _lbCurSel do {
		case 0 : {
			{
				private _checked = [_ctrlUnitsListbox,[QGVAR(resupplyUnitsSide),_x],0] call EFUNC(sdf,getCache);
				private _index = _ctrlUnitsListbox lbAdd _x;
				_ctrlUnitsListbox lbSetPicture [_index,SIDE_ICONS # _forEachIndex];
				_ctrlUnitsListbox lbSetPictureRight [_index,CHECK_ICONS # _checked];
				_ctrlUnitsListbox lbSetValue [_index,_checked];
			} forEach ["BLUFOR","OPFOR","Independent","Civilian"];
		};
		case 1 : {
			private _groups = [[],[],[],[]];

			{
				private _sideIndex = [west,east,independent,civilian] find side group _x;
				if (_sideIndex == -1) then {continue};
				_groups # _sideIndex pushBackUnique group _x;
			} forEach allPlayers;

			_groups = flatten _groups;
			_ctrlUnitsListbox setVariable [QGVAR(groups),_groups];

			{
				private _checked = [_ctrlUnitsListbox,[QGVAR(resupplyUnitsGroup),_x],0] call EFUNC(sdf,getCache);
				private _index = _ctrlUnitsListbox lbAdd groupID _x;
				_ctrlUnitsListbox lbSetPicture [_index,SIDE_ICONS param [[west,east,independent,civilian] find side _x,""]];
				_ctrlUnitsListbox lbSetPictureRight [_index,CHECK_ICONS # _checked];
				_ctrlUnitsListbox lbSetValue [_index,_checked];
			} forEach _groups;
		};
		case 2 : {
			private _players = [[],[],[],[]];

			{
				private _sideIndex = [west,east,independent,civilian] find side group _x;
				if (_sideIndex == -1) then {continue};
				_players # _sideIndex pushBackUnique _x;
			} forEach allPlayers;

			_players = flatten _players;
			_ctrlUnitsListbox setVariable [QGVAR(players),_players];

			{
				private _checked = [_ctrlUnitsListbox,[QGVAR(resupplyUnitsPlayers),_x],0] call EFUNC(sdf,getCache);
				private _index = _ctrlUnitsListbox lbAdd name _x;
				_ctrlUnitsListbox lbSetPicture [_index,SIDE_ICONS param [[west,east,independent,civilian] find side group _x,""]];
				_ctrlUnitsListbox lbSetPictureRight [_index,CHECK_ICONS # _checked];
				_ctrlUnitsListbox lbSetValue [_index,_checked];
			} forEach _players;
		};
	};
};

[_ctrlUnitsToolbox,"ToolBoxSelChanged",_fnc_toolBoxSelChanged,_ctrlUnitsListbox] call CBA_fnc_addBISEventHandler;
[_ctrlUnitsToolbox,"",1,true] call EFUNC(sdf,getCache);

private _thisArgs = _ctrlUnitsListbox;
[_ctrlUnitsToolbox,lbCurSel _ctrlUnitsToolbox] call _fnc_toolBoxSelChanged;

[_ctrlUnitsListbox,"LBSelChanged",{
	params ["_ctrlUnitsListbox","_lbCurSel"];
	_ctrlUnitsListbox lbSetValue [_lbCurSel,abs 1 - (_ctrlUnitsListbox lbValue _lbCurSel)];
	_ctrlUnitsListbox lbSetPictureRight [_lbCurSel,CHECK_ICONS # (_ctrlUnitsListbox lbValue _lbCurSel)];
}] call CBA_fnc_addBISEventHandler;
