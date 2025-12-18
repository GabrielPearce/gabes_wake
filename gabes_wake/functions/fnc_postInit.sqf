/*
 * Post-init script for gabes_wake.
 *
 * Registers an event handler on the ACE medical WakeUp event to
 * ensure that animation states are cleared whenever a unit
 * regains consciousness.  By using CBA’s event system, this runs
 * once on each machine during mission start.
 */

// Only run once on mission start
if (hasInterface || isDedicated) then {
    // Register event handler for when a unit wakes up
    ["ace_medical_WakeUp", {
        params ["_unit"];
        [_unit] call gabes_fnc_onWakeUp;
    }] call CBA_fnc_addEventHandler;
};