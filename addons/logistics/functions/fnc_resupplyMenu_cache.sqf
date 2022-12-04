#include "script_component.hpp"

private _ctrlGroup = _display displayCtrl IDC_GROUP;

(_ctrlGroup controlsGroupCtrl IDC_RESUPPLY_APPLICATION) call EFUNC(sdf,setCache);

private _ctrlApplicationGroup = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_APPLICATION_GROUP;

private _ctrlHeight = _ctrlApplicationGroup controlsGroupCtrl IDC_RESUPPLY_HEIGHT;
[_ctrlHeight,"",str parseNumber ctrlText _ctrlHeight] call EFUNC(sdf,setCache);

{(_ctrlApplicationGroup controlsGroupCtrl _x) call EFUNC(sdf,setCache)} forEach [
	IDC_RESUPPLY_BOX_CLASS,
	IDC_RESUPPLY_CARGO_TYPE,
	IDC_RESUPPLY_UNLOAD_TIME,
	IDC_RESUPPLY_SIGNAL1,
	IDC_RESUPPLY_SIGNAL2
];

(_ctrlGroup controlsGroupCtrl IDC_RESUPPLY_CONTENTS) call EFUNC(sdf,setCache);

private _ctrlContentsGroup = _ctrlGroup controlsGroupCtrl IDC_RESUPPLY_CONTENTS_GROUP;

{(_ctrlContentsGroup controlsGroupCtrl _x) call EFUNC(sdf,setCache)} forEach [
	IDC_RESUPPLY_WHITELIST,
	IDC_RESUPPLY_BLACKLIST,
	IDC_RESUPPLY_MUNITIONS,
	IDC_RESUPPLY_MEDICAL,
	IDC_RESUPPLY_MAGAZINE_COUNT,
	IDC_RESUPPLY_UNDERBARREL_COUNT,
	IDC_RESUPPLY_ROCKET_COUNT,
	IDC_RESUPPLY_THROWABLE_COUNT,
	IDC_RESUPPLY_PLACEABLE_COUNT,
	IDC_RESUPPLY_MEDICAL_COUNT,
	IDC_RESUPPLY_MAGAZINE_MULTIPLY,
	IDC_RESUPPLY_UNDERBARREL_MULTIPLY,
	IDC_RESUPPLY_ROCKET_MULTIPLY,
	IDC_RESUPPLY_THROWABLE_MULTIPLY,
	IDC_RESUPPLY_PLACEABLE_MULTIPLY,
	IDC_RESUPPLY_MEDICAL_MULTIPLY
];

private _ctrlUnitsToolbox = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNITS_TOOLBOX;
private _ctrlUnitsListbox = _ctrlContentsGroup controlsGroupCtrl IDC_RESUPPLY_UNITS_LISTBOX;

_ctrlUnitsToolbox call EFUNC(sdf,setCache);

for "_i" from 0 to (lbSize _ctrlUnitsListbox - 1) do {
	private _uid = switch (lbCurSel _ctrlUnitsToolbox) do {
		case 0 : {[QGVAR(resupplyUnitsSide),_ctrlUnitsListbox lbText _i]};
		case 1 : {
			private _groups = _ctrlUnitsListbox getVariable [QGVAR(groups),[]];
			[QGVAR(resupplyUnitsGroup),_groups param [_i,""]]
		};
		case 2 : {
			private _players = _ctrlUnitsListbox getVariable [QGVAR(players),[]];
			[QGVAR(resupplyUnitsPlayers),_players param [_i,""]]
		};
	};

	[_ctrlUnitsListbox,_uid,_ctrlUnitsListbox lbValue _i] call EFUNC(sdf,setCache);
};
