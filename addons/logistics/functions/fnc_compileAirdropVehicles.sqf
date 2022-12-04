#include "script_component.hpp"

params ["_sideSelection"];

if (!isNil {uiNamespace getVariable QGVAR(resupplyVehicleHash)}) exitWith {
	(uiNamespace getVariable QGVAR(resupplyVehicleHash)) # _sideSelection
};

private _hash = [createHashMap,createHashMap,createHashMap,createHashMap];

{
	private _sideNumber = getNumber (_x >> "side");

	if (getNumber (_x >> "scope") == 2 &&
		{_sideNumber in [0,1,2,3]} &&
		{getText (_x >> "vehicleClass") == "Air"}
	) then {
		private _side = [1,0,2,3] # _sideNumber;
		private _faction = getText (_x >> "faction");
		private _category = getText (_x >> "editorSubcategory");

		(((_hash # _side) getOrDefault [_faction,createHashMap,true]) getOrDefault [_category,[],true]) pushBack configName _x;
	};
} forEach configProperties [configFile >> "CfgVehicles","isClass _x",true];

uiNamespace setVariable [QGVAR(resupplyVehicleHash),_hash];
_hash # _sideSelection
