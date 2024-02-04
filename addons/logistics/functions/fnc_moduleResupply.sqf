#include "..\script_component.hpp"

params ["_logic","_synced"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];

	GVAR(resupplyPosASL) = getPosASL _logic;
	GVAR(resupplyVehicle) = attachedTo _logic;
	
	private _ix = lineIntersectsSurfaces [ATLtoASL positionCameraToWorld [0,0,0],GVAR(resupplyPosASL),_logic,objNull,true,1,"GEOM","FIRE"];
	if (_ix isNotEqualTo []) then {GVAR(resupplyPosASL) = _ix # 0 # 0};

	createDialog QGVAR(resupplyMenu);

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

