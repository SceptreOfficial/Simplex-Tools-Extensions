#include "script_component.hpp"

params [["_message","",["",{}]],["_args",[],[[]]]];

if (_message isEqualType "") then {
	if (isLocalized _message) then {
		_message = localize _message;
	};

	if (_args isNotEqualTo []) then {
		_message = format ([_message] + _args);
	};
} else {
	_message = _args call _message;
};

_message
