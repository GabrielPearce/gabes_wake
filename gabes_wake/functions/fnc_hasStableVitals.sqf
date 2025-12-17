/*
 * Determines if a unit has stable vitals for spontaneous wake‑up.
 * We base stability purely on blood volume and introduce a random
 * chance when blood volume is low.  If the blood volume is above
 * the class 2 haemorrhage threshold, the unit is considered stable.
 * For volumes below class 2 and class 4 thresholds, a random 50 %
 * chance determines stability.  This means lower blood takes
 * longer to wake, since hasStableVitals will return false roughly
 * half the time.
 */
#include "\z\ace\addons\medical_engine\script_macros_medical.hpp"
#include "\z\ace\addons\medical_engine\script_macros_config.hpp"
#include "\z\ace\addons\main\script_mod.hpp"
#include "\z\ace\addons\main\script_macros.hpp"

params ["_unit"];

// Use blood volume thresholds to determine stability.  Units with
// reasonable blood (> class 2 haemorrhage) are considered stable.
private _bloodVol = GET_BLOOD_VOLUME(_unit);
if (_bloodVol > BLOOD_VOLUME_CLASS_2_HEMORRHAGE) exitWith {true};

// Extremely low blood (<= class 4 haemorrhage) never counts as stable.
// This prevents units with critically low blood from waking up and
// immediately collapsing again.
if (_bloodVol <= BLOOD_VOLUME_CLASS_4_HEMORRHAGE) exitWith {false};

// Moderate blood loss (between class 2 and class 4) has a lower
// probability to be considered stable.  Reducing the chance from 50 %
// to 25 % (random 4 < 1) makes bounce‑backs less likely while still
// allowing some rare spontaneous recovery.
if ((GET_BLOOD_VOLUME(_unit) <= BLOOD_VOLUME_CLASS_2_HEMORRHAGE) && {random 4 < 1}) exitWith {true};

// By default vitals are considered unstable
false
