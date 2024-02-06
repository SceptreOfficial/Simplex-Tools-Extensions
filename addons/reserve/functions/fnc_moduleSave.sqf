#include "..\script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#define LVAR(N) _logic getVariable QUOTE(N)

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		private _groups = [];
		private _spawnAreas = [];
		private _triggers = [];
		private _sides = [west,east,independent,civilian];
		
		{
			switch true do {
				case (_x isKindOf QGVAR(moduleSpawnArea)) : {
					_spawnAreas pushBackUnique ([getPos _x] + (_x getVariable ["ObjectArea",[]]));
				};
				case (_x isKindOf "EmptyDetector") : {_triggers pushBackUnique _x};
				case (side group _x in _sides) : {_groups pushBackUnique group _x};
			};
		} forEach synchronizedObjects _logic;

		private _args = [
			[
				LVAR(RespawnDelay),
				LVAR(RespawnQuantity),
				LVAR(RespawnRatio),
				LVAR(RespawnWaveMode),
				_spawnAreas
			],
			compile (LVAR(GroupInit)),
			_triggers param [0,nil],
			_triggers param [0,nil]
		];

		{([_x] + _args) call FUNC(save)} forEach _groups;
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
