#include "script_component.hpp"

if (GVAR(brainList) isEqualTo []) exitWith {
	GVAR(brainList) = allUnits select {
		local _x &&
		{side group _x isEqualTo civilian} &&
		{_x getVariable [QGVAR(hasBrain),false]}
	};
};

private _civ = GVAR(brainList) deleteAt 0;

if (
	alive _civ && 
	{!(_civ getVariable [QGVAR(panicking),false])} && 
	{unitReady _civ || _civ getVariable [QGVAR(moveTick),-1] < CBA_missionTime}
) then {
	_civ setVariable [QGVAR(moveTick),CBA_missionTime + 200];

	doStop _civ;

	[{
		private _civ = _this;

		if (!alive _civ) exitWith {};

		private _area = _civ getVariable [QGVAR(inhabitancy),[getPos _civ,100,100,0,false]];

		// Get random position
		private "_randPos";
		while {
			_randPos = [_area,false] call CBA_fnc_randPosArea;
			surfaceIsWater _randPos
		} do {};

		if (_civ in _civ) then {
			// 50% chance to base random pos from civ current position
			if (random 1 < 0.5) then {
				while {
					_randPos = _civ getPos [60 + random 40,random 360];
					surfaceIsWater _randPos
				} do {};
			};

			private _buildings = nearestObjects [_randPos,["Building"],100,true];

			// Move to a nearby building if possible
			if (_buildings isNotEqualTo []) then {
				_randPos = _buildings # 0 getPos [random 15,random 360];
			};
		} else {
			// Try to find a road position to send vehicles
			private _area = +_area;
			_area set [1,_area # 1 + 150];
			_area set [2,_area # 2 + 150];

			private _try = 0;
			while {
				while {
					_randPos = [_area,true] call CBA_fnc_randPosArea;
					surfaceIsWater _randPos
				} do {};
				
				private _road = [_randPos,_randPos nearRoads 450] call EFUNC(common,getNearest);

				if (!isNull _road) exitWith {
					_randPos = getPosATL _road;
					false
				};

				if (_try > 2) exitWith {false};
					
				_try = _try + 1;

				true
			} do {};
		};

		_civ doFollow _civ;
		_civ setSpeedMode "LIMITED";
		_civ doMove _randPos;
	},_civ,3] call CBA_fnc_waitAndExecute;
};
