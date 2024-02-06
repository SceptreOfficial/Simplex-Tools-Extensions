#include "..\script_component.hpp"

params [["_id",""],["_consume",false]];
	
if (isNil {GVAR(cache) getVariable _id}) exitWith {};

private _cache = GVAR(cache) getVariable _id;
values _cache params keys _cache;
values _respawn params keys _respawn;

private _group = createGroup [_side,true];
GVAR(max) = GVAR(list) pushBack _group;

private _offset = if (_areas isNotEqualTo []) then {
	(ATLToASL ([selectRandom _areas] call CBA_fnc_randPosArea)) vectorDiff _center
} else {[0,0,0]};

{
	if (_x # 0 isKindOf "CAManBase") then {
		_x params ["_class","_posASL","_normals","_loadout","_stance","_ai","_doStop"];

		private _unit = _group createUnit [_class,[0,0,0],[],0,"CAN_COLLIDE"];
		_unit setPosASL (_posASL vectorAdd _offset);
		_unit setVectorDirAndUp _normals;
		_unit setUnitLoadout _loadout;
		_unit setUnitPos _stance;
		{_unit enableAIFeature [_x,_y]} forEach _ai;

		if (_doStop) then {
			doStop _unit;
			_unit setVariable [QGVAR(doStop),true,true];
		};
	} else {
		_x params ["_class","_posASL","_normals","_customization","_crew"];

		private _vehicle = _class createVehicle [0,0,0];
		_vehicle setPosASL (_posASL vectorAdd _offset);
		_vehicle setVectorDirAndUp _normals;
		[_vehicle,_customization] call BIS_fnc_initVehicle;
		_group addVehicle _vehicle;

		{
			_x params ["_turret","_cargoIndex","_class","_loadout","_ai"];

			private _unit = _group createUnit [_class,[0,0,0],[],0,"CAN_COLLIDE"];
			_unit setUnitLoadout _loadout;

			if (_turret isEqualTo []) then {
				_unit moveInCargo [_vehicle,_cargoIndex,true];
			} else {
				if (_turret isEqualTo [-1]) then {
					_unit moveInDriver _vehicle;
				} else {
					_unit moveInTurret [_vehicle,_turret];
				};
			};
		} forEach _crew;
	};
} forEach _objects;

{deleteWaypoint [_group,0]} forEach (waypoints _group);
{([_group] + _x) call stx_common_fnc_addWaypoint} forEach _waypoints;

if (_consume) then {
	_quantity = _quantity - 1;
	_respawn set ["_quantity",_quantity];
};

_init params [["_init",{}],["_thisArgs",[]]];
_group call _init;

_group setVariable [QGVAR(respawn),+_respawn,true];
_group setVariable [QGVAR(count),_count,true];
//_group setVariable [QGVAR(loadTrigger),_loadTrigger,true];
_group setVariable [QGVAR(saveTrigger),_saveTrigger,true];

if (_quantity > 0) then {
	if (_waveMode) then {
		GVAR(list) pushBackUnique _id;
		GVAR(max) = count GVAR(list) - 1;
		_cache set ["_waveTick",CBA_missionTime + _delay];
	} else {
		_group setVariable [QGVAR(id),_id,true];
	};
} else {
	GVAR(cache) setVariable [_id,nil];

	if (_waveMode) then {
		GVAR(list) deleteAt (GVAR(list) find _id);
		GVAR(max) = count GVAR(list) - 1;
	};
};

_group
