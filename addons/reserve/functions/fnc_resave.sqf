#include "..\script_component.hpp"

params ["_group"];

if (isNil {_group getVariable QGVAR(id)}) exitWith {
	//systemChat str ["cache:new",_group];
	_group call FUNC(save);
};

//systemChat str ["cache:reference",_group];

private _positions = [];

{
	if (isNull _x) then {continue};
	if (alive objectParent _x) then {
		private _vehicle = vehicle _x;
		_positions pushBack getPosASL _vehicle;
		deleteVehicleCrew _vehicle;
		deleteVehicle _vehicle
	} else {
		_positions pushBack getPosASL _x;
		deleteVehicle _x;
	};
} forEach units _group;

private _center = _positions call stx_common_fnc_positionAvg;

GVAR(max) = GVAR(list) pushBack [_group getVariable QGVAR(id),_center];

deleteGroup _group;
