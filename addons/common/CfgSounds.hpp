class CfgSounds {
	sounds[] = {};
	class GVAR(failure) {
		name = QGVAR(failure);
		sound[] = {QPATHTOF(sounds\failure.ogg),1,1};
		titles[] = {0,""};
	};
	class GVAR(success) {
		name = QGVAR(success);
		sound[] = {QPATHTOF(sounds\success.ogg),1,1};
		titles[] = {0,""};
	};
};
