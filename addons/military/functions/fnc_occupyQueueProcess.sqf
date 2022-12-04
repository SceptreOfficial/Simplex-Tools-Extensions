#include "script_component.hpp"

params ["_assignmentType","_details"];
_details params ["_area","_side","_config","_settings"];
_settings params ["_requestDistance","_responseDistance","_QRFRequestDistance","_QRFResponseDistance","_patrolRadiusRandom"];

private _fnc_randPosSentryQRF = {
	private "_randPos";
	private _spawnPos = [];
	private _dir = random 360;
	private _class = "C_Truck_02_covered_F";
	private _try = 0;
	while {
		// Random position
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;
			surfaceIsWater _randPos
		} do {};

		// Find "overwatch" positions
		private _places = (selectBestPlaces [_randPos,150,"hills - forest - sea",60,40]) apply {[getTerrainHeightASL (_x # 0),_x # 0]};
		_places sort false;
		_places resize 5;

		private _highestPlaces = [];

		{
			private _places = (selectBestPlaces [_x # 1,50,"hills - forest - sea",80,20]) apply {[getTerrainHeightASL (_x # 0),_x # 0]};
			_places sort false;
			if (_places isNotEqualTo []) then {
				_highestPlaces pushBack (_places # 0 # 1)
			};
		} forEach _places;

		// Select highest "overwatch" position
		private _highPos = selectRandom _highestPlaces;

		// Chance to place next to building, road, or use highest "overwatch" position
		if (isNil "_highPos" || random 1 < 0.6) then {
			// Find nearby road and buildings
			private _road = [_randPos,_randPos nearRoads 150] call EFUNC(common,getNearest);
			private _buildings = nearestObjects [_randPos,["Building"],100,true];
			
			// Search for more buildings from road segment
			if (_buildings isEqualTo [] && !isNull _road) then {
				_buildings = nearestObjects [getPos _road,["Building"],60,true];
			};

			if (_buildings isNotEqualTo []) then {
				// Try to get position on the side of the road, next to a building
				private _building = _buildings # 0;
				_spawnPos = getPos _building findEmptyPosition [sizeOf typeOf _building / 2,60,_class];

				if (_spawnPos isNotEqualTo [] && {isOnRoad _spawnPos}) then {
					private _road = [_spawnPos,_spawnPos nearRoads 15] call EFUNC(common,getNearest);
					private _connectedRoads = roadsConnectedTo _road;
					
					if (_connectedRoads isNotEqualTo []) then {
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
				if (!isNull _road && random 1 < 0.9) then {
					// Try to get position on the side of the road
					private _connectedRoads = roadsConnectedTo _road;

					if (_connectedRoads isNotEqualTo []) then {
						_dir = _road getDir (_connectedRoads # 0);
					};

					private _sideOfRoad = getPos _road;
					private _testDir = _dir + selectRandom [90,-90];
					private _testPos = _sideOfRoad getPos [0.5,_testDir];

					while {isOnRoad _testPos} do {
						_sideOfRoad = +_testPos;
						_testPos = _sideOfRoad getPos [0.5,_testDir];
					};

					_spawnPos = +_sideOfRoad;
				};
			};
		} else {
			_spawnPos = +_highPos;
		};

		if (_try > 3) exitWith {
			_spawnPos = +_randPos;
			false
		};

		_try = _try + 1;

		_spawnPos isEqualTo []
	} do {};

	[_spawnPos,_dir]
};

switch (_assignmentType) do {
	case 0 : {
		private "_randPos";
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;
			surfaceIsWater _randPos
		} do {};

		private _group = [_randPos,_side,_config] call EFUNC(common,spawnGroup);
		_group setVariable [QGVAR(allowCaching),false,true];
		[{_this setVariable [QGVAR(allowCaching),nil,true]},_group,6] call CBA_fnc_waitAndExecute;

		private _dir = random 360;
		_group setFormDir _dir;
		leader _group setDir _dir;

		[_group,"PATROL",_requestDistance,_responseDistance,[0,0,round random _patrolRadiusRandom]] call FUNC(addGroup);
	};
	case 1 : {
		private "_randPos";
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;
			private _buildingPositions = [];
			{_buildingPositions append ([_x] call CBA_fnc_buildingPositions)} forEach (nearestObjects [_randPos,["Building"],70,true]);
			surfaceIsWater _randPos && _buildingPositions isEqualTo []
		} do {};

		private _group = [_randPos,_side,_config] call EFUNC(common,spawnGroup);
		_group setVariable [QGVAR(allowCaching),false,true];
		[{_this setVariable [QGVAR(allowCaching),nil,true]},_group,6] call CBA_fnc_waitAndExecute;

		private _dir = random 360;
		_group setFormDir _dir;
		leader _group setDir _dir;

		[_group,"GARRISON",_requestDistance,_responseDistance,[true,round random [0,1,2]]] call FUNC(addGroup);
	};
	case 2 : {
		(call _fnc_randPosSentryQRF) params ["_spawnPos","_dir"];

		private _group = [_spawnPos,_side,_config,nil,nil,nil,nil,nil,_dir] call EFUNC(common,spawnGroup);
		_group setVariable [QGVAR(allowCaching),false,true];
		[{_this setVariable [QGVAR(allowCaching),nil,true]},_group,6] call CBA_fnc_waitAndExecute;

		_group setFormDir _dir;
		leader _group setDir _dir;

		[_group,"SENTRY",_requestDistance,_responseDistance] call FUNC(addGroup);
	};
	case 3 : {
		(call _fnc_randPosSentryQRF) params ["_spawnPos","_dir"];

		private _group = [_spawnPos,_side,_config,nil,nil,nil,nil,nil,_dir] call EFUNC(common,spawnGroup);
		_group setVariable [QGVAR(allowCaching),false,true];
		[{_this setVariable [QGVAR(allowCaching),nil,true]},_group,6] call CBA_fnc_waitAndExecute;

		_group setFormDir _dir;
		leader _group setDir _dir;
		
		[_group,"QRF",_QRFRequestDistance,_QRFResponseDistance] call FUNC(addGroup);
	};
};
