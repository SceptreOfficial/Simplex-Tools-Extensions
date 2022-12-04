#include "script_component.hpp"

if (isNil QGVAR(occupationQueue)) then {
	GVAR(occupationQueue) = [];
};

GVAR(occupationQueue) pushBack _this;

if (isNil QGVAR(occupationQueuePFHID)) then {
	GVAR(occupationQueuePFHID) = [{
		if (GVAR(occupationQueue) isEqualTo []) exitWith {
			GVAR(occupationQueuePFHID) call CBA_fnc_removePerFrameHandler;
			GVAR(occupationQueuePFHID) = nil;
		};

		(GVAR(occupationQueue) deleteAt 0) call FUNC(occupyQueueProcess);
	},0.3] call CBA_fnc_addPerFrameHandler;
};
