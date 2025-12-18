/*
 * Override for ACE3 enteredStateUnconscious.
 *
 * This function is called by the ACE medical state machine when a unit
 * enters the unconscious state.  We wrap the original implementation
 * to ensure that the `ace_medical_lastWakeUpCheck` variable is reset
 * to the current mission time.  Without this reset, ACE’s default
 * `setUnconscious` function sets the last wake‑up check to
 * `CBA_missionTime - SPONTANEOUS_WAKE_UP_INTERVAL` (15 seconds in the
 * base mod), which causes our shorter 3‑second wake‑up interval to
 * trigger immediately when the unconscious handler runs.  By
 * explicitly setting the timestamp here, we guarantee that the first
 * wake‑up check occurs only after the configured interval.
 */

#include "\z\ace\addons\medical_statemachine\script_component.hpp"

params ["_unit"];

// Only proceed for living local units
if (isNull _unit || {!alive _unit} || {!local _unit}) exitWith {};

// Call the original ACE function to perform standard setup
// We use call instead of spawn to preserve the synchronous nature
[_unit] call ace_medical_statemachine_fnc_enteredStateUnconscious;

// Reset last wake‑up check to the current mission time so that the
// first spontaneous wake‑up roll happens after the base interval
_unit setVariable [QEGVAR(medical,lastWakeUpCheck), CBA_missionTime, true];

// Ensure the in‑cardiac‑arrest flag remains cleared
_unit setVariable ["ace_medical_inCardiacArrest", false, true];

true