#include "script_component.hpp"

params ["_type","_data"];

GVAR(cache) deleteAt (GVAR(cache) find _this);

switch _type do {
	case "pedestrian" : {
		_data params ["_class","_posASL","_dirAndUp","_group","_inhabitancy"];
		
		private _unit = if (GVAR(useAgents)) then {
			createAgent [_class,[0,0,0],[],0,"CAN_COLLIDE"];
		} else {
			if (isNull _group) then {
				{if (side group _x == civilian) exitWith {_group = group _x}} forEach (ASLtoAGL _posASL nearEntities 250);
				if (isNull _group) then {_group = createGroup [civilian,true]};
			};

			_group createUnit [_class,[0,0,0],[],0,"CAN_COLLIDE"];
		};

		_unit setPosASL _posASL;
		_unit setVectorDirAndUp _dirAndUp;
		[_unit,_inhabitancy] call FUNC(initMan);

		GVAR(brainTick) = CBA_missionTime + GVAR(pedSpawnDelay);

		_unit
	};
	case "driver" : {
		_data params ["_class","_posASL","_dirAndUp","_driverClass","_inhabitancy"];

		private _vehicle = _class createVehicle [0,0,0];
		_vehicle setPosASL _posASL;
		_vehicle setVectorDirAndUp _dirAndUp;

		private _unit = if (GVAR(useAgents)) then {
			createAgent [_class,[0,0,0],[],0,"CAN_COLLIDE"];
		} else {
			private _group = createGroup [civilian,true];
			_group addVehicle _vehicle;
			_group createUnit [_driverClass,[0,0,0],[],0,"CAN_COLLIDE"];
		};
		
		_unit assignAsDriver _vehicle;
		_unit moveInDriver _vehicle;
		[_unit,_inhabitancy] call FUNC(initMan);

		GVAR(brainTick) = CBA_missionTime + GVAR(driverSpawnDelay);

		_vehicle
	};
	case "parked" : {
		_data params ["_class","_posASL","_dirAndUp"];

		private _vehicle = _class createVehicle [0,0,0];
		_vehicle setPosASL _posASL;
		_vehicle setVectorDirAndUp _dirAndUp;

		GVAR(brainTick) = CBA_missionTime + GVAR(parkedSpawnDelay);

		_vehicle
	};
};
