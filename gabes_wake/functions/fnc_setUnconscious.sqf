/*
 * Global override for ACE3 setUnconscious.
 *
 * This wrapper enforces a minimum unconscious duration of 3 seconds on
 * all calls to ace_medical_fnc_setUnconscious.  It forwards the
 * parameters to the original ACE script, but clamps the
 * `_minWaitingTime` argument to at least 3 seconds.  After
 * invoking the original implementation, it updates the
 * `ace_medical_lastWakeUpCheck` variable so that the first
 * spontaneous wake‑up check happens only after the clamped
 * `_minWaitingTime` (and aligns with our 3‑second base interval).  Without
 * this, ACE initialises the timestamp based on its 15‑second
 * `SPONTANEOUS_WAKE_UP_INTERVAL`, which would cause an immediate
 * wake‑up in our shortened system.
 */

#include "\z\ace\addons\main\script_mod.hpp"
#include "\z\ace\addons\main\script_macros.hpp"

params ["_unit", ["_knockOut", true, [false]], ["_minWaitingTime", 0, [0]], ["_forcedWakeup", false, [false]]];

// Require a valid unit and local execution
if (isNull _unit || {!(_unit isKindOf "CAManBase")} || {!alive _unit}) exitWith {false};

// Clamp minimum waiting time to at least 3 seconds
private _minWait = _minWaitingTime;
if (_minWait < 3) then { _minWait = 3; };

// Call the original ACE setUnconscious script from its file path
// Using compile preprocessFileLineNumbers ensures we don’t call our own override
private _result = [ _unit, _knockOut, _minWait, _forcedWakeup ] call (compile preprocessFileLineNumbers "\z\ace\addons\medical\functions\fnc_setUnconscious.sqf");

// If the unit was knocked out, update the wake‑up timestamp
if (_knockOut) then {
    // Only adjust if spontaneous wake‑up is enabled
    if (EGVAR(medical,spontaneousWakeUpChance) > 0) then {
        // Set lastWakeUpCheck to now + _minWait - 3 seconds.  When
        // _minWait == 3, this equals now; the first check will occur
        // once 3 seconds have passed.  For longer waits, this ensures
        // the first check happens after the full minimum duration.
        _unit setVariable [QEGVAR(medical,lastWakeUpCheck), CBA_missionTime + _minWait - 3, true];
    };
};

// Return whatever the original function returned
_result