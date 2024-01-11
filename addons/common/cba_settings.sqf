#include "script_component.hpp"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Preferences

[
	QGVAR(hintType),
	"LIST",
	[LSTRING(hintTypeName),LSTRING(hintTypeInfo)],
	[LSTRING(category),LSTRING(preferences)],
	[[0,1,2,3],[
		LSTRING(hintType_Hint),
		LSTRING(hintType_HintSilent),
		LSTRING(hintType_TitleEffect),
		LSTRING(hintType_SystemChat)
	],2],
	false,
	{},
	false
] call CBA_fnc_addSetting;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Arsenal filtering

[
	QGVAR(arsenalWhitelistStr),
	"EDITBOX",
	[LSTRING(arsenalWhitelistName),LSTRING(arsenalWhitelistInfo)],
	[LSTRING(category),LSTRING(arsenal)],
	"",
	true,
	{GVAR(arsenalWhitelist) = _this call FUNC(parseList)},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(arsenalBlacklistStr),
	"EDITBOX",
	[LSTRING(arsenalBlacklistName),LSTRING(arsenalBlacklistInfo)],
	[LSTRING(category),LSTRING(arsenal)],
	"",
	true,
	{GVAR(arsenalBlacklist) = _this call FUNC(parseList)},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(arsenalDummyEnabled),
	"CHECKBOX",
	[LSTRING(arsenalDummyEnabledName),LSTRING(arsenalDummyEnabledInfo)],
	[LSTRING(category),LSTRING(arsenal)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(arsenalAnimEnabled),
	"CHECKBOX",
	[LSTRING(arsenalAnimEnabledName),LSTRING(arsenalAnimEnabledInfo)],
	[LSTRING(category),LSTRING(arsenal)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// AI Sub-skills

[
	QGVAR(applySubSkills),
	"CHECKBOX",
	[LSTRING(applySubSkillsName),LSTRING(applySubSkillsInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillGeneral),
	"SLIDER",
	[LSTRING(skillGeneralName),LSTRING(skillGeneralInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillCommanding),
	"SLIDER",
	[LSTRING(skillCommandingName),LSTRING(skillCommandingInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillCourage),
	"SLIDER",
	[LSTRING(skillCourageName),LSTRING(skillCourageInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillAimingAccuracy),
	"SLIDER",
	[LSTRING(skillAimingAccuracyName),LSTRING(skillAimingAccuracyInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillAimingShake),
	"SLIDER",
	[LSTRING(skillAimingShakeName),LSTRING(skillAimingShakeInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillAimingSpeed),
	"SLIDER",
	[LSTRING(skillAimingSpeedName),LSTRING(skillAimingSpeedInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillReloadSpeed),
	"SLIDER",
	[LSTRING(skillReloadSpeedName),LSTRING(skillReloadSpeedInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillSpotDistance),
	"SLIDER",
	[LSTRING(skillSpotDistanceName),LSTRING(skillSpotDistanceInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(skillSpotTime),
	"SLIDER",
	[LSTRING(skillSpotTimeName),LSTRING(skillSpotTimeInfo)],
	[LSTRING(category),LSTRING(subSkills)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Slingloading

[
	QGVAR(slingloadMassOverride),
	"CHECKBOX",
	[LSTRING(slingloadMassOverrideName),LSTRING(slingloadMassOverrideInfo)],
	[LSTRING(category),LSTRING(slingloading)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Auto-deploy parachute

[
	QOPTION(autoParachute),
	"CHECKBOX",
	["Auto deploy parachute"],//[LSTRING(slingloadMassOverrideName),LSTRING(slingloadMassOverrideInfo)],
	[LSTRING(category),"Parachute"],//[LSTRING(category),LSTRING(slingloading)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

