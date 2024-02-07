#include "..\script_component.hpp"

if (isNil QGVAR(cache)) exitWith {};

if (GVAR(index) > GVAR(max)) then {
	GVAR(index) = 0;
};

private _item = GVAR(list) # GVAR(index);

if (_item isEqualType "") exitWith {
	if (isNil {GVAR(cache) getVariable _item}) exitWith {
		GVAR(list) deleteAt GVAR(index);
		GVAR(max) = count GVAR(list) - 1;
	};

	private _cache = GVAR(cache) getVariable _item;
	values _cache params keys _cache;

	_loadTrigger params ["_condition",["_conditionArgs",[]]];

	if (_waveTick <= CBA_missionTime && _conditionArgs call _condition) exitWith {
		//systemChat str ["wave spawn",_respawn get "_quantity"];	
		[_item,true] call FUNC(load);
	};

	GVAR(index) = GVAR(index) + 1;
};

if (_item isEqualType grpNull) then {
	private _group = _item;

	if (isNull _group) exitWith {
		GVAR(list) deleteAt GVAR(index);
		GVAR(max) = GVAR(max) - 1;
	};

	private _respawn = _group getVariable QGVAR(respawn);
	values _respawn params keys _respawn;

	if (!isNil "_respawn" && {
		_quantity > 0 && !_waveMode && {{alive _x} count units _group <= ceil (_ratio * (_group getVariable [QGVAR(count),0]))}
	}) exitWith {
		//systemChat str ["respawn",_group];
		[FUNC(load),[_group getVariable QGVAR(id),true],_delay] call CBA_fnc_waitAndExecute;
		_respawn set ["_quantity",-1];
		_group setVariable [QGVAR(respawn),+_respawn];
		_group setVariable [QGVAR(id),nil];
	};

	private _center = units _group call stx_common_fnc_positionAvg;
	(_group getVariable QGVAR(saveTrigger)) params ["_condition",["_conditionArgs",[]]];
	
	if (_conditionArgs call _condition) exitWith {
		GVAR(list) deleteAt GVAR(index);
		_group call FUNC(resave);
	};

	GVAR(index) = GVAR(index) + 1;
} else {
	_item params ["_id","_center"];

	if (_center isEqualTo [0,0,0]) exitWith {
		GVAR(cache) setVariable [_id,nil];
		GVAR(list) deleteAt GVAR(index);
		GVAR(max) = count GVAR(list) - 1;
	};

	((GVAR(cache) getVariable _id) get "_loadTrigger") params ["_condition",["_conditionArgs",[]]];

	if (_conditionArgs call _condition) exitWith {
		//systemChat str ["cache:load",_id];
		GVAR(list) deleteAt GVAR(index);
		_id call FUNC(load);
	};

	GVAR(index) = GVAR(index) + 1;
};
