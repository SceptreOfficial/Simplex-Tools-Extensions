#include "script_component.hpp"

params ["_logic"];

if (!local _logic) exitWith {};

[{
	params ["_logic","_synced"];
	
	if (isNull findDisplay IDD_RSCDISPLAYCURATOR) then {
		if (_synced isEqualTo []) exitWith {
			ALERT("No objects synced");
		};

		private _arguments = [
			_logic getVariable "MunitionDefaultsOnly",
			_logic getVariable "MedicalDefaultsOnly",
			_logic getVariable "MagazineCount",
			_logic getVariable "UnderbarrelCount",
			_logic getVariable "RocketCount",
			_logic getVariable "ThrowableCount",
			_logic getVariable "PlaceableCount",
			_logic getVariable "MedicalCount",
			_logic getVariable "MagazinesMultiply",
			_logic getVariable "UnderbarrelMultiply",
			_logic getVariable "RocketMultiply",
			_logic getVariable "ThrowableMultiply",
			_logic getVariable "PlaceableMultiply",
			_logic getVariable "MedicalMultiply"
		];

		private _groups = [];
		
		{
			_groups pushBackUnique group _x;
			_x setVariable [QGVAR(hasResupply),true,true];
		} forEach _synced;

		{_group setVariable [QGVAR(deployableResupplyArgs),_arguments,true]} forEach _groups;
	} else {
		private _object = attachedTo _logic;

		if (!alive _object) exitWith {
			ZEUS_MESSAGE("Invalid object");
		};

		[LLSTRING(moduleDeployableResupplyName),[
			["CHECKBOX",[LLSTRING(MunitionDefaultsOnlyName),LLSTRING(MunitionDefaultsOnlyInfo)],false,false],
			["CHECKBOX",[LLSTRING(MedicalDefaultsOnlyName),LLSTRING(MedicalDefaultsOnlyInfo)],true,false],
			["SLIDER",LLSTRING(MagazineCountName),[[0,100,0],20],false],
			["SLIDER",LLSTRING(UnderbarrelCountName),[[0,100,0],10],false],
			["SLIDER",LLSTRING(RocketCountName),[[0,100,0],10],false],
			["SLIDER",LLSTRING(ThrowableCountName),[[0,100,0],10],false],
			["SLIDER",LLSTRING(PlaceableCountName),[[0,100,0],10],false],
			["SLIDER",LLSTRING(MedicalCountName),[[0,100,0],20],false],
			["CHECKBOX",[LLSTRING(MagazinesMultiplyName),LLSTRING(countMultiply)],false,false],
			["CHECKBOX",[LLSTRING(UnderbarrelMultiplyName),LLSTRING(countMultiply)],false,false],
			["CHECKBOX",[LLSTRING(RocketMultiplyName),LLSTRING(countMultiply)],false,false],
			["CHECKBOX",[LLSTRING(ThrowableMultiplyName),LLSTRING(countMultiply)],false,false],
			["CHECKBOX",[LLSTRING(PlaceableMultiplyName),LLSTRING(countMultiply)],false,false],
			["CHECKBOX",[LLSTRING(MedicalMultiplyName),LLSTRING(countMultiply)],false,false]
		],{
			params ["_values","_object"];
			_object setVariable [QGVAR(hasResupply),true,true];
			group _object setVariable [QGVAR(deployableResupplyArgs),_values,true];
		},_object] call EFUNC(sdf,dialog);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
