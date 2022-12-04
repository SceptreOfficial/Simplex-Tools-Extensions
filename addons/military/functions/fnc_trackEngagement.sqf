#include "script_component.hpp"

params ["_side","_respondingGroups","_targets"];

_respondingGroups = _respondingGroups select {({alive _x} count units _x) != 0 && !(_x getVariable [QGVAR(available),false])};

if (_respondingGroups isEqualTo []) exitWith {
	[QGVAR(cleanupTargets),[_side,_targets]] call CBA_fnc_serverEvent;
	DEBUG_1("Engagement: %1: No groups to respond",_targets);
};

[{
	params ["_args","_PFHID"];
	_args params ["_side","_respondingGroups","_targets","_oldUnknownTargets"];

	_respondingGroups = _respondingGroups select {({alive _x} count units _x) != 0 && !(_x getVariable [QGVAR(available),false])};

	// Stop if no more responding groups
	if (_respondingGroups isEqualTo []) exitWith {
		[QGVAR(cleanupTargets),[_side,_targets]] call CBA_fnc_serverEvent;
		_PFHID call CBA_fnc_removePerFrameHandler;
		DEBUG_1("Engagement: %1: No groups to respond",_targets);
	};

	// Forget about dead or empty targets
	private _deadTargets = _targets select {({alive _x} count crew _x) isEqualTo 0};
	
	if (_deadTargets isNotEqualTo []) then {
		[QGVAR(cleanupTargets),[_side,_deadTargets]] call CBA_fnc_serverEvent;
		_targets = _targets - _deadTargets;
		DEBUG_1("Engagement: %1: Dead/empty",_deadTargets);
	};

	// Stop if no more targets
	if (_targets isEqualTo []) exitWith {
		{_x setVariable [QGVAR(available),true,true]} forEach _respondingGroups;
		
		// Have units return to normal routine after a short time (if still available)
		[{
			{
				if (_x getVariable [QGVAR(available),false]) then {
					_x call FUNC(returnToOrigin);
				};
			} forEach _this
		},_respondingGroups,30 + random 60] call CBA_fnc_waitAndExecute;

		_PFHID call CBA_fnc_removePerFrameHandler;
		DEBUG("Engagement: No targets");
	};

	// Handle unknown targets
	private _newUnknownTargets = [];
	{_newUnknownTargets append (_x getVariable [QGVAR(unknownTargets),[]])} forEach _respondingGroups;

	private _unknownTargets = _oldUnknownTargets arrayIntersect _newUnknownTargets;

	if (_unknownTargets isNotEqualTo []) then {
		_targets = _targets - _unknownTargets;
		[QGVAR(cleanupTargets),[_side,_unknownTargets]] call CBA_fnc_serverEvent;
		DEBUG_1("Engagement: %1: Unknown",_unknownTargets);
	};

	{[QGVAR(checkUnknownTargets),[_x,_targets],_x] call CBA_fnc_targetEvent} forEach _respondingGroups;

	// Stop if no more targets
	if (_targets isEqualTo []) exitWith {
		{_x setVariable [QGVAR(available),true,true]} forEach _respondingGroups;

		// Have units return to normal routine after a short time (if still available)
		[{
			{
				if (_x getVariable [QGVAR(available),false]) then {
					_x call FUNC(returnToOrigin);
				};
			} forEach _this
		},_respondingGroups,30 + random 60] call CBA_fnc_waitAndExecute;

		_PFHID call CBA_fnc_removePerFrameHandler;
		DEBUG("Engagement: No targets");
	};

	private _knownTargets = _targets - _newUnknownTargets;

	if (_knownTargets isNotEqualTo []) then {
		// If engagement is failing, end it so targets can be re-evaluated normally
		([_respondingGroups,_side,_knownTargets] call FUNC(analyzeEngagement)) params ["_canEngage","_threatRating","_strength"];
		
		if ((!_canEngage && random 1 < 0.5) && _threatRating >= _strength) exitWith {
			{_x setVariable [QGVAR(available),true,true]} forEach _respondingGroups;

			// Have units return to normal routine after a short time (if still available)
			[{
				{
					if (_x getVariable [QGVAR(available),false]) then {
						_x call FUNC(returnToOrigin);
					};
				} forEach _this
			},_respondingGroups,30 + random 60] call CBA_fnc_waitAndExecute;
		
			_PFHID call CBA_fnc_removePerFrameHandler;
			DEBUG("Engagement: Threat too high");
		};

		// Engagment continues
		DEBUG_2("Engagement: %1 vs %2",_respondingGroups,_knownTargets);

		{
			private _target = _x getVariable [QGVAR(target),objNull];
			
			if (!alive _target || {{alive _x} count crew _target isEqualTo 0}) then {
				_target = selectRandom _knownTargets;
				_x setVariable [QGVAR(target),_target];
			};

			// Update WP position
			private _currentWP = [_x,currentWaypoint _x];
			
			if (waypointType _currentWP == "SAD") then {
				private _expectedPos = (leader _x) getHideFrom _target;
				_expectedPos set [2,0];

				if (_expectedPos isEqualTo [0,0,0]) exitWith {};
				
				_currentWP setWaypointPosition [_expectedPos,20];

				// Throw smokes
				[_group,ATLtoASL _expectedPos] call FUNC(smoke);
			};
		} forEach _respondingGroups;
	};

	_args set [1,_respondingGroups];
	_args set [2,_targets];
	_args set [3,_newUnknownTargets];
},60,[_side,_respondingGroups,_targets,[]]] call CBA_fnc_addPerFrameHandler;
