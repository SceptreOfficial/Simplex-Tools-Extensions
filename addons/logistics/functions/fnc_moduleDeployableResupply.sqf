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
			(_logic getVariable "MunitionDefaultsOnly") call EFUNC(common,parseCheckbox),
			(_logic getVariable "MedicalDefaultsOnly") call EFUNC(common,parseCheckbox),
			[_logic getVariable "MagazineCount",(_logic getVariable "MagazinesMultiply") call EFUNC(common,parseCheckbox)],
			[_logic getVariable "UnderbarrelCount",(_logic getVariable "UnderbarrelMultiply") call EFUNC(common,parseCheckbox)],
			[_logic getVariable "RocketCount",(_logic getVariable "RocketMultiply") call EFUNC(common,parseCheckbox)],
			[_logic getVariable "ThrowableCount",(_logic getVariable "ThrowableMultiply") call EFUNC(common,parseCheckbox)],
			[_logic getVariable "PlaceableCount",(_logic getVariable "PlaceableMultiply") call EFUNC(common,parseCheckbox)],
			[_logic getVariable "MedicalCount",(_logic getVariable "MedicalMultiply") call EFUNC(common,parseCheckbox)]
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
			["CHECKBOX",[LLSTRING(MagazinesMultiplyName),LLSTRING(countMultiply)],false,false],
			["SLIDER",LLSTRING(UnderbarrelCountName),[[0,100,0],10],false],
			["CHECKBOX",[LLSTRING(UnderbarrelMultiplyName),LLSTRING(countMultiply)],false,false],
			["SLIDER",LLSTRING(RocketCountName),[[0,100,0],10],false],
			["CHECKBOX",[LLSTRING(RocketMultiplyName),LLSTRING(countMultiply)],false,false],
			["SLIDER",LLSTRING(ThrowableCountName),[[0,100,0],10],false],
			["CHECKBOX",[LLSTRING(ThrowableMultiplyName),LLSTRING(countMultiply)],false,false],
			["SLIDER",LLSTRING(PlaceableCountName),[[0,100,0],10],false],
			["CHECKBOX",[LLSTRING(PlaceableMultiplyName),LLSTRING(countMultiply)],false,false],
			["SLIDER",LLSTRING(MedicalCountName),[[0,100,0],20],false],
			["CHECKBOX",[LLSTRING(MedicalMultiplyName),LLSTRING(countMultiply)],false,false]
		],{
			params ["_values","_object"];
			_values params [
				"_munitionDefaultsOnly",
				"_medicalDefaultsOnly",
				"_magazineCount",
				"_magazinesMultiply",
				"_underbarrelCount",
				"_underbarrelMultiply",
				"_rocketCount",
				"_rocketsMultiply",
				"_throwableCount",
				"_throwablesMultiply",
				"_placeableCount",
				"_placeablesMultiply",
				"_medicalCount",
				"_medicalMultiply"
			];

			_object setVariable [QGVAR(hasResupply),true,true];
			group _object setVariable [QGVAR(deployableResupplyArgs),[
				_munitionDefaultsOnly,
				_medicalDefaultsOnly,
				[_magazineCount,_magazinesMultiply],
				[_underbarrelCount,_underbarrelMultiply],
				[_rocketCount,_rocketsMultiply],
				[_throwableCount,_throwablesMultiply],
				[_placeableCount,_placeablesMultiply],
				[_medicalCount,_medicalMultiply]
			],true];
		},_object] call EFUNC(sdf,dialog);
	};

	deleteVehicle _logic;
},_this] call CBA_fnc_execNextFrame;
