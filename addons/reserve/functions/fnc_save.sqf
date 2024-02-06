#include "..\script_component.hpp"

params [
	["_group",grpNull,[grpNull,objNull]],
	["_respawn",[]],
	["_init",{}],
	["_loadTrigger",{(allPlayers - entities "HeadlessClient_F") findIf {_x distance2D _center < GVAR(loadDistance)} > -1}],
	["_saveTrigger",{(allPlayers - entities "HeadlessClient_F") findIf {_x distance2D _center < GVAR(saveDistance)} == -1}]
];

_respawn params [
	["_delay",0],
	["_quantity",0],
	["_ratio",0.1],
	["_waveMode",false],
	["_areas",[]]
];

if (_group isEqualType objNull) then {_group = group _group};
if (isNull _group || {(units _group) findIf {isPlayer _x} > -1}) exitWith {};

private _objects = [];
private _vehicles = [];
private _positions = [];
private _count = _group getVariable [QGVAR(count),0];
private _doCount = _count == 0;

{
	if (!alive _x) then {continue};

	if (alive objectParent _x) then {
		private _vehicle = vehicle _x;
				
		if (_vehicle in _vehicles) then {continue};

		private _primaryCrew = (crew _vehicle arrayIntersect units _group);

		_positions pushBack getPosASL _vehicle;
		_vehicles pushBack _vehicle;
		_objects pushBack [
			typeOf _vehicle,
			getPosASLVisual _vehicle,
			[vectorDirVisual _vehicle,vectorUpVisual _vehicle],
			_vehicle call BIS_fnc_getVehicleCustomization,
			_primaryCrew apply {[
				_vehicle unitTurret _x,
				_vehicle getCargoIndex _x,
				typeOf _x,
				getUnitLoadout _x,
				_x call FUNC(getAIFeatures)
			]}
		];
		
		if (_doCount) then {
			_count = _count + count _primaryCrew;
		};
	} else {
		_positions pushBack getPosASL _x;
		_objects pushBack [
			typeOf _x,
			getPosASLVisual _x,
			[vectorDirVisual _x,vectorUpVisual _x],
			getUnitLoadout _x,
			unitPos _x,
			_x call FUNC(getAIFeatures),
			_x getVariable [QGVAR(doStop),false]
		];

		if (_doCount) then {
			_count = _count + 1;
		};
	};
} forEach units _group;

private _current = currentWaypoint _group;
private _waypoints = [];

{
	if (_current > _forEachIndex) then {continue};
	_waypoints pushBack [
		waypointPosition _x,
		0,
		waypointType _x,
		waypointBehaviour _x,
		waypointCombatMode _x,
		waypointSpeed _x,
		waypointFormation _x,
		waypointStatements _x,
		waypointTimeout _x,
		waypointCompletionRadius _x,
		waypointScript _x
	];
} forEach waypoints _group;

if (isNil QGVAR(cache)) then {
	GVAR(cache) = call CBA_fnc_createNamespace;
	GVAR(list) = [];
	GVAR(index) = 0;
	[FUNC(pfh),0.25] call CBA_fnc_addPerFrameHandler;
};

private _id = call CBA_fnc_createUUID;
private _center = _positions call stx_common_fnc_positionAvg;

if (_loadTrigger isEqualType objNull) then {
	if (_loadTrigger isEqualTo _saveTrigger) then {
		_saveTrigger = [{!triggerActivated _this},_saveTrigger];
	};

	_loadTrigger = [{triggerActivated _this},_loadTrigger];
};

if (_saveTrigger isEqualType objNull) then {	
	_saveTrigger = [{!triggerActivated _this},_saveTrigger];
};

GVAR(max) = GVAR(list) pushBack [_id,_center];
GVAR(cache) setVariable [_id,createHashMapFromArray [
	["_center",_center],
	["_side",side _group],
	["_objects",_objects],
	["_waypoints",_waypoints],
	["_init",_init],
	["_respawn",createHashMapFromArray [
		["_delay",_delay],
		["_quantity",_quantity - 1],
		["_ratio",_ratio],
		["_waveMode",_waveMode],
		["_areas",_areas]
	]],
	["_loadTrigger",_loadTrigger],
	["_saveTrigger",_saveTrigger],
	["_count",_count],
	["_waveTick",0]
]];

{
	deleteVehicleCrew _x;
	deleteVehicle _x;
} forEach _vehicles;

{deleteVehicle _x} forEach units _group;

deleteGroup _group;

_id
