#include "script_component.hpp"

if (GVAR(ambientAircraft)) then {
	// End
	GVAR(aircraftPFHID) call CBA_fnc_removePerFrameHandler;
	GVAR(aircraftPFHID) = nil;

	missionNamespace setVariable [QGVAR(ambientAircraft),false,true];
} else {
	// Start
	GVAR(aircraftSpawnTick) = -1;
	GVAR(aircraftPFHID) = [{
		if (GVAR(aircraftSpawnTick) > CBA_missionTime) exitWith {};
		
		GVAR(aircraftSpawnTick) = CBA_missionTime + GVAR(aircraftMinTime) + random GVAR(aircraftMaxTime);
		
		if (random 1 > GVAR(aircraftChance)) exitWith {};

		private _player = selectRandom (allPlayers select {!(_x isKindOf "HeadlessClient_F")});

		if (isNil "_player") exitWith {};

		private _startPos = _player getPos [GVAR(aircraftSpawnDistance),random 360];
		private _endPos = _startPos getPos [GVAR(aircraftSpawnDistance) * 2,_startPos getDir _player];

		[selectRandomWeighted GVAR(aircraftClasses),_startPos,_endPos,GVAR(aircraftAltitude)] call FUNC(spawnAircraft);
	},1,[]] call CBA_fnc_addPerFrameHandler;

	missionNamespace setVariable [QGVAR(ambientAircraft),true,true];
};
