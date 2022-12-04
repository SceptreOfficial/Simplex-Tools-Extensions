#include "script_component.hpp"

params ["_vehicle","_unit"];

["Unloading resupply crate",(_vehicle getVariable QGVAR(resupplyOptions)) # 1,{
	(_this # 0) params ["_vehicle","_unit"];
	alive _vehicle && _vehicle getVariable [QGVAR(resupply),false]
},{
	(_this # 0) params ["_vehicle","_unit"];

	[_vehicle getVariable [QGVAR(resupplyJIPID),-1],_vehicle] call CBA_fnc_removeGlobalEventJIP;
	_vehicle setVariable [QGVAR(resupplyJIPID),nil,true];
	_vehicle setVariable [QGVAR(resupply),nil,true];

	private _options = _vehicle getVariable QGVAR(resupplyOptions);
	private _crate = (_options # 0) createVehicle [0,0,0];
	_crate setVariable [QGVAR(resupplyOptions),+_options,true];

	QGVAR(hint) cutText ["Resupply unloaded","PLAIN",0.1];
	[{QGVAR(hint) cutFadeOut 1},[],1] call CBA_fnc_waitAndExecute;

	[{
		params ["_vehicle","_unit","_crate","_onUnload"];

		_crate setPosASL getPosASL _unit;
		
		[_crate,_vehicle,_unit] call _onUnload;

		private _JIPID = [QGVAR(resupplyUnloaded),[_crate,_vehicle,_unit]] call CBA_fnc_globalEventJIP;
		[_JIPID,_crate] call CBA_fnc_removeGlobalEventJIP;
	},[_vehicle,_unit,_crate,_options # 4],0.5] call CBA_fnc_waitAndExecute;
},{},[_vehicle,_unit]] spawn CBA_fnc_progressBar;
