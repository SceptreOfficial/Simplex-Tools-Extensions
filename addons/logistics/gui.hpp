#include "script_component.hpp"
#include "\z\stx\addons\sdf\gui_macros.hpp"

class EGVAR(sdf,Checkbox);
class EGVAR(sdf,Text);
class EGVAR(sdf,ControlsGroup);
class EGVAR(sdf,ButtonSimple);
class EGVAR(sdf,Combobox);
class EGVAR(sdf,ControlsGroupNoScrollbars);
class EGVAR(sdf,Editbox);
class EGVAR(sdf,Tree);
class EGVAR(sdf,Slider);
class EGVAR(sdf,Listbox);
class EGVAR(sdf,Toolbox);

#define RESUPPLY_W 20
#define RESUPPLY_H 12
#define HUB_W 20
#define HUB_H 5

class GVAR(HubMenu) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(call FUNC(hubMenu));

	class Controls {
		class Title : EGVAR(sdf,Text) {
			idc = IDC_TITLE;
			x = TITLE_X(HUB_W);
			y = TITLE_Y(HUB_H);
			w = TITLE_W(HUB_W);
			h = TITLE_H;
			colorBackground[] = {QEGVAR(sdf,profileR),QEGVAR(sdf,profileG),QEGVAR(sdf,profileB),1};
			font = "PuristaMedium";
			text = "LOGISTICS HUB";
		};
		class Background : EGVAR(sdf,Text) {
			idc = IDC_BG;
			x = BG_X(HUB_W);
			y = BG_Y(HUB_H);
			w = BG_W(HUB_W);
			h = BG_H(HUB_H);
		};
		class Cancel : EGVAR(sdf,ButtonSimple) {
			idc = IDC_CANCEL;
			x = CANCEL_X(HUB_W);
			y = CANCEL_Y(HUB_H);
			w = MAIN_BUTTON_W;
			h = MAIN_BUTTON_H;
			font = "PuristaMedium";
			text = "CANCEL";
		};
		class Confirm : EGVAR(sdf,ButtonSimple) {
			idc = IDC_CONFIRM;
			x = CONFIRM_X(HUB_W);
			y = CONFIRM_Y(HUB_H);
			w = MAIN_BUTTON_W;
			h = MAIN_BUTTON_H;
			font = "PuristaMedium";
			text = "CONFIRM";
		};
		class ControlsGroup : EGVAR(sdf,ControlsGroup) {
			idc = IDC_GROUP;
			x = GROUP_X(HUB_W);
			y = GROUP_Y(HUB_H);
			w = GROUP_W(HUB_W);
			h = GROUP_H(HUB_H);

			class Controls {
				class GVAR(EditInventoriesText) : EGVAR(sdf,Text) {
					idc = IDC_HUB_EDITINV_TEXT;
					x = CTRL_X(0);
					y = CTRL_Y(0);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = CSTRING(EditInventoriesName);
					tooltip = CSTRING(EditInventoriesInfo);
				};
				class GVAR(EditInventories) : EGVAR(sdf,Checkbox) {
					idc = IDC_HUB_EDITINV;
					x = CTRL_X(8);
					y = CTRL_Y(0);
					w = CTRL_W(1);
					h = CTRL_H(1);
				};
				class GVAR(BoxSpawnText) : EGVAR(sdf,Text) {
					idc = IDC_HUB_BOXSPAWN_TEXT;
					x = CTRL_X(10);
					y = CTRL_Y(0);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = CSTRING(BoxSpawnName);
					tooltip = CSTRING(BoxSpawnInfo);
				};
				class GVAR(BoxSpawn) : EGVAR(sdf,Checkbox) {
					idc = IDC_HUB_BOXSPAWN;
					x = CTRL_X(18);
					y = CTRL_Y(0);
					w = CTRL_W(1);
					h = CTRL_H(1);
				};
				class GVAR(CanteenTapText) : EGVAR(sdf,Text) {
					idc = IDC_HUB_CANTEEN_TEXT;
					x = CTRL_X(0);
					y = CTRL_Y(1);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = CSTRING(CanteenTapName);
					tooltip = CSTRING(CanteenTapInfo);
				};
				class GVAR(CanteenTap) : EGVAR(sdf,Checkbox) {
					idc = IDC_HUB_CANTEEN;
					x = CTRL_X(8);
					y = CTRL_Y(1);
					w = CTRL_W(1);
					h = CTRL_H(1);
				};
				class GVAR(ConstructionResupplyText) : EGVAR(sdf,Text) {
					idc = IDC_HUB_CONSTRUCTION_TEXT;
					x = CTRL_X(10);
					y = CTRL_Y(1);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = CSTRING(ConstructionResupplyName);
					tooltip = CSTRING(ConstructionResupplyInfo);
				};
				class GVAR(ConstructionResupply) : EGVAR(sdf,Checkbox) {
					idc = IDC_HUB_CONSTRUCTION;
					x = CTRL_X(18);
					y = CTRL_Y(1);
					w = CTRL_W(1);
					h = CTRL_H(1);
				};
				class GVAR(ArsenalText) : EGVAR(sdf,Text) {
					idc = IDC_HUB_ARSENAL_TEXT;
					x = CTRL_X(0);
					y = CTRL_Y(2);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = CSTRING(ArsenalName);
					tooltip = CSTRING(ArsenalInfo);
				};
				class GVAR(Arsenal) : EGVAR(sdf,Checkbox) {
					idc = IDC_HUB_ARSENAL;
					x = CTRL_X(8);
					y = CTRL_Y(2);
					w = CTRL_W(1);
					h = CTRL_H(1);
				};
				class GVAR(WhitelistText) : EGVAR(sdf,Text) {
					idc = IDC_HUB_WHITELIST_TEXT;
					x = CTRL_X(0);
					y = CTRL_Y(3);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = "Arsenal whitelist";
				};
				class GVAR(Whitelist) : EGVAR(sdf,Combobox) {
					idc = IDC_HUB_WHITELIST;
					x = CTRL_X(8);
					y = CTRL_Y(3);
					w = CTRL_W(11);
					h = CTRL_H(1);

					class Items {
						class Disabled {
							text = "Disabled";
							default = 1;
						};
						class Setting {
							text = "Use setting";
						};
						class Custom {
							text = "Custom";
						};
						class Both {
							text = "Setting + Custom";
						};
					};
				};
				class GVAR(WhitelistEdit) : EGVAR(sdf,ButtonSimple) {
					idc = IDC_HUB_WHITELIST_EDIT;
					x = CTRL_X(19);
					y = CTRL_Y(3);
					w = CTRL_W(1);
					h = CTRL_H(1);
					sizeEx = GD_H(0.8);
					style = "0x02 + 0x30 + 0x800";
					text = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
				};
				class GVAR(BlacklistText) : EGVAR(sdf,Text) {
					idc = IDC_HUB_BLACKLIST_TEXT;
					x = CTRL_X(0);
					y = CTRL_Y(4);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = "Arsenal blacklist";
				};
				class GVAR(Blacklist) : EGVAR(sdf,Combobox) {
					idc = IDC_HUB_BLACKLIST;
					x = CTRL_X(8);
					y = CTRL_Y(4);
					w = CTRL_W(11);
					h = CTRL_H(1);

					class Items {
						class Disabled {
							text = "Disabled";
						};
						class Setting {
							text = "Use setting";
							default = 1;
						};
						class Custom {
							text = "Custom";
						};
						class Both {
							text = "Setting + Custom";
						};
					};
				};
				class GVAR(BlacklistEdit) : EGVAR(sdf,ButtonSimple) {
					idc = IDC_HUB_BLACKLIST_EDIT;
					x = CTRL_X(19);
					y = CTRL_Y(4);
					w = CTRL_W(1);
					h = CTRL_H(1);
					sizeEx = GD_H(0.8);
					style = "0x02 + 0x30 + 0x800";
					text = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
				};
			};
		};
	};
};

