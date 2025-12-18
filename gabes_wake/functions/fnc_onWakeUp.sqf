/*
 * Animation reset handler for ACE wake‑up event.
 *
 * When a unit wakes up from unconsciousness, ACE sometimes leaves
 * the body stuck in the unconscious pose for other players.  This
 * function clears ACE’s unconscious flags, re-enables animation
 * simulation, and forces a standing action so the unit appears
 * upright for all clients.
 */

params ["_unit"];

// Validate the unit
if (isNull _unit) exitWith {};

// Clear ACE unconscious flag
_unit setVariable ["ACE_isUnconscious", false, true];

// Ensure animation simulation and AI are enabled
_unit enableSimulationGlobal true;
_unit enableAI "ANIM";

// Force the unit into a standing animation (rifle relaxed)
_unit playActionNow "AmovPknlMstpSrasWrflDnon";