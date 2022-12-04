#include "script_component.hpp"

params [
	["_area",[],["",objNull,locationNull,[]],5],
	["_unitClasses",[],[[]]],
	["_vehicleClasses",[],[[]]],
	["_spawnCounts",[0,0,0],[[]]],
	["_blacklist",[],[[]]],
	["_customInit",{},[{}]],
	["_customArgs",[]],
	["_ambCiv",false,[false]],
	["_spawnDelays",[GVAR(pedSpawnDelay),GVAR(driverSpawnDelay),GVAR(parkedSpawnDelay)],[[]]]
];

// Verification of all input args
_area = [_area] call CBA_fnc_getArea;

if (_area isEqualTo [] || {surfaceIsWater (_area # 0)}) exitWith {};

_blacklist = (_blacklist apply {[_x] call CBA_fnc_getArea}) - [[]];

private _areaPos = _area # 0;

if (_blacklist find {_areaPos inArea _x} != -1) exitWith {};

if (_unitClasses isEqualTo []) then {
	_unitClasses = ["C_Man_casual_2_F","C_Man_casual_3_F","C_man_w_worker_F","C_man_polo_2_F","C_Man_casual_1_F","C_man_polo_4_F"];
};

if (_vehicleClasses isEqualTo []) then {
	_vehicleClasses = ["C_Truck_02_fuel_F","C_Truck_02_box_F","C_Truck_02_covered_F","C_Offroad_01_repair_F","C_Van_01_box_F","C_Offroad_01_F","C_Offroad_01_covered_F","C_SUV_01_F"];
};

_spawnCounts params [["_pedestrianCount",20,[0]],["_driverCount",8,[0]],["_parkedCount",6,[0]]];

// If executed via Ambient Civilian system, chance to drop spawn counts
if (_ambCiv) then {
	if (random 1 < 0.1) then {_pedestrianCount = _pedestrianCount - round random (_pedestrianCount / 2);};
	if (random 1 < 0.1) then {_driverCount = _driverCount - round random (_driverCount / 2);};
	if (random 1 < 0.15) then {_parkedCount = _parkedCount - round random (_parkedCount / 2);};
};

// Spawn pedestrians
[_pedestrianCount,FUNC(spawnPedestrian),[createGroup [civilian,true],_area,_blacklist,_unitClasses,_customInit,_customArgs,_ambCiv],_spawnDelays # 0,true] call EFUNC(common,iterate);

// Spawn moving vehicles/drivers
[_driverCount,FUNC(spawnDriver),[_area,_blacklist,_unitClasses,_vehicleClasses,_customInit,_customArgs,_ambCiv],_spawnDelays # 1,true] call EFUNC(common,iterate);

// Spawn parked vehicles
[_parkedCount,FUNC(spawnParked),[_area,_blacklist,_vehicleClasses,_customInit,_customArgs,_ambCiv],_spawnDelays # 2,true] call EFUNC(common,iterate);

if (isNil QGVAR(brainEFID)) then {
	GVAR(brainList) = [];
	GVAR(brainEFID) = addMissionEventHandler ["EachFrame",{call FUNC(brain)}];
};