class GVAR(ResupplyMenu) {
	idd = -1;
	movingEnable = 0;
	enableSimulation = 1;
	onLoad = QUOTE(call FUNC(resupplyMenu));

	class Controls {
		class Title : EGVAR(sdf,Text) {
			idc = IDC_TITLE;
			x = TITLE_X(RESUPPLY_W);
			y = TITLE_Y(RESUPPLY_H);
			w = TITLE_W(RESUPPLY_W);
			h = TITLE_H;
			colorBackground[] = {QEGVAR(sdf,profileR),QEGVAR(sdf,profileG),QEGVAR(sdf,profileB),1};
			font = "PuristaMedium";
			text = "RESUPPLY";
		};
		class Background : EGVAR(sdf,Text) {
			idc = IDC_BG;
			x = BG_X(RESUPPLY_W);
			y = BG_Y(RESUPPLY_H);
			w = BG_W(RESUPPLY_W);
			h = BG_H(RESUPPLY_H);
		};
		class Cancel : EGVAR(sdf,ButtonSimple) {
			idc = IDC_CANCEL;
			x = CANCEL_X(RESUPPLY_W);
			y = CANCEL_Y(RESUPPLY_H);
			w = MAIN_BUTTON_W;
			h = MAIN_BUTTON_H;
			font = "PuristaMedium";
			text = "CANCEL";
		};
		class Confirm : EGVAR(sdf,ButtonSimple) {
			idc = IDC_CONFIRM;
			x = CONFIRM_X(RESUPPLY_W);
			y = CONFIRM_Y(RESUPPLY_H);
			w = MAIN_BUTTON_W;
			h = MAIN_BUTTON_H;
			font = "PuristaMedium";
			text = "CONFIRM";
		};
		class ControlsGroup : EGVAR(sdf,ControlsGroup) {
			idc = IDC_GROUP;
			x = GROUP_X(RESUPPLY_W);
			y = GROUP_Y(RESUPPLY_H);
			w = GROUP_W(RESUPPLY_W);
			h = GROUP_H(RESUPPLY_H);

