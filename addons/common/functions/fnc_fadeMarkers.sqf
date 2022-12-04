#include "script_component.hpp"

params [["_markers",[],[[]]],["_duration",6,[0]],["_local",false,[false]],["_delete",true,[false]]];

[{
	params ["_args","_PFHID"];
	_args params ["_markers","_start","_end","_local","_delete"];

	if (CBA_missionTime > _end) exitWith {
		if (_local) then {
			{deleteMarkerLocal (_x # 0)} forEach _markers;
		} else {
			{deleteMarker (_x # 0)} forEach _markers;
		};
	};

	if (_local) then {
		{
			_x params ["_marker","_alpha"];
			_marker setMarkerAlphaLocal linearConversion [_start,_end,CBA_missionTime,_alpha,0,true];
		} forEach _markers;
	} else {
		{
			_x params ["_marker","_alpha"];
			_marker setMarkerAlpha linearConversion [_start,_end,CBA_missionTime,_alpha,0,true];
		} forEach _markers;
	};
},1,[
	_markers apply {[_x,markerAlpha _x]},
	CBA_missionTime,
	CBA_missionTime + _duration,
	_local,
	_delete
]] call CBA_fnc_addPerFrameHandler;
