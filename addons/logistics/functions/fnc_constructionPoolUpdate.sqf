#include "script_component.hpp"

params [["_source",sideUnknown,[sideUnknown,objNull]],["_change",0,[0]]];

if (_source isEqualType objNull) then {
	_source = _source getVariable [QGVAR(constructionSide),side group _source];
};

private _pool = _source call FUNC(constructionPool);

if (_pool != -1) then {
	missionNamespace setVariable [QGVAR(constructionPool_) + str _source,_pool + _change,true];
};
