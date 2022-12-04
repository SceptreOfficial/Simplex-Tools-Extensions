#include "script_component.hpp"

params ["_unit"];

_unit playActionNow "PutDown";
_unit setVariable [QGVAR(hasResupply),false,true];

private _posASL = getPosASLVisual _unit vectorAdd (vectorDirVisual _unit vectorMultiply 1.5);
private _normal = surfaceNormal _posASL;

private _ix = lineIntersectsSurfaces [_posASL vectorAdd [0,0,1],_posASL vectorAdd [0,0,-0.5],_unit,objNull,true,1,"GEOM","FIRE"];
if (_ix isNotEqualTo []) then {
	_posASL = _ix # 0 # 0;
	_normal = _ix # 0 # 1;
};

private _object = "Box_NATO_Ammo_F" createVehicle [0,0,0];
_object setDir (getDirVisual _unit - 90);
_object setPosASL _posASL;
_object setVectorUp _normal;

clearItemCargoGlobal _object;
clearMagazineCargoGlobal _object;
clearWeaponCargoGlobal _object;
clearBackpackCargoGlobal _object;

[QEGVAR(common,execute),[[_unit,_object],{
	params ["_unit","_object"];

	private _group = group _unit;

	[{_this setMaxLoad loadAbs _this},_object,1] call CBA_fnc_waitAndExecute;
	_object setMaxLoad MAX_LOAD;
	{_object addItemCargoGlobal _x} forEach ([units _group] + (_group getVariable [QGVAR(deployableResupplyArgs),[]]) call FUNC(resupplyAutoFill));

	private _expiration = _unit getVariable [QGVAR(deployableResupplyExpiration),parseNumber GVAR(deployableResupplyExpiration)];
	private _cooldown = _unit getVariable [QGVAR(deployableResupplyCooldown),parseNumber GVAR(deployableResupplyCooldown)];

	if (_expiration > 0) then {
		[{deleteVehicle _this},_object,_expiration] call CBA_fnc_waitAndExecute;
	};

	if (_cooldown > 0) then {
		[{
			LLSTRING(deployableResupplyReady) call EFUNC(common,hint);
			_this setVariable [QGVAR(hasResupply),true,true];
		},_unit,_cooldown] call CBA_fnc_waitAndExecute;

		toUpper format [LLSTRING(deployableResupplyCooldown),_cooldown call EFUNC(common,properTime)] call EFUNC(common,hint);
	};

	[QGVAR(resupplyDeployed),[_unit,_object]] call CBA_fnc_globalEvent;
}]] call CBA_fnc_serverEvent;
