#include "script_component.hpp"

params [["_source",sideUnknown,[sideUnknown,objNull]]];

if (_source isEqualType objNull) then {
	_source = _source getVariable [QGVAR(constructionSide),side group _source];
};

missionNamespace getVariable [QGVAR(constructionPool_) + str _source,-1]
