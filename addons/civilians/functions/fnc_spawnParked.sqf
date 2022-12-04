#include "script_component.hpp"

_thisArgs params ["_area","_blacklist","_vehicleClasses","_customInit","_customArgs","_ambCiv"];

if (_ambCiv && {isNull _customArgs}) exitWith {};
	
private "_randPos";
private _spawnPos = [];
private _dir = random 360;
private _class = if (_vehicleClasses isEqualTypeAll "") then {
	selectRandom _vehicleClasses
} else {
	selectRandomWeighted _vehicleClasses
};

private _try = 0;
while {
	while {
		_randPos = [_area,false] call CBA_fnc_randPosArea;
		surfaceIsWater _randPos || (_blacklist findIf {_randPos inArea _x}) != -1
	} do {};

	private _roads = (_randPos nearRoads 150) select {
		private _road = _x;
		_blacklist findIf {_road inArea _x} isEqualTo -1
	};

	private _road = [_randPos,_roads] call EFUNC(common,getNearest);

	private _buildings = (nearestObjects [_randPos,["Building"],100,true]) select {
		private _building = _x;
		_blacklist findIf {_building inArea _x} isEqualTo -1
	};
	
	if (_buildings isEqualTo [] && !isNull _road) then {
		_buildings = (nearestObjects [getPos _road,["Building"],60,true]) select {
			private _building = _x;
			_blacklist findIf {_building inArea _x} isEqualTo -1
		};
	};

	if (_buildings isNotEqualTo []) then {
		private _building = _buildings # 0;
		_spawnPos = getPosATL _building findEmptyPosition [sizeOf typeOf _building / 2,60,_class];

		if (_spawnPos isNotEqualTo [] && {isOnRoad _spawnPos}) then {
			private _road = [_spawnPos,_spawnPos nearRoads 15] call EFUNC(common,getNearest);
			private _connectedRoads = roadsConnectedTo _road;
			if !(_connectedRoads isEqualTo []) then {
				_dir = (_road getDir (_connectedRoads # 0)) + selectRandom [180,0];
			};

			private _sideOfRoad = +_spawnPos;
			private _testDir = _dir + selectRandom [90,-90];
			private _testPos = _sideOfRoad getPos [1,_testDir];

			while {isOnRoad _testPos} do {
				_sideOfRoad = +_testPos;
				_testPos = _sideOfRoad getPos [1,_testDir];
			};

			_spawnPos = +_sideOfRoad;
		} else {
			_dir = getDir _building + selectRandom [0,180,90,-90] + (random 20 - 10);
		};
	} else {
		if (!isNull _road && {random 1 < 0.65}) then {
			private _connectedRoads = roadsConnectedTo _road;
			if (_connectedRoads isNotEqualTo []) then {
				_dir = _road getDir (_connectedRoads # 0);
			};

			private _sideOfRoad = getPosATL _road;
			private _testDir = _dir + selectRandom [90,-90];
			private _testPos = _sideOfRoad getPos [0.5,_testDir];

			while {isOnRoad _testPos} do {
				_sideOfRoad = +_testPos;
				_testPos = _sideOfRoad getPos [0.5,_testDir];
			};

			_spawnPos = +_sideOfRoad;
		};
	};

	if (_try > 3) exitWith {
		_spawnPos = +_randPos;
		false
	};

	_try = _try + 1;

	_spawnPos isEqualTo []
} do {};

// If no good spots are found, just stop trying
if (_spawnPos isEqualTo _randPos && {random 1 < 0.8}) exitWith {
	_iteratePFHID call CBA_fnc_removePerFrameHandler;
};

private _vehicle = createVehicle [_class,[0,0,999 + round random 999],[],0,"CAN_COLLIDE"];
_vehicle allowDamage false;
_vehicle setDir _dir;

[{
	params ["_vehicle","_spawnPos"];
	_vehicle setVelocity [0,0,0];
	_vehicle setVehiclePosition [_spawnPos,[],0,"NONE"];
	[EFUNC(common,spawnCleanup),_vehicle,2] call CBA_fnc_waitAndExecute;
},[_vehicle,_spawnPos],1] call CBA_fnc_waitAndExecute;

[_vehicle,_customArgs] call _customInit;

[QGVAR(vehicleCreated),_vehicle] call CBA_fnc_serverEvent;
