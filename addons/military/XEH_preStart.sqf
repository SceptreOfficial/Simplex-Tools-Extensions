#include "script_component.hpp"
#include "XEH_PREP.hpp"

// Compile unit hash for occupation dialog
//private _sideHash = [[],[[],[[],[]] call CBA_fnc_hashCreate] call CBA_fnc_hashCreate] call CBA_fnc_hashCreate;
private _sideHash = createHashMap;
private _cfgSubCategories = configFile >> "CfgEditorSubcategories";

{
	if (getNumber (_x >> "scope") != 2) then {continue};
		
	private _class = configName _x;

	if (_class isKindOf "CAManBase" || _class isKindOf "LandVehicle") then {
		private _side = getNumber (_x >> "side");

		if !(_side in [0,1,2]) exitWith {};

		private _faction = getText (_x >> "faction");
		private _category = getText (_cfgSubCategories >> getText (_x >> "editorSubcategory") >> "displayName");
		private _displayName = getText (_x >> "displayName");
		
		private _factionHash = _sideHash get _side;
		if (isNil "_factionHash") then {_factionHash = createHashMap};
		
		private _categoryHash = _factionHash get _faction;
		if (isNil "_categoryHash") then {_categoryHash = createHashMap};

		private _classes = _categoryHash getOrDefault [_category,[]];

		_classes pushBack [_displayName,_class];
		
		_categoryHash set [_category,_classes];
		_factionHash set [_faction,_categoryHash];
		_sideHash set [_side,_factionHash];
	};
} forEach configProperties [configFile >> "CfgVehicles","isClass _x"];

uiNamespace setVariable [QGVAR(sideHash),_sideHash];
