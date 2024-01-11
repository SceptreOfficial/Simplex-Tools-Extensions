#include "script_component.hpp"

[
	QOPTION(debug),
	"CHECKBOX",
	[LSTRING(debugName),LSTRING(debugInfo)],
	[LSTRING(category),LSTRING(categoryGeneral)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;
