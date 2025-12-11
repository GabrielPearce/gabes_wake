/*
 * Replacement for ACE3 enteredStateCardiacArrest.
 * Whenever the state machine attempts to enter the cardiac arrest
 * state, we instead initialise the unit as unconscious.  This avoids
 * setting cardiac‑arrest timers and keeps the unit in a normal
 * unconscious state.
 */
#include "\z\ace\addons\medical_statemachine\script_component.hpp"

params ["_unit"];

// If the unit is null or already has a recorded cause of death, abort.
if (isNull _unit || {!isNil {_unit getVariable QEGVAR(medical,causeOfDeath)}}) exitWith {};

// Use the ACE function for entering unconsciousness rather than
// cardiac arrest.  This ensures status variables are initialised for
// unconscious state but avoids cardiac‑arrest timers.
[_unit] call ace_medical_statemachine_fnc_enteredStateUnconscious;
