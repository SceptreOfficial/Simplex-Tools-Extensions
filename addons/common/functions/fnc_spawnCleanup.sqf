#include "script_component.hpp"

params ["_obj"];

if (!alive _obj) then {
	deleteVehicle _obj;
} else {
	if (side group _obj != civilian) then {
		private _pos = getPosVisual _obj;
		if (_pos # 2 > 3) then {
			_pos set [2,0.2];
			_obj setVehiclePosition [_pos,[],0,"NONE"];
		};
		
		if (vectorUp _obj # 2 < 0) then {
			private _pos = getPosVisual _obj;
			_pos set [2,(_pos # 2 + 0.2) max 0.2];
			_obj setVectorUp surfaceNormal getPosVisual _obj;
			_obj setPos getPos _obj;
		};
	};

	[{_this allowDamage true},_obj] call CBA_fnc_execNextFrame;
};