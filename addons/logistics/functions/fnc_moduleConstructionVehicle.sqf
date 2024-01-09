#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];
	
	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		if (_synced isEqualTo []) exitWith {
			LOG_WARNING("No objects synced");
		};

		private _arguments = [
			_logic getVariable ["MaxBudget",1000],
			[_logic getVariable ["ConstructionInventory","[]"],false] call EFUNC(common,parseArray),
			compile (_logic getVariable ["InitFnc",""])
		];

		{
			([_x] + _arguments) call FUNC(addconstructionVehicle)
		} forEach _synced;
	} else {
		private _object = attachedTo _logic;

		if (!alive _object) exitWith {
			ZEUS_MESSAGE("Invalid object");
		};

		[LLSTRING(moduleConstructionVehicleName),[
			["EDITBOX",[LLSTRING(MaxBudgetName),LLSTRING(MaxBudgetInfo)],1000,false],
			["EDITBOX",[LLSTRING(ConstructionInventoryName),LLSTRING(ConstructionInventoryInfo)],str [
				["Land_BagFence_Round_F","",100,5,{}],
				["Land_BagFence_Long_F","",100,5,{}],
				["Land_BagBunker_Small_F","",1000,15,{}]
			],false],
			["EDITBOX",[LLSTRING(InitFncName),LLSTRING(InitFncInfo)],"",false]
		],{
			params ["_values","_object"];
			_values params ["_maxBudget","_inventory","_initFnc"];

			[
				_object,
				parseNumber _maxBudget,
				[] call compile _inventory,
				compile _initFnc
			] call FUNC(addConstructionVehicle);
		},_object] call EFUNC(sdf,dialog);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
