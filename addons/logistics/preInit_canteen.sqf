#include "script_component.hpp"

[
	QGVAR(enableCanteen),
	"CHECKBOX",
	[LSTRING(enableCanteenName),LSTRING(enableCanteenInfo)],
	[LSTRING(category),LSTRING(canteen)],
	true,
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(canteenCapacity),
	"SLIDER",
	[LSTRING(canteenCapacityName),LSTRING(canteenCapacityInfo)],
	[LSTRING(category),LSTRING(canteen)],
	[0,20,4,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

[QGVAR(canteenTapAdded),{
	params [["_object",objNull,[objNull]]];

	[_object,0,["ACE_MainActions"],
		[QGVAR(canteenRefill),LLSTRING(fillCanteen),"\z\ace\addons\field_rations\ui\icon_water_tap.paa",{
			(_this # 1) setVariable [QGVAR(canteenSips),GVAR(canteenCapacity)];
			LLSTRING(canteenFull) call EFUNC(common,hint);
		},{
			GVAR(enableCanteen) && "ACE_Canteen" in (_this # 1 call ace_common_fnc_uniqueItems)
		}] call ace_interact_menu_fnc_createAction
	] call ace_interact_menu_fnc_addActionToObject;

	[_object,0,["ACE_MainActions"],
		[QGVAR(canteenGet),LLSTRING(getCanteen),"\z\ace\addons\field_rations\ui\item_canteen_co.paa",{
			(_this # 1) addItem "ACE_Canteen";
			LLSTRING(canteenRetrieved) call EFUNC(common,hint);
		},{
			GVAR(enableCanteen) && !("ACE_Canteen" in (_this # 1 call ace_common_fnc_uniqueItems))
		}] call ace_interact_menu_fnc_createAction
	] call ace_interact_menu_fnc_addActionToObject;
}] call CBA_fnc_addEventHandler;

["CAManBase",1,["ACE_SelfActions"],[
	QGVAR(canteenSip),
	LLSTRING(drinkCanteen),
	"\z\ace\addons\field_rations\ui\icon_hud_thirststatus.paa",
	FUNC(canteenSip),
	{GVAR(enableCanteen) && "ACE_Canteen" in (_this # 1 call ace_common_fnc_uniqueItems)},
	{},
	[],
	nil,
	nil,
	nil,
	{
		_this # 3 set [1,format [
			LLSTRING(drinkCanteenFormat),
			round (((_this # 0 getVariable [QGVAR(canteenSips),GVAR(canteenCapacity)]) / GVAR(canteenCapacity)) * 100),"%"
		]]
	}
] call ace_interact_menu_fnc_createAction,true] call ace_interact_menu_fnc_addActionToClass;
