// Block entering cardiac arrest; force plain unconscious instead
#include "\z\ace\addons\main\script_mod.hpp"
#include "\z\ace\addons\main\script_macros.hpp"

params ["_unit", ["_state", true], ["_source", objNull]];

// If someone tries to enable CA, refuse and ensure unconscious instead
if (_state) exitWith {
    // make them unconscious so gameplay continues without CA mechanics
    [_unit, true, 5, false] call ace_medical_fnc_setUnconscious;
    _unit setVariable ["ace_medical_inCardiacArrest", false, true];
    false
};

// Allow clearing; just make sure flag is off
_unit setVariable ["ace_medical_inCardiacArrest", false, true];
true
