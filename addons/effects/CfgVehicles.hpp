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

	class GVAR(moduleInfiniteSmoke): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleInfiniteSmokeName);
		icon = "\a3\Modules_F_Curator\Data\portraitSmokeWhite_ca.paa";
		portrait = "\a3\Modules_F_Curator\Data\portraitSmokeWhite_ca.paa";
		function = QFUNC(moduleInfiniteSmoke);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;

		class Attributes: AttributesBase {
			class Color : Combo {
				displayName = CSTRING(ColorName);
				tooltip = CSTRING(ColorInfo);
				property = QGVAR(moduleInfiniteSmoke_Color);
				typeName = "STRING";
				class Values {
					class White {
						name = CSTRING(White);
						value = "SmokeShell_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitSmokeWhite_ca.paa";
						default = 1;
					};
					class Blue {
						name = CSTRING(Blue);
						value = "SmokeShellBlue_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitSmokeBlue_ca.paa";
					};
					class Green {
						name = CSTRING(Green);
						value = "SmokeShellGreen_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitSmokeGreen_ca.paa";
					};
					class Purple {
						name = CSTRING(Purple);
						value = "SmokeShellPurple_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitSmokePurple_ca.paa";
					};
					class Red {
						name = CSTRING(Red);
						value = "SmokeShellRed_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitSmokeRed_f_ca.paa";
					};
					class Orange {
						name = CSTRING(Orange);
						value = "SmokeShellOrange_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitSmokeOrange_ca.paa";
					};
					class Yellow {
						name = CSTRING(Yellow);
						value = "SmokeShellYellow_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitSmokeYellow_ca.paa";
					};
				};
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CSTRING(moduleInfiniteSmokeInfo);
		};
	};

	class GVAR(moduleInfiniteChemlight): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleInfiniteChemlightName);
		icon = "\a3\Modules_F_Curator\Data\portraitchemlight_ca.paa";
		portrait = "\a3\Modules_F_Curator\Data\portraitchemlight_ca.paa";
		function = QFUNC(moduleInfiniteChemlight);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;

		class Attributes: AttributesBase {
			class Color : Combo {
				displayName = CSTRING(ColorName);
				tooltip = CSTRING(ColorInfo);
				property = QGVAR(moduleInfiniteChemlight_Color);
				typeName = "STRING";
				class Values {
					class Blue {
						name = CSTRING(Blue);
						value = "Chemlight_blue_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitchemlightblue_ca.paa";
						default = 1;
					};
					class Green {
						name = CSTRING(Green);
						value = "Chemlight_green_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitchemlightgreen_ca.paa";
					};
					class Red {
						name = CSTRING(Red);
						value = "Chemlight_red_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitchemlightred_ca.paa";
					};
					class Yellow {
						name = CSTRING(Yellow);
						value = "Chemlight_yellow_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitchemlightyellow_ca.paa";
					};
				};
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CSTRING(moduleInfiniteChemlightInfo);
		};
	};

	class GVAR(moduleInfiniteFlare): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleInfiniteFlareName);
		icon = "\a3\Modules_F_Curator\Data\portraitflarewhite_ca.paa";
		portrait = "\a3\Modules_F_Curator\Data\portraitflarewhite_ca.paa";
		function = QFUNC(moduleInfiniteFlare);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;

		class Attributes: AttributesBase {
			class Color : Combo {
				displayName = CSTRING(ColorName);
				tooltip = CSTRING(ColorInfo);
				property = QGVAR(moduleInfiniteFlare_Color);
				typeName = "STRING";
				class Values {
					class White {
						name = CSTRING(White);
						value = "F_40mm_White_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitflarewhite_ca.paa";
						default = 1;
					};
					class Green {
						name = CSTRING(Green);
						value = "F_40mm_Green_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitflaregreen_ca.paa";
					};
					class Red {
						name = CSTRING(Red);
						value = "F_40mm_Red_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitflarered_ca.paa";
					};
					class Yellow {
						name = CSTRING(Yellow);
						value = "F_40mm_Yellow_Infinite";
						picture = "\a3\Modules_F_Curator\Data\portraitflareyellow_ca.paa";
					};
				};
			};

			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CSTRING(moduleInfiniteFlareInfo);
		};
	};

	class GVAR(moduleInfiniteIR): Module_F {
		author = "Simplex Team";
		category = QGVAR(modules);
		displayName = CSTRING(moduleInfiniteIRName);
		icon = "\a3\Modules_F_Curator\Data\portraitirgrenade_ca.paa";
		portrait = "\a3\Modules_F_Curator\Data\portraitirgrenade_ca.paa";
		function = QFUNC(moduleInfiniteIR);
		isGlobal = 1;
		scope = 2;
		scopeCurator = 2;
		curatorCanAttach = 0;

		class Attributes: AttributesBase {
			class ModuleDescription: ModuleDescription {};
		};

		class ModuleDescription: ModuleDescription {
			description = CSTRING(moduleInfiniteIRInfo);
		};
	};
};
