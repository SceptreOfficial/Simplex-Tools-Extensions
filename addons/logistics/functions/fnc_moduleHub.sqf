#include "..\script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		if (_synced isEqualTo []) exitWith {
			LOG_WARNING("No objects synced");
		};

		private _arguments = [
			_logic getVariable ["EditInventories",true],
			_logic getVariable ["BoxSpawn",true],
			_logic getVariable ["CanteenTap",true],
			_logic getVariable ["ConstructionResupply",true],
			[west,east,independent] param [_logic getVariable ["ConstructionSide",0],sideUnknown],
			_logic getVariable ["Arsenal",true],
			_logic getVariable ["ArsenalWhitelistUsage",0],
			(_logic getVariable ["ArsenalWhitelist",""]) call EFUNC(common,parseList),
			_logic getVariable ["ArsenalBlacklistUsage",1],
			(_logic getVariable ["ArsenalBlacklist",""]) call EFUNC(common,parseList)
		];

		{
			([_x] + _arguments) call FUNC(addHub);
		} forEach _synced;
	} else {
		private _object = attachedTo _logic;
		deleteVehicle _logic;

		if (!alive _object) exitWith {
			ZEUS_MESSAGE("Invalid object");
		};

		GVAR(hubObject) = _object;
		createDialog QGVAR(hubMenu);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