			class Controls {
				class ApplicationText : EGVAR(sdf,Text) {
					idc = IDC_RESUPPLY_APPLICATION_TEXT;
					x = CTRL_X(0);
					y = CTRL_Y(0);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = "Application";
				};
				class Application : EGVAR(sdf,Combobox) {
					idc = IDC_RESUPPLY_APPLICATION;
					x = CTRL_X(8);
					y = CTRL_Y(0);
					w = CTRL_W(12);
					h = CTRL_H(1);

					class Items {
						class SpawnBox {
							text = "Spawn Box";
							picture = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\box_ca.paa";
							default = 1;
						};
						class LoadBox {
							text = "Load box in cargo";
							picture = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\getin_ca.paa";
						};
						class AirdropSimple {
							text = "Airdrop (Simple)";
							picture = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\container_ca.paa";
						};
						class AirdropFlyby {
							text = "Airdrop (Flyby)";
							picture = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\plane_ca.paa";
						};
					};
				};
				class ApplicationBG : EGVAR(sdf,Text) {
					idc = IDC_RESUPPLY_APPLICATION_BG;
					x = CTRL_X(0);
					y = CTRL_Y_BUFFER(1);
					w = CTRL_W(20);
					h = CTRL_H_BUFFER(1);
					colorBackground[] = {1,1,1,0.2};
				};
				class ApplicationGroup : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_RESUPPLY_APPLICATION_GROUP;
					x = GD_W(0);
					y = GD_H(1);
					w = GD_W(20);
					h = GD_H(1);

