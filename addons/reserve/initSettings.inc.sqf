[
	QGVAR(loadDistance),
	"SLIDER",
	DESC(loadDistance),
	[LSTRING(category),""],
	[0,10000,3500,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;

[
	QGVAR(saveDistance),
	"SLIDER",
	DESC(saveDistance),
	[LSTRING(category),""],
	[0,10000,4000,0],
	true,
	{},
	false
] call CBA_fnc_addSetting;