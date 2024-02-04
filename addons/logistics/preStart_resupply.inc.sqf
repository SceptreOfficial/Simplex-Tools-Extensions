private _sideHash = createHashMapFromArray [[west,createHashMap],[east,createHashMap],[independent,createHashMap],[civilian,createHashMap]];
private _sides = [0,1,2,3];
private _vehicleTypes = ["car","armored","air","ship","support","autonomous"];
private _list = [];
private _factions = configFile >> "CfgFactionClasses";

{
    private _class = configName _x;

    if (
        _class != "" &&
        {getNumber (_x >> "scope") >= 2} &&
        {getNumber (_x >> "side") in _sides} &&
        {toLower (getText (_x >> "vehicleClass")) in _vehicleTypes}
    ) then {
        _list pushBack [getText (_x >> "displayName") + " - " + getText (_factions >> getText (_x >> "faction") >> "displayName"),_class];
    };
} forEach configProperties [configFile >> "CfgVehicles","isClass _x",true];

_list sort true;
_list apply {[_x # 1,_x # 0]}