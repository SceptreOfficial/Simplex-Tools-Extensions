#include "script_component.hpp"

///////////////////////////////////////////////////////////////////////////////////////////////////
// Ambient Aircraft

[QGVAR(autoStartAircraft),"CHECKBOX",
	[LSTRING(SettingName_autoStartAircraft),LSTRING(SettingInfo_autoStartAircraft)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientAircraft)],
	false,
	true,
	{},
	true
] call CBA_fnc_addSetting;

[QGVAR(aircraftChance),"SLIDER",
	[LSTRING(SettingName_aircraftChance),LSTRING(SettingInfo_aircraftChance)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientAircraft)],
	[0,1,0.5,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftMinTime),"SLIDER",
	[LSTRING(SettingName_aircraftMinTime),LSTRING(SettingInfo_aircraftMinTime)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientAircraft)],
	[30,1800,180,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftMaxTime),"SLIDER",
	[LSTRING(SettingName_aircraftMaxTime),LSTRING(SettingInfo_aircraftMaxTime)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientAircraft)],
	[30,1800,480,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftAltitude),"SLIDER",
	[LSTRING(SettingName_aircraftAltitude),LSTRING(SettingInfo_aircraftAltitude)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientAircraft)],
	[150,1500,600,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftSpawnDistance),"SLIDER",
	[LSTRING(SettingName_aircraftSpawnDistance),LSTRING(SettingInfo_aircraftSpawnDistance)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientAircraft)],
	[1000,6000,3000,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftTTL),"SLIDER",
	[LSTRING(SettingName_aircraftTTL),LSTRING(SettingInfo_aircraftTTL)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientAircraft)],
	[0,600,300,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(aircraftClassesStr),"EDITBOX",
	[LSTRING(SettingName_aircraftClassesStr),LSTRING(SettingInfo_aircraftClassesStr)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientAircraft)],
	"[""C_Heli_Light_01_civil_F"",1,""C_Plane_Civil_01_F"",1,""B_Plane_CAS_01_Cluster_F"",1,""B_Plane_Fighter_01_Cluster_F"",1]",
	true,
	{missionNamespace setVariable [QGVAR(aircraftClasses),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Ambient Civilians

[QGVAR(autoStart),"CHECKBOX",
	[LSTRING(SettingName_autoStart),LSTRING(SettingInfo_autoStart)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	false,
	true,
	{},
	true
] call CBA_fnc_addSetting;

[QGVAR(pedSpawnRadius),"SLIDER",
	[LSTRING(SettingName_pedSpawnRadius),LSTRING(SettingInfo_pedSpawnRadius)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	[150,1500,450,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverSpawnRadius),"SLIDER",
	[LSTRING(SettingName_driverSpawnRadius),LSTRING(SettingInfo_driverSpawnRadius)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	[150,1500,550,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedSpawnRadius),"SLIDER",
	[LSTRING(SettingName_parkedSpawnRadius),LSTRING(SettingInfo_parkedSpawnRadius)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	[150,1500,500,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(pedestrianCount),"SLIDER",
	[LSTRING(SettingName_pedestrianCount),LSTRING(SettingInfo_pedestrianCount)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	[0,30,6,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverCount),"SLIDER",
	[LSTRING(SettingName_driverCount),LSTRING(SettingInfo_driverCount)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	[0,20,3,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedCount),"SLIDER",
	[LSTRING(SettingName_parkedCount),LSTRING(SettingInfo_parkedCount)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	[0,20,5,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(unitClassesStr),"EDITBOX",
	[LSTRING(SettingName_unitClassesStr),LSTRING(SettingInfo_unitClassesStr)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	"[""C_Man_casual_2_F"",""C_Man_casual_3_F"",""C_man_w_worker_F"",""C_man_polo_2_F"",""C_Man_casual_1_F"",""C_man_polo_4_F""]",
	true,
	{missionNamespace setVariable [QGVAR(unitClasses),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;

[QGVAR(vehClassesStr),"EDITBOX",
	[LSTRING(SettingName_vehClassesStr),LSTRING(SettingInfo_vehClassesStr)],
	[LSTRING(category),LSTRING(SettingCategory_AmbientCivilians)],
	"[""C_Truck_02_fuel_F"",""C_Truck_02_box_F"",""C_Truck_02_covered_F"",""C_Offroad_01_repair_F"",""C_Van_01_box_F"",""C_Offroad_01_F"",""C_Offroad_01_covered_F"",""C_SUV_01_F""]",
	true,
	{missionNamespace setVariable [QGVAR(vehClasses),parseSimpleArray _this,true]},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Civilians: Experimental

[QGVAR(pedSpawnDelay),"SLIDER",
	[LSTRING(SettingName_pedSpawnDelay),LSTRING(SettingInfo_pedSpawnDelay)],
	[LSTRING(category),LSTRING(SettingCategory_CiviliansExperimental)],
	[0,5,0.2,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(driverSpawnDelay),"SLIDER",
	[LSTRING(SettingName_driverSpawnDelay),LSTRING(SettingInfo_driverSpawnDelay)],
	[LSTRING(category),LSTRING(SettingCategory_CiviliansExperimental)],
	[0,5,0.3,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(parkedSpawnDelay),"SLIDER",
	[LSTRING(SettingName_parkedSpawnDelay),LSTRING(SettingInfo_parkedSpawnDelay)],
	[LSTRING(category),LSTRING(SettingCategory_CiviliansExperimental)],
	[0,5,0.35,2],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(minPanicTime),"SLIDER",
	[LSTRING(SettingName_minPanicTime),LSTRING(SettingInfo_minPanicTime)],
	[LSTRING(category),LSTRING(SettingCategory_CiviliansExperimental)],
	[30,1200,120,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[QGVAR(useAgents),"CHECKBOX",
	[LSTRING(SettingName_useAgents),LSTRING(SettingInfo_useAgents)],
	[LSTRING(category),LSTRING(SettingCategory_CiviliansExperimental)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Civilian Interaction

[QGVAR(goAwayAction),"CHECKBOX",
	[LSTRING(SettingName_goAwayAction),LSTRING(SettingInfo_goAwayAction)],
	[LSTRING(category),LSTRING(SettingCategory_CivilianInteraction)],
	true,
	true,
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
	[0,10000,2000,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;
