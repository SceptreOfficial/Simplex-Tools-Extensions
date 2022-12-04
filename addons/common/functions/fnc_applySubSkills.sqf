#include "script_component.hpp"

params ["_unit"];

if (_unit getVariable [QGVAR(setSkills),true] && side group _unit in [west,east,independent]) then {
	_unit setSkill ["general",GVAR(skillGeneral)];
	_unit setSkill ["commanding",GVAR(skillCommanding)];
	_unit setSkill ["courage",GVAR(skillCourage)];
	_unit setSkill ["aimingAccuracy",GVAR(skillAimingAccuracy)];
	_unit setSkill ["aimingShake",GVAR(skillAimingShake)];
	_unit setSkill ["aimingSpeed",GVAR(skillAimingSpeed)];
	_unit setSkill ["reloadSpeed",GVAR(skillReloadSpeed)];
	_unit setSkill ["spotDistance",GVAR(skillSpotDistance)];
	_unit setSkill ["spotTime",GVAR(skillSpotTime)];	
};
