#include "..\script_component.hpp"

params ["_unit","_inhabitancy"];

_unit setVariable [QGVAR(brain),true,true];
_unit setVariable [QGVAR(inhabitancy),_inhabitancy,true];

//[QEGVAR(common,setSpeaker),[_unit,"NoVoice"]] call CBA_fnc_globalEvent;

_unit setSkill 0;
_unit setSpeedMode "LIMITED";
_unit setBehaviour "CARELESS";

_unit disableAI "TARGET";
_unit disableAI "AUTOTARGET";
_unit disableAI "FSM";
_unit disableAI "AIMINGERROR";
_unit disableAI "AUTOCOMBAT";
_unit disableAI "SUPPRESSION";
_unit disableAI "MINEDETECTION";
_unit disableAI "COVER";
_unit disableAI "WEAPONAIM";

_unit call FUNC(addPanic);

