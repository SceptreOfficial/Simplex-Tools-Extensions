#include "script_component.hpp"

params ["_group"];

// Prevent double execution
if (_group getVariable [QGVAR(cached),false]) exitWith {};
_group setVariable [QGVAR(cached),true];

// Get required data
private _assignment = _group getVariable QGVAR(assignment);
private _extras = switch _assignment do {
	case "GARRISON" : {[false,_group getVariable QGVAR(garrisonType)]};
	case "PATROL" : {[_group getVariable QGVAR(routeStyle),_group getVariable QGVAR(routeType),_group getVariable QGVAR(patrolRadius)]};
	default {[]};
};

// Get unit/vehicle info & delete objects
private _vehicles = [];
private _groupUnits = [];
private _groupVehicles = [];
private _positions = [];

{
	if (alive _x) then {
		if (_x in _x) then {
			_groupUnits pushBack [typeOf _x,getPosASLVisual _x,[vectorDirVisual _x,vectorUpVisual _x],_x checkAIFeature "PATH",unitPos _x];
			_positions pushBack getPosASL _x;
			deleteVehicle _x;
		} else {
			_vehicles pushBackUnique vehicle _x;
		};
	} else {
		if (_x in _x) then {
			deleteVehicle _x;
		} else {
			vehicle _x deleteVehicleCrew _x;
		};
	};
} forEach units _group;

{
	private _vehicle = _x;
	private _vehicleUnits = [];

	{
		_x params ["_unit","_role"];

		if (alive _unit && _unit in units _group) then {
			_vehicleUnits pushBack [typeOf _unit,_role];
		};

		_vehicle deleteVehicleCrew _unit;
	} forEach fullCrew _vehicle;

	if (_vehicleUnits isNotEqualTo []) then {
		_groupVehicles pushBack [typeOf _vehicle,getPosASLVisual _vehicle,[vectorDirVisual _vehicle,vectorUpVisual _vehicle],_vehicleUnits];
		_positions pushBack getPosASL _vehicle;
		deleteVehicle _vehicle;
	};
} forEach _vehicles;

// Cache
private _cachePos = _positions call EFUNC(common,positionAvg);
private _id = format ["%1$%2",_group,_cachePos];

GVAR(cache) pushBack [_id,_cachePos];
GVAR(cacheHash) set [_id,[
	[
		_assignment,
		_group getVariable QGVAR(side),
		_group getVariable QGVAR(origin),
		_group getVariable QGVAR(requestDistance),
		_group getVariable QGVAR(responseDistance),
		_extras
	],
	_groupUnits,
	_groupVehicles,
	_group call EFUNC(common,waypointData)
]];

DEBUG_1("%1: Cached",_group);

// Cleanup
deleteGroup _group;
