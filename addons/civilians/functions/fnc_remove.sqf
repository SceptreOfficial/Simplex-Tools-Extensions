#include "script_component.hpp"

params [["_spawnPoint",objNull],["_isolated",false],["_removeAll",false]];

if (isNull _spawnPoint) exitWith {
	GVAR(spawnPoints) deleteAt (GVAR(spawnPoints) find _spawnPoint);
};

private _spawnRadius = triggerArea _spawnPoint # 0;
private _type = _spawnPoint getVariable QGVAR(type);

{
	if (isNull _x) then {continue};

	private _vehicle = vehicle _x;

	if (crew _vehicle isEqualTo []) then {
		if (_removeAll) exitWith {deleteVehicle _vehicle};
		
		_vehicle setVariable [QGVAR(isolated),_isolated];

		private _PFHID = [{
			params ["_args","_PFHID"];
			_args params ["_vehicle","_spawnRadius"];

			if !(_vehicle getVariable [QGVAR(isolated),false]) exitWith {
				_vehicle setVariable [QGVAR(isolated),true];
			};

			if (!alive _vehicle || crew _vehicle isNotEqualTo []) exitWith {
				_PFHID call CBA_fnc_removePerFrameHandler;
			};

			if ((allPlayers findIf {!(_x isKindOf "HeadlessClient_F") && {_vehicle distance _x < (_spawnRadius / 2)}}) isEqualTo -1) then {
				deleteVehicle _vehicle;
			};
		},30,[_vehicle,_spawnRadius]] call CBA_fnc_addPerFrameHandler;

		[_vehicle,"GetIn",{
			params ["_vehicle"];
			_vehicle removeEventHandler [_thisType,_thisID];
			_thisArgs call CBA_fnc_removePerFrameHandler;
		},_PFHID] call CBA_fnc_addBISEventHandler;
	} else {
		if (_removeAll) exitWith {
			if (crew _vehicle findIf {isPlayer _x} == -1) then {
				deleteVehicleCrew _vehicle;
				deleteVehicle _vehicle;
			};
		};

		private _transfer = GVAR(spawnPoints) findIf {
			_x != _spawnPoint && 
			(_spawnPoint getVariable QGVAR(type)) == _type && 
			{_vehicle inArea _x}
		};

		if (_transfer != -1) exitWith {
			private _newSpawnPoint = GVAR(spawnPoints) # _transfer;
			_newSpawnPoint setVariable [QGVAR(objects),(_newSpawnPoint getVariable [QGVAR(objects),[]]) + [_x]];
			_x setVariable [QGVAR(moveTick),-1];
		};

		if (side group _vehicle == civilian) then {
			deleteVehicleCrew _vehicle;
			deleteVehicle _vehicle;
		};
	};
} forEach (_spawnPoint getVariable [QGVAR(objects),[]]);

GVAR(spawnPoints) deleteAt (GVAR(spawnPoints) find _spawnPoint);

deleteVehicle _spawnPoint;
