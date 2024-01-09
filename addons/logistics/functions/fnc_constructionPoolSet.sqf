#include "script_component.hpp"

params [["_source",sideUnknown,[sideUnknown,objNull]],["_pool",0,[0]]];

if (_source isEqualType objNull) then {
	_source = _source getVariable [QGVAR(constructionSide),side group _source];
};

missionNamespace setVariable [QGVAR(constructionPool_) + str _source,_pool,true];
