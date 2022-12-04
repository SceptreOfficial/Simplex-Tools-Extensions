#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
#include "cba_settings.sqf"

///////////////////////////////////////////////////////////////////////////////////////////////////

[QGVAR(addPanic),{
	params ["_civ"];
	[_civ,"FiredNear",FUNC(panic)] call CBA_fnc_addBISEventHandler;
}] call CBA_fnc_addEventHandler;

if (isServer) then {
	[QGVAR(addPanicServer),{
		params ["_civ"];

		if (_civ getVariable [QGVAR(willPanic),false]) exitWith {};
		_civ setVariable [QGVAR(willPanic),true,true];

		private _JIPID = [QGVAR(addPanic),_civ] call CBA_fnc_globalEventJIP;
		[_JIPID,_civ] call CBA_fnc_removeGlobalEventJIP;

		// Mod compat
		(group _civ) setVariable ["lambs_danger_disableGroupAI",true,true];
		_civ setVariable ["lambs_danger_disableAI",true,true];
	}] call CBA_fnc_addEventHandler;
};

///////////////////////////////////////////////////////////////////////////////////////////////////

[QGVAR(setSpeaker),{
	params ["_unit","_voice"];
	_unit setSpeaker _voice;
}] call CBA_fnc_addEventHandler;

[QGVAR(doMove),{
	params ["_unit","_pos"];
	_unit doMove _pos;
}] call CBA_fnc_addEventHandler;

///////////////////////////////////////////////////////////////////////////////////////////////////

GVAR(blacklist) = []; // Blacklist areas (Can be of type: marker, trigger, location, area array)
GVAR(spawnPoints) = [];
GVAR(aircraftRunner) = objNull;
GVAR(civiliansRunner) = objNull;
GVAR(ambientAircraft) = false;
GVAR(ambientCivilians) = false;

if (isServer) then {
	if (isNil QGVAR(brainEFID)) then {
		GVAR(brainList) = [];
		GVAR(brainEFID) = addMissionEventHandler ["EachFrame",{call FUNC(brain)}];
	};

	// Handle HC disconnect
	addMissionEventHandler ["HandleDisconnect",{
		params ["_unit"];

		if (isNull GVAR(aircraftRunner) || isNull GVAR(civiliansRunner)) exitWith {false};

		if (_unit isEqualTo GVAR(aircraftRunner) && GVAR(ambientAircraft)) then {
			missionNamespace setVariable [QGVAR(ambientAircraft),false,true];
			missionNamespace setVariable [QGVAR(aircraftRunner),objNull,true];
		};

		if (_unit isEqualTo GVAR(civiliansRunner) && GVAR(ambientCivilians)) then {
			missionNamespace setVariable [QGVAR(ambientCivilians),false,true];
			missionNamespace setVariable [QGVAR(civiliansRunner),objNull,true];
		};

		false
	}];

	[QGVAR(toggle),{
		params [["_localitySelection",0,[0]],"_toggleFnc","_toggleVar","_runnerVar"];

		private _running = missionNamespace getVariable [_toggleVar,false];
		private _runner = missionNamespace getVariable [_runnerVar,objNull];

		// End on HC
		if (!isNull _runner) exitWith {
			[QEGVAR(common,execute),[[],_toggleFnc],_runner] call CBA_fnc_targetEvent;
			missionNamespace setVariable [_runnerVar,objNull,true];
		};

		// End on server
		if (_running) exitWith {[] call _toggleFnc};

		if (_localitySelection > count EGVAR(common,headlessClients)) exitWith {
			diag_log "Headless client(s) disconnected during selection. Cancelling occupation.";
		};

		// Server exec
		if (_localitySelection == 0) exitWith {
			missionNamespace setVariable [_runnerVar,objNull,true];
			[] call _toggleFnc;
		};

		// HC exec
		if (_localitySelection > 0) then {
			private _headlessClient = EGVAR(common,headlessClients) # (_localitySelection - 1);
			missionNamespace setVariable [_runnerVar,_headlessClient,true];
			[QEGVAR(common,execute),[[],_toggleFnc],_headlessClient] call CBA_fnc_targetEvent;
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(localityExec),{
		params ["_localitySelection","_params","_fncVar"];

		if (_localitySelection > (count EGVAR(common,headlessClients) + 1)) exitWith {
			diag_log ("Headless client(s) disconnected during selection. Cancelling execution of " + _fncVar);
		};

		if (_localitySelection == 1) exitWith {
			_params call (missionNamespace getVariable [_fncVar,{}]);
		};

		if (_localitySelection > 1) then {
			[QEGVAR(common,execute),[[],_fncVar],EGVAR(common,headlessClients) # (_localitySelection - 2)] call CBA_fnc_targetEvent;
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(addBlacklist),{
		params [["_area",[],["",objNull,locationNull,[]],5]];

		_area = [_area] call CBA_fnc_getArea;

		if (_area isEqualTo []) exitWith {};

		GVAR(blacklist) pushBack _area;
		publicVariable QGVAR(blacklist);
	}] call CBA_fnc_addEventHandler;
};


ADDON = true;
