#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

// Hover helper ghost
["ModuleCurator_F","Init",{
	params ["_logic"];
	
	_logic addEventHandler ["CuratorObjectEdited",{
		params ["_curator","_object"];

		if (_object getVariable [QGVAR(hoverData),[]] isNotEqualTo []) then {
			_object setVectorUp [0,0,1];

			if (CBA_events_shift && isNull (_object getVariable [QGVAR(hoverHelper),objNull])) then {
				_object getVariable QGVAR(hoverData) params ["_class","_placingPoint"];

				private _helper = createSimpleObject [_class,[0,0,0],true];
				_helper setDir getDirVisual _object;
				_helper attachTo [_object,_placingPoint vectorMultiply -1];
				
				_object setVariable [QGVAR(hoverHelper),_helper];
			};
		};
	}];
},true,[],true] call CBA_fnc_addClassEventHandler;

ADDON = true;
