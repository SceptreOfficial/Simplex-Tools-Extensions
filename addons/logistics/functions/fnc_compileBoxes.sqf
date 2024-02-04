#include "..\script_component.hpp"

if (!isNil {uiNamespace getVariable QGVAR(boxHash)}) exitWith {
	uiNamespace getVariable QGVAR(boxHash)
};

private _hash = createHashMap;
private _cfgFactionClasses = configFile >> "CfgFactionClasses";
private _cfgEditorSubcategories = configFile >> "CfgEditorSubcategories";
private _cfgEditorCategories = configFile >> "CfgEditorCategories";

{
	if (getNumber (_x >> "scope") == 2 &&
		{getNumber (_x >> "side") == 3} &&
		{getNumber (_x >> "maximumLoad") > 0} &&
		{
			toLower getText (_x >> "vehicleClass") in ["container","small_items"] ||
			toLower getText (_x >> "editorCategory") in ["edcat_supplies"]
		}
		/*{
			getArray (_x >> "slingLoadCargoMemoryPoints") isNotEqualTo [] || // sling loadable
			isClass (_x >> "VehicleTransport" >> "Cargo") // VIV cargo item
		} &&*/
		
	) then {
		private _faction = getText (_cfgFactionClasses >> getText (_x >> "faction") >> "displayName");
		private _category = getText (_cfgEditorSubcategories >> getText (_x >> "editorSubcategory") >> "displayName");

		if (_category isEqualTo "") then {
			_category = getText (_cfgEditorCategories >> getText (_x >> "editorCategory") >> "displayName");
		};

		((_hash getOrDefault [_faction,createHashMap,true]) getOrDefault [_category,[],true]) pushBack [
			getText (_x >> "displayName"),
			configName _x
		];
	};
} forEach configProperties [configFile >> "CfgVehicles","isClass _x",true];

uiNamespace setVariable [QGVAR(boxHash),_hash];

_hash