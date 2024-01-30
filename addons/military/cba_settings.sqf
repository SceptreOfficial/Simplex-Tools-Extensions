#include "script_component.hpp"

///////////////////////////////////////////////////////////////////////////////////////////////////
// Development

[QGVAR(debug),"CHECKBOX",
	[LSTRING(SettingName_debug),LSTRING(SettingInfo_debug)],
	[LSTRING(category),LSTRING(SettingCategory_Development)],
	false,
	false,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Caching

[QGVAR(cachingEnabled),"CHECKBOX",
	[LSTRING(SettingName_cachingEnabled),LSTRING(SettingInfo_cachingEnabled)],
	[LSTRING(category),LSTRING(SettingCategory_Caching)],
	true,
	true,
	{},
	true
] call CBA_fnc_addSetting;

[QGVAR(cachingDefault),"CHECKBOX",
	[LSTRING(SettingName_cachingDefault),LSTRING(SettingInfo_cachingDefault)],
	[LSTRING(category),LSTRING(SettingCategory_Caching)],
	false,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(cachingDistance),"SLIDER",
	[LSTRING(SettingName_cachingDistance),LSTRING(SettingInfo_cachingDistance)],
	[LSTRING(category),LSTRING(SettingCategory_Caching)],
	[0,10000,3500,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Spotting

[QGVAR(RatingHelicopter),"SLIDER",
	[LSTRING(SettingName_RatingHelicopter),LSTRING(SettingInfo_RatingHelicopter)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[1,20,7,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(RatingTank),"SLIDER",
	[LSTRING(SettingName_RatingTank),LSTRING(SettingInfo_RatingTank)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[1,20,6,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(RatingCar),"SLIDER",
	[LSTRING(SettingName_RatingCar),LSTRING(SettingInfo_RatingCar)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[1,20,3,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(AssistCoef),"SLIDER",
	[LSTRING(SettingName_AssistCoef),LSTRING(SettingInfo_AssistCoef)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[1,10,1.4,1],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(QRFRatio),"SLIDER",
	[LSTRING(SettingName_QRFRatio),LSTRING(SettingInfo_QRFRatio)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[0.1,1,0.7,1,true],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(flaresEnabled),"CHECKBOX",
	[LSTRING(SettingName_flaresEnabled),LSTRING(SettingInfo_flaresEnabled)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(flaresChance),"SLIDER",
	[LSTRING(SettingName_flaresChance),LSTRING(SettingInfo_flaresChance)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[0,1,0.3,1,true],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeEnabled),"CHECKBOX",
	[LSTRING(SettingName_smokeEnabled),LSTRING(SettingInfo_smokeEnabled)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeChance),"SLIDER",
	[LSTRING(SettingName_smokeChance),LSTRING(SettingInfo_smokeChance)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[0,1,0.5,0,true],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeColorWEST),"LIST",
	[LSTRING(SettingName_smokeColorWEST),LSTRING(SettingInfo_smokeColorWEST)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[[0,1,2,3,4],[LLSTRING(White),LLSTRING(Blue),LLSTRING(Green),LLSTRING(Yellow),LLSTRING(Red)],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeColorEAST),"LIST",
	[LSTRING(SettingName_smokeColorEAST),LSTRING(SettingInfo_smokeColorEAST)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[[0,1,2,3,4],[LLSTRING(White),LLSTRING(Blue),LLSTRING(Green),LLSTRING(Yellow),LLSTRING(Red)],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(smokeColorGUER),"LIST",
	[LSTRING(SettingName_smokeColorGUER),LSTRING(SettingInfo_smokeColorGUER)],
	[LSTRING(category),LSTRING(SettingCategory_Spotting)],
	[[0,1,2,3,4],[LLSTRING(White),LLSTRING(Blue),LLSTRING(Green),LLSTRING(Yellow),LLSTRING(Red)],0],
	true,
	{},
	false
] call CBA_fnc_addSetting;
