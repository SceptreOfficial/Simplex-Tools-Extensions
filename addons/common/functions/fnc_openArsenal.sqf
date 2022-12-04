#include "script_component.hpp"

params [
	["_object",objNull,[objNull]],
	["_unit",objNull,[objNull]]
];

if (isNull _object || isNull _unit) exitWith {};

if (GVAR(arsenalDummyEnabled)) then {
	if (isNil QPVAR(arsenalDummySpawn) || {isNull PVAR(arsenalDummySpawn)}) then {
		PVAR(arsenalDummySpawn) = createGroup [sideLogic,true] createUnit ["Logic",[0,0,0],[],0,"CAN_COLLIDE"];
		PVAR(arsenalDummySpawn) setPosATL [0,0,9001];
		publicVariable QPVAR(arsenalDummySpawn);
	};

	PVAR(arsenalDummySpawn) setVectorUp [0,0,1];

	if (!isNil QGVAR(arsenalDummy) && {!isNull GVAR(arsenalDummy)}) then {deleteVehicle GVAR(arsenalDummy)};
	GVAR(arsenalDummy) = typeOf _unit createVehicleLocal [0,0,0];
	GVAR(arsenalDummy) allowDamage false;
	GVAR(arsenalDummy) setPosASL getPosASL PVAR(arsenalDummySpawn);
	GVAR(arsenalDummy) setDir getDir PVAR(arsenalDummySpawn);
	GVAR(arsenalDummy) setUnitLoadout getUnitLoadout _unit;
	GVAR(arsenalDummy) attachTo [PVAR(arsenalDummySpawn)];

	if (!isNil QGVAR(arsenalLight) && {!isNull GVAR(arsenalLight)}) then {deleteVehicle GVAR(arsenalLight)};
	GVAR(arsenalLight) = "#lightpoint" createVehicleLocal [0,0,0];
	GVAR(arsenalLight) setPosWorld (getPosASL GVAR(arsenalDummy) vectorAdd [0,0,2]);
	GVAR(arsenalLight) setLightBrightness 0.2;
	GVAR(arsenalLight) setLightAmbient [1,1,1];
	GVAR(arsenalLight) setLightColor [1,1,1];
	GVAR(arsenalLight) attachTo [GVAR(arsenalDummy)];

	GVAR(arsenalUnit) = _unit;

	[_object,GVAR(arsenalDummy)] call ace_arsenal_fnc_openBox;
} else {
	[_object,_unit] call ace_arsenal_fnc_openBox;	
};
