#include "..\script_component.hpp"

params ["_id","_cachePos"];

GVAR(cache) deleteAt (GVAR(cache) find _this);

private _cache = GVAR(cacheHash) get _id;

if (isNil "_cache") exitWith {
	DEBUG_1("Cache ID not found: %1",_id);
};

GVAR(cacheHash) deleteAt _id;

_cache params ["_data","_groupUnits","_groupVehicles","_waypointData"];
_data params ["_assignment","_side","_origin","_requestDistance","_responseDistance","_extras"];

private _group = createGroup [_side,true];
private _spawns = [];

{
	_x params ["_type","_posASL","_dirAndUp","_enablePath","_unitPos"];

	private _unit = _group createUnit [_type,[0,0,0],[],0,"CAN_COLLIDE"];
	_unit allowDamage false;
	_unit setPosASL _posASL;
	_unit setVectorDirAndUp _dirAndUp;
	_unit enableAIFeature ["PATH",_enablePath];
	_unit setUnitPos _unitPos;

	_spawns pushBack _unit;
} forEach _groupUnits;

{
	_x params ["_type","_posASL","_dirAndUp","_units"];

	private _vehicle = createVehicle [_type,[0,0,0],[],0,"CAN_COLLIDE"];
	_vehicle allowDamage false;
	_vehicle setPosASL _posASL;
	_vehicle setVectorDirAndUp _dirAndUp;
	//_vehicle setVehiclePosition [ASLToAGL _posASL,[],0,"NONE"];
	
	{
		_x params ["_type","_role"];

		private _unit = _group createUnit [_type,[0,0,0],[],0,"CAN_COLLIDE"];
		_unit moveInAny _vehicle;
	} forEach _units;

	_group addVehicle _vehicle;
	_spawns pushBack _vehicle;
} forEach _groupVehicles;

[{{_x allowDamage true} forEach _this},_spawns,3] call CBA_fnc_waitAndExecute;

DEBUG_1("%1: Uncached",_group);

[_group,_assignment,_requestDistance,_responseDistance,_extras,_origin] call FUNC(addGroup);

_group setVariable [QGVAR(allowCaching),true,true];

if (_assignment == "FREE") then {
	[{
		params ["_group","_waypointData"];

		{([_group] + _x) call EFUNC(common,addWaypoint)} forEach _waypointData;
	},[_group,_waypointData],5] call CBA_fnc_waitAndExecute;
};
