// Override for ACE3 handleStateUnconscious
#include "\z\ace\addons\medical_statemachine\script_component.hpp"
/*
 * Author: BaerMitUmlaut (adapted)
 * Handles the unconscious state with a shorter wake‑up check interval.
 * Units update their vitals, cardiac arrest is cleared, and a
 * spontaneous wake‑up check is performed every few seconds.  This
 * version uses a base interval of 3 seconds instead of ACE’s
 * default 15 and clears the cardiac arrest flag so units never
 * remain in ACE’s cardiac arrest state.
 */

params ["_unit"];

// If the unit died the loop is finished
if (!alive _unit || {!local _unit}) exitWith {};

[_unit] call EFUNC(medical_vitals,handleUnitVitals);
// Ensure the in‑cardiac‑arrest variable is never set
_unit setVariable ["ace_medical_inCardiacArrest", false, true];

// Handle spontaneous wake up from unconsciousness
if (EGVAR(medical,spontaneousWakeUpChance) > 0) then {
    if (_unit call EFUNC(medical_status,hasStableVitals)) then {
        private _lastWakeUpCheck = _unit getVariable QEGVAR(medical,lastWakeUpCheck);

        // Handle setting being changed mid-mission and still properly check
        // already unconscious units, should handle locality changes as well
        if (isNil "_lastWakeUpCheck") exitWith {
            TRACE_1("undefined lastWakeUpCheck: setting to current time",_lastWakeUpCheck);
            _unit setVariable [QEGVAR(medical,lastWakeUpCheck), CBA_missionTime];
        };

        // Base wake‑up check interval.  A lower blood volume will
        // delay wake‑up checks via hasStableVitals random chance; we set
        // the base to 3 seconds instead of ACE’s default 15.
        private _wakeUpCheckInterval = 3;
        if (EGVAR(medical,spontaneousWakeUpEpinephrineBoost) > 1) then {
            private _epiEffectiveness = ([_unit, "Epinephrine", false] call EFUNC(medical_status,getMedicationCount)) select 1;
            _wakeUpCheckInterval = _wakeUpCheckInterval * linearConversion [0, 1, _epiEffectiveness, 1, 1 / EGVAR(medical,spontaneousWakeUpEpinephrineBoost), true];
            TRACE_2("epiBoost",_epiEffectiveness,_wakeUpCheckInterval);
        };
        if (CBA_missionTime - _lastWakeUpCheck > _wakeUpCheckInterval) then {
            TRACE_2("Checking for wake up",_unit,EGVAR(medical,spontaneousWakeUpChance));
            _unit setVariable [QEGVAR(medical,lastWakeUpCheck), CBA_missionTime];

            if (random 1 <= EGVAR(medical,spontaneousWakeUpChance)) then {
                TRACE_1("Spontaneous wake up!",_unit);
                [QEGVAR(medical,WakeUp), _unit] call CBA_fnc_localEvent;
            };
        };
    } else {
        // Unstable vitals, procrastinate the next wakeup check
        private _lastWakeUpCheck = _unit getVariable [QEGVAR(medical,lastWakeUpCheck), 0];
        _unit setVariable [QEGVAR(medical,lastWakeUpCheck), _lastWakeUpCheck max CBA_missionTime];
    };
};