					class Controls {
						class BoxClassText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_BOX_CLASS_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(0);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Box class";
						};
						class BoxClass : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_BOX_CLASS;
							x = CTRL_X(8);
							y = CTRL_Y(0);
							w = CTRL_W(10);
							h = CTRL_H(1);
						};
						class BoxClassPicker : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RESUPPLY_BOX_CLASS_PICKER;
							x = CTRL_X(18);
							y = CTRL_Y(0);
							w = CTRL_W(1);
							h = CTRL_H(1);
							sizeEx = GD_H(0.8);
							style = "0x02 + 0x30 + 0x800";
							text = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
						};
						class CargoTypeText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_CARGO_TYPE_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(1);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Cargo type";
						};
						class CargoType : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_CARGO_TYPE;
							x = CTRL_X(8);
							y = CTRL_Y(1);
							w = CTRL_W(11);
							h = CTRL_H(1);

							class Items {
								class ACECargo {
									text = "ACE Cargo";
									picture = "\z\ace\addons\common\data\logo_ace3_ca.paa";
									default = 1;
								};
								class Unload {
									text = "'Unload' action";
									picture = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\getout_ca.paa";
								};
							};
						};
						class UnloadTimeText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_UNLOAD_TIME_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(2);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Unload time";
						};
						class UnloadTime : EGVAR(sdf,Slider) {
							idc = IDC_RESUPPLY_UNLOAD_TIME;
							x = CTRL_X(8);
							y = CTRL_Y(2);
							w = CTRL_W(9);
							h = CTRL_H(1);
						};
						class UnloadTimeEdit : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_UNLOAD_TIME_EDIT;
							x = CTRL_X(17);
							y = CTRL_Y(2);
							w = CTRL_W(2);
							h = CTRL_H(1);
						};
						class HeightText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_HEIGHT_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(1);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Height";
						};
						class Height : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_HEIGHT;
							x = CTRL_X(8);
							y = CTRL_Y(1);
							w = CTRL_W(11);
							h = CTRL_H(1);
						};
						class SignalsText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_SIGNALS_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(2);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Landing signals";
						};
						class Signal1 : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_SIGNAL1;
							x = CTRL_X(8);
							y = CTRL_Y(2);
							w = CTRL_W(5.5);
							h = CTRL_H(1);

							class Items {
								class None {
									text = "None";
									picture = "#(argb,8,8,3)color(0,0,0,0)";
									default = 1;
								};
								class BlueSmoke {
									text = "Blue Smoke";
									picture = "\a3\Modules_F_Curator\Data\portraitSmokeBlue_ca.paa";
									data = "SmokeShellBlue";
								};
								class GreenSmoke {
									text = "Green Smoke";
									picture = "\a3\Modules_F_Curator\Data\portraitSmokeGreen_ca.paa";
									data = "SmokeShellGreen";
								};
								class RedSmoke {
									text = "Red Smoke";
									picture = "\a3\Modules_F_Curator\Data\portraitSmokeRed_f_ca.paa";
									data = "SmokeShellRed";
								};
								class YellowSmoke {
									text = "Yellow Smoke";
									picture = "\a3\Modules_F_Curator\Data\portraitSmokeYellow_ca.paa";
									data = "SmokeShellYellow";
								};
								class BlueChemlight {
									text = "Blue Chemlight";
									picture = "\a3\Modules_F_Curator\Data\portraitChemlightBlue_ca.paa";
									data = "ACE_G_Chemlight_HiBlue";
								};
								class GreenChemlight {
									text = "Green Chemlight";
									picture = "\a3\Modules_F_Curator\Data\portraitChemlightGreen_ca.paa";
									data = "ACE_G_Chemlight_HiGreen";
								};
								class RedChemlight {
									text = "Red Chemlight";
									picture = "\a3\Modules_F_Curator\Data\portraitChemlightRed_ca.paa";
									data = "ACE_G_Chemlight_HiRed";
								};
								class YellowChemlight {
									text = "Yellow Chemlight";
									picture = "\a3\Modules_F_Curator\Data\portraitChemlightYellow_ca.paa";
									data = "ACE_G_Chemlight_HiYellow";
								};
								class IRStrobe {
									text = "IR Strobe";
									picture = "\a3\Modules_F_Curator\Data\portraitIRGrenade_ca.paa";
									data = "B_IRStrobe";
								};
							};
						};
						class Signal2 : Signal1 {
							idc = IDC_RESUPPLY_SIGNAL2;
							x = CTRL_X(13.5);
							w = CTRL_W(5.5);
						};
						class SideText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_SIDE_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(3);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Side";
						};
						class Side : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_SIDE;
							x = CTRL_X(8);
							y = CTRL_Y(3);
							w = CTRL_W(11);
							h = CTRL_H(1);

							class Items {
								class BLUFOR {
									text = "BLUFOR";
									picture = "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_west_ca.paa";
									default = 1;
								};
								class OPFOR {
									text = "OPFOR";
									picture = "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_east_ca.paa";
								};
								class Independent {
									text = "Independent";
									picture = "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_guer_ca.paa";
								};
								class Civilian {
									text = "Civilian";
									picture = "\a3\3DEN\Data\Displays\Display3DEN\PanelRight\side_civ_ca.paa";
								};
							};
						};
						class FactionText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_FACTION_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(4);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Faction";
						};
						class Faction : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_FACTION;
							x = CTRL_X(8);
							y = CTRL_Y(4);
							w = CTRL_W(11);
							h = CTRL_H(1);
						};
						class CategoryText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_CATEGORY_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(5);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Category";
						};
						class Category : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_CATEGORY;
							x = CTRL_X(8);
							y = CTRL_Y(5);
							w = CTRL_W(11);
							h = CTRL_H(1);
						};
						class VehicleText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_VEHICLE_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(6);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Vehicle";
						};
						class Vehicle : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_VEHICLE;
							x = CTRL_X(8);
							y = CTRL_Y(6);
							w = CTRL_W(11);
							h = CTRL_H(1);
						};
					};
				};
				class ContentsText : EGVAR(sdf,Text) {
					idc = IDC_RESUPPLY_CONTENTS_TEXT;
					x = CTRL_X(0);
					y = CTRL_Y(2);
					w = CTRL_W(8);
					h = CTRL_H(1);
					text = "Contents";
				};
				class Contents : EGVAR(sdf,Combobox) {
					idc = IDC_RESUPPLY_CONTENTS;
					x = CTRL_X(8);
					y = CTRL_Y(2);
					w = CTRL_W(12);
					h = CTRL_H(1);

					class Items {
						class Inventory {
							text = "Inventory";
							picture = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\documents_ca.paa";
							default = 1;
						};
						class Auto {
							text = "Auto fill";
							picture = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa";
						};
						class Arsenal {
							text = "Arsenal";
							picture = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\rifle_ca.paa";
						};
					};
				};
				class ContentsBG : EGVAR(sdf,Text) {
					idc = IDC_RESUPPLY_CONTENTS_BG;
					x = CTRL_X(0);
					y = CTRL_Y_BUFFER(3);
					w = CTRL_W(20);
					h = CTRL_H_BUFFER(1);
					colorBackground[] = {1,1,1,0.2};
				};
				class ContentsGroup : EGVAR(sdf,ControlsGroupNoScrollbars) {
					idc = IDC_RESUPPLY_CONTENTS_GROUP;
					x = GD_W(0);
					y = GD_H(3);
					w = GD_W(20);
					h = GD_H(1);

					class Controls {
						class CapacityLimitText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_CAPACITY_LIMIT_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(0);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Capacity limit";
						};
						class CapacityLimit : EGVAR(sdf,Checkbox) {
							idc = IDC_RESUPPLY_CAPACITY_LIMIT;
							x = CTRL_X(8);
							y = CTRL_Y(0);
							w = CTRL_W(1);
							h = CTRL_H(1);
						};
						class EditInventory : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RESUPPLY_EDIT_INV;
							x = CTRL_X(1);
							y = CTRL_Y(1);
							w = CTRL_W(18);
							h = CTRL_H(1);
							text = "EDIT INVENTORY";
						};
						class PresetsCategoryText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_PRESETS_CATEGORY_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(2);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Presets category";
						};
						class PresetsCategory : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_PRESETS_CATEGORY;
							x = CTRL_X(8);
							y = CTRL_Y(2);
							w = CTRL_W(11);
							h = CTRL_H(1);
							
							class Items {
								class Mission {
									text = "Mission";
									default = 1;
								};
								class Profile {
									text = "Profile";
								};
							};
						};
						class PresetsText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_PRESETS_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(3);
							w = CTRL_W(4);
							h = CTRL_H(4);
							text = "Presets";
						};
						class Presets : EGVAR(sdf,Listbox) {
							idc = IDC_RESUPPLY_PRESETS;
							x = CTRL_X(5);
							y = CTRL_Y(3);
							w = CTRL_W(14);
							h = CTRL_H(4);
							colorBackground[] = {0,0,0,1};
						};
						class PresetNameText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_PRESETS_NAME_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(7);
							w = CTRL_W(4);
							h = CTRL_H(1);
							text = "Name";
						};
						class PresetName : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_PRESETS_NAME;
							x = CTRL_X(5);
							y = CTRL_Y(7);
							w = CTRL_W(14);
							h = CTRL_H(1);
						};
						class PresetSave : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RESUPPLY_PRESETS_SAVE;
							x = CTRL_X(1);
							y = CTRL_Y(8);
							w = CTRL_W(4.5);
							h = CTRL_H(1);
							text = "SAVE";
						};
						class PresetRename : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RESUPPLY_PRESETS_RENAME;
							x = CTRL_X(5.5);
							y = CTRL_Y(8);
							w = CTRL_W(4.5);
							h = CTRL_H(1);
							text = "RENAME";
						};
						class PresetLoad : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RESUPPLY_PRESETS_LOAD;
							x = CTRL_X(10);
							y = CTRL_Y(8);
							w = CTRL_W(4.5);
							h = CTRL_H(1);
							text = "LOAD";
						};
						class PresetDelete : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RESUPPLY_PRESETS_DELETE;
							x = CTRL_X(14.5);
							y = CTRL_Y(8);
							w = CTRL_W(4.5);
							h = CTRL_H(1);
							text = "DELETE";
						};
						class WhitelistText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_WHITELIST_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(0);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Whitelist";
						};
						class Whitelist : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_WHITELIST;
							x = CTRL_X(8);
							y = CTRL_Y(0);
							w = CTRL_W(10);
							h = CTRL_H(1);

							class Items {
								class Disabled {
									text = "Disabled";
									default = 1;
								};
								class Setting {
									text = "Use setting";
								};
								class Custom {
									text = "Custom";
								};
								class Both {
									text = "Setting + Custom";
								};
							};
						};
						class WhitelistEdit : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RESUPPLY_WHITELIST_EDIT;
							x = CTRL_X(18);
							y = CTRL_Y(0);
							w = CTRL_W(1);
							h = CTRL_H(1);
							sizeEx = GD_H(0.8);
							style = "0x02 + 0x30 + 0x800";
							text = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
						};
						class BlacklistText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_BLACKLIST_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(1);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Blacklist";
						};
						class Blacklist : EGVAR(sdf,Combobox) {
							idc = IDC_RESUPPLY_BLACKLIST;
							x = CTRL_X(8);
							y = CTRL_Y(1);
							w = CTRL_W(10);
							h = CTRL_H(1);

							class Items {
								class Disabled {
									text = "Disabled";
								};
								class Setting {
									text = "Use setting";
									default = 1;
								};
								class Custom {
									text = "Custom";
								};
								class Both {
									text = "Setting + Custom";
								};
							};
						};
						class BlacklistEdit : EGVAR(sdf,ButtonSimple) {
							idc = IDC_RESUPPLY_BLACKLIST_EDIT;
							x = CTRL_X(18);
							y = CTRL_Y(1);
							w = CTRL_W(1);
							h = CTRL_H(1);
							sizeEx = GD_H(0.8);
							style = "0x02 + 0x30 + 0x800";
							text = "\A3\Ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa";
						};
						class Munitions : EGVAR(sdf,Toolbox) {
							idc = IDC_RESUPPLY_MUNITIONS;
							x = CTRL_X(1);
							y = CTRL_Y(0);
							w = CTRL_W(18);
							h = CTRL_H(1);
							columns = 2;
							rows = 1;
							strings[] = {"Default munitions","Active munitions"};
							tooltips[] = {"Only default mags for equipped weapons","All munitions in use"};
						};
						class Medical : EGVAR(sdf,Toolbox) {
							idc = IDC_RESUPPLY_MEDICAL;
							x = CTRL_X(1);
							y = CTRL_Y(1);
							w = CTRL_W(18);
							h = CTRL_H(1);
							columns = 2;
							rows = 1;
							strings[] = {"Default medical","Active medical"};
							tooltips[] = {"Only default medical items","All medical items in use"};
						};
						class MagazineCountText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_MAGAZINE_COUNT_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(2);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Magazine count";
						};
						class MagazineCountMultiply : EGVAR(sdf,Checkbox) {
							idc = IDC_RESUPPLY_MAGAZINE_MULTIPLY;
							x = CTRL_X(7);
							y = CTRL_Y(2);
							w = CTRL_W(1);
							h = CTRL_H(1);
							textureChecked = QPATHTOF(data\multiply.paa);
							textureFocusedChecked = QPATHTOF(data\multiply.paa);
							textureHoverChecked = QPATHTOF(data\multiply.paa);
							texturePressedChecked = QPATHTOF(data\multiply.paa);
							textureDisabledChecked = QPATHTOF(data\multiply.paa);
							tooltip = CSTRING(countMultiply);
						};
						class MagazineCount : EGVAR(sdf,Slider) {
							idc = IDC_RESUPPLY_MAGAZINE_COUNT;
							x = CTRL_X(8);
							y = CTRL_Y(2);
							w = CTRL_W(9);
							h = CTRL_H(1);
						};
						class MagazineCountEdit : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_MAGAZINE_COUNT_EDIT;
							x = CTRL_X(17);
							y = CTRL_Y(2);
							w = CTRL_W(2);
							h = CTRL_H(1);
						};
						class UnderbarrelCountText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_UNDERBARREL_COUNT_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(3);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Underbarrel count";
						};
						class UnderbarrelCountMultiply : MagazineCountMultiply {
							idc = IDC_RESUPPLY_UNDERBARREL_MULTIPLY;
							x = CTRL_X(7);
							y = CTRL_Y(3);
							w = CTRL_W(1);
							h = CTRL_H(1);
						};
						class UnderbarrelCount : EGVAR(sdf,Slider) {
							idc = IDC_RESUPPLY_UNDERBARREL_COUNT;
							x = CTRL_X(8);
							y = CTRL_Y(3);
							w = CTRL_W(9);
							h = CTRL_H(1);
						};
						class UnderbarrelCountEdit : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_UNDERBARREL_COUNT_EDIT;
							x = CTRL_X(17);
							y = CTRL_Y(3);
							w = CTRL_W(2);
							h = CTRL_H(1);
						};
						class RocketCountText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_ROCKET_COUNT_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(4);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Rocket count";
						};
						class RocketCountMultiply : MagazineCountMultiply {
							idc = IDC_RESUPPLY_ROCKET_MULTIPLY;
							x = CTRL_X(7);
							y = CTRL_Y(4);
							w = CTRL_W(1);
							h = CTRL_H(1);
						};
						class RocketCount : EGVAR(sdf,Slider) {
							idc = IDC_RESUPPLY_ROCKET_COUNT;
							x = CTRL_X(8);
							y = CTRL_Y(4);
							w = CTRL_W(9);
							h = CTRL_H(1);
						};
						class RocketCountEdit : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_ROCKET_COUNT_EDIT;
							x = CTRL_X(17);
							y = CTRL_Y(4);
							w = CTRL_W(2);
							h = CTRL_H(1);
						};
						class ThrowableCountText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_THROWABLE_COUNT_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(5);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Throwable count";
						};
						class ThrowableCountMultiply : MagazineCountMultiply {
							idc = IDC_RESUPPLY_THROWABLE_MULTIPLY;
							x = CTRL_X(7);
							y = CTRL_Y(5);
							w = CTRL_W(1);
							h = CTRL_H(1);
						};
						class ThrowableCount : EGVAR(sdf,Slider) {
							idc = IDC_RESUPPLY_THROWABLE_COUNT;
							x = CTRL_X(8);
							y = CTRL_Y(5);
							w = CTRL_W(9);
							h = CTRL_H(1);
						};
						class ThrowableCountEdit : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_THROWABLE_COUNT_EDIT;
							x = CTRL_X(17);
							y = CTRL_Y(5);
							w = CTRL_W(2);
							h = CTRL_H(1);
						};
						class PlaceableCountText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_PLACEABLE_COUNT_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(6);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Placeable count";
						};
						class PlaceableCountMultiply : MagazineCountMultiply {
							idc = IDC_RESUPPLY_PLACEABLE_MULTIPLY;
							x = CTRL_X(7);
							y = CTRL_Y(6);
							w = CTRL_W(1);
							h = CTRL_H(1);
						};
						class PlaceableCount : EGVAR(sdf,Slider) {
							idc = IDC_RESUPPLY_PLACEABLE_COUNT;
							x = CTRL_X(8);
							y = CTRL_Y(6);
							w = CTRL_W(9);
							h = CTRL_H(1);
						};
						class PlaceableCountEdit : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_PLACEABLE_COUNT_EDIT;
							x = CTRL_X(17);
							y = CTRL_Y(6);
							w = CTRL_W(2);
							h = CTRL_H(1);
						};
						class MedicalCountText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_MEDICAL_COUNT_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(7);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Medical count";
						};
						class MedicalCountMultiply : MagazineCountMultiply {
							idc = IDC_RESUPPLY_MEDICAL_MULTIPLY;
							x = CTRL_X(7);
							y = CTRL_Y(7);
							w = CTRL_W(1);
							h = CTRL_H(1);
						};
						class MedicalCount : EGVAR(sdf,Slider) {
							idc = IDC_RESUPPLY_MEDICAL_COUNT;
							x = CTRL_X(8);
							y = CTRL_Y(7);
							w = CTRL_W(9);
							h = CTRL_H(1);
						};
						class MedicalCountEdit : EGVAR(sdf,Editbox) {
							idc = IDC_RESUPPLY_MEDICAL_COUNT_EDIT;
							x = CTRL_X(17);
							y = CTRL_Y(7);
							w = CTRL_W(2);
							h = CTRL_H(1);
						};
						class UnitsText : EGVAR(sdf,Text) {
							idc = IDC_RESUPPLY_UNITS_TEXT;
							x = CTRL_X(1);
							y = CTRL_Y(8);
							w = CTRL_W(7);
							h = CTRL_H(1);
							text = "Units";
						};
						class UnitsToolbox : EGVAR(sdf,Toolbox) {
							idc = IDC_RESUPPLY_UNITS_TOOLBOX;
							x = CTRL_X(1);
							y = CTRL_Y(9);
							w = CTRL_W(7);
							h = CTRL_H(4);
							columns = 1;
							rows = 3;
							strings[] = {"SIDES","GROUPS","PLAYERS"};
						};
						class UnitsListbox : EGVAR(sdf,Listbox) {
							idc = IDC_RESUPPLY_UNITS_LISTBOX;
							x = CTRL_X(8);
							y = CTRL_Y(8);
							w = CTRL_W(11);
							h = CTRL_H(5);
							colorBackground[] = {0,0,0,1};
							colorSelect[] = {1,1,1,1};
							colorSelectBackground[] = {0,0,0,0};
							colorSelectBackground2[] = {0,0,0,0};
						};
					};
				};
				class BoxClassTree : EGVAR(sdf,Tree) {
					idc = IDC_RESUPPLY_BOX_CLASS_TREE;
					x = CTRL_X(8);
					y = CTRL_Y(1);
					w = CTRL_W(11);
					h = CTRL_H(9);
				};
			};
		};	
	};
};