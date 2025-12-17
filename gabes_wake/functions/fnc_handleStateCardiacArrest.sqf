/*
 * Replacement for ACE3 handleStateCardiacArrest.
 * Instead of processing a dedicated cardiac arrest state (which
 * normally results in a death timer and no spontaneous wake-up),
 * this function redirects the state handling to the unconscious
 * state handler.  This effectively removes cardiac arrest and
 * allows units with stable vitals to wake up using the same logic
 * as the unconscious state.
 */
#include "\z\ace\addons\medical_statemachine\script_component.hpp"

params ["_unit"];

// If the unit is not local or dead, exit early.
if (!alive _unit || {!local _unit}) exitWith {};

// Redirect to the unconscious handler.  We call the
// ace_medical_statemachine handleStateUnconscious function,
// which has been overridden in this mod to provide a shorter
// wake‑up check interval.
[_unit] call ace_medical_statemachine_fnc_handleStateUnconscious;
