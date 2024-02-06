class CBA_Extended_EventHandlers_base;

class CfgVehicles {
	class Logic;
	class Module_F : Logic {
		class AttributesBase {
			class Default;
			class Combo;
			class Edit;
			class Checkbox;
			class ModuleDescription;
		};
		class ModuleDescription;	
	};

	class GVAR(moduleSave): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CNAME(moduleSave);
		icon = "\A3\3den\data\displays\display3den\toolbar\save_ca.paa";
		portrait = "\A3\3den\data\displays\display3den\toolbar\save_ca.paa";
		function = QFUNC(moduleSave);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 1;
		curatorCanAttach = 1;

		class Attributes: AttributesBase {
			class RespawnCategory {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = CSTRING(RespawnCategory);
				description = "";
			};
			class RespawnDelay : Edit {
				ATTRIBUTE(RespawnDelay);
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class RespawnQuantity : Edit {
				ATTRIBUTE(RespawnQuantity);
				typeName = "NUMBER";
				defaultValue = 0;
			};
			class RespawnRatio : Default {
				ATTRIBUTE(RespawnRatio);
				typeName = "NUMBER";
				defaultValue = 0.1;
				control = "Slider";
			};
			class RespawnWaveMode : Checkbox {
				ATTRIBUTE(RespawnWaveMode);
				typeName = "BOOL";
				defaultValue = "false";
			};
			class OtherCategory {
				data = "AttributeSystemSubcategory";
				control = "SubCategory";
				displayName = CSTRING(OtherCategory);
				description = "";
			};
			class GroupInit : Default {
				ATTRIBUTE(GroupInit);
				typeName = "STRING";
				defaultValue = "''";
				control = "EditCodeMulti5";
				validate = "expression";
			};
			//class LoadTrigger : Edit {
			//	ATTRIBUTE(LoadTrigger);
			//	typeName = "STRING";
			//	defaultValue = "''";
			//};
			//class SaveTrigger : Edit {
			//	ATTRIBUTE(SaveTrigger);
			//	typeName = "STRING";
			//	defaultValue = "''";
			//};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleSave);
		};
	};

	class GVAR(moduleSpawnArea): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CNAME(moduleSpawnArea);
		icon = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
		portrait = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
		function = "";//QFUNC(moduleSpawnArea);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 1;
		canSetArea = 1;
		canSetAreaHeight = 1;
		canSetAreaShape = 1;

		class AttributeValues {
			isRectangle = 1;
			size3[] = {50,50,50};
		};

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CINFO(moduleSpawnArea);
		};
	};
};
