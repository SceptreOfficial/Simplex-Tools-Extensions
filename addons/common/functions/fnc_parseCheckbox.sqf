#include "script_component.hpp"

params ["_value"];

[_value,_value == 1] select (_value isEqualType 0)
