/*
 * Override for ACE3 setCardiacArrestState.
 * Prevents units from ever entering cardiac arrest.  If an attempt
 * is made to set cardiac arrest, the unit is instead forced
 * unconscious and the cardiac arrest flag is cleared.  Clearing
 * cardiac arrest simply ensures the flag is off.
 */
#include "\z\ace\addons\main\script_mod.hpp"
#include "\z\ace\addons\main\script_macros.hpp"

params ["_unit", ["_state", true], ["_source", objNull]];

// If someone tries to enable cardiac arrest, refuse and ensure
// unconscious instead.  This makes gameplay continue without
// cardiac arrest mechanics.
if (_state) exitWith {
    // Make the unit unconscious; third parameter is duration (5 seconds)
    [_unit, true, 5, false] call ace_medical_fnc_setUnconscious;
    // Ensure the in‑cardiac‑arrest flag is cleared
    _unit setVariable ["ace_medical_inCardiacArrest", false, true];
    false
};

// Allow clearing; just make sure the flag is off
_unit setVariable ["ace_medical_inCardiacArrest", false, true];
true
