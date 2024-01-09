#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		if (_synced isEqualTo []) exitWith {
			LOG_WARNING("No objects synced");
		};

		private _preset = _logic getVariable ["Preset",""];

		if (_preset isEqualTo "") exitWith {};

		private _presets = missionNamespace getVariable [QGVAR(cargoPresets),createHashMap];
		_presets set [_preset,[_synced # 0,0] call EFUNC(common,getCargo)];
		missionNamespace setVariable [QGVAR(cargoPresets),_presets,true];
	} else {
		private _object = attachedTo _logic;

		if (!alive _object) exitWith {
			"INVALID OBJECT" call EFUNC(common,zeusMessage);
		};

		[LLSTRING(moduleSaveCargoName),[
			["COMBOBOX",["Preset category",""],[["Mission","Profile"],0],false],
			["EDITBOX",["Preset name",""],"",false]
		],{
			params ["_values","_object"];
			_values params ["_category","_preset"];

			if (_preset isEqualTo "") exitWith {
				["NO NAME DEFINED",QEGVAR(common,failure)] call EFUNC(common,zeusMessage);
			};

			private _presets = switch _category do {
				case 0 : {missionNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
				case 1 : {profileNamespace getVariable [QGVAR(cargoPresets),createHashMap]};
			};

			_presets set [_preset,[_object,0] call EFUNC(common,getCargo)];
			
			switch _category do {
				case 0 : {missionNamespace setVariable [QGVAR(cargoPresets),_presets,true]};
				case 1 : {
					profileNamespace setVariable [QGVAR(cargoPresets),_presets];
					saveProfileNamespace;
				};
			};
		},_object] call EFUNC(sdf,dialog);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
