#include "..\script_component.hpp"

params ["_IDC"];

selectRandomWeighted (switch _IDC do {
	case 2002 : {[
		"acts_rifle_operations_left",1,
		"acts_rifle_operations_right",1,
		"acts_rifle_operations_zeroing",1,
		"acts_rifle_operations_back",0.8,
		"acts_rifle_operations_barrel",0.3,
		"acts_rifle_operations_checking_chamber",1,
		"acts_ambient_relax_1",1,
		"acts_ambient_relax_2",1,
		"acts_ambient_relax_3",1,
		"acts_ambient_relax_4",1
	]};
	case 2004 : {[
		"acts_examining_device_player",1
	]};
	default {[
		"c4coming2cdf_genericstani1",1,
		"c4coming2cdf_genericstani2",1,
		"c4coming2cdf_genericstani4",1,
		"acts_briefing_sa_loop",1,
		"acts_briefing_sb_loop",1,
		"acts_getattention_loop",1,
		"acts_civillistening_1",1,
		"acts_civillistening_2",1,
		"acts_millercamp_a",1,
		"acts_aidlpercmstpslowwrfldnon_warmup_5_loop",1,
		"acts_aidlpercmstpsnonwnondnon_warmup_1_loop",1,
		"acts_aidlpercmstpsnonwnondnon_warmup_2_loop",1,
		"acts_aidlpercmstpsnonwnondnon_warmup_3_loop",1,
		//"acts_aidlpercmstpsnonwnondnon_warmup_4_loop",1,
		//"acts_aidlpercmstpsnonwnondnon_warmup_5_loop",1,
		"acts_civilidle_1",1,
		"acts_ambient_relax_1",1,
		"acts_ambient_relax_2",1,
		"acts_ambient_relax_3",1,
		"acts_ambient_relax_4",1,
		"InBaseMoves_patrolling1",1,
		"InBaseMoves_patrolling2",1
	]};
})
