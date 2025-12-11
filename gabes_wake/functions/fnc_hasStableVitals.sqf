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

// If blood volume is above class 2 haemorrhage threshold, vitals are stable
if (GET_BLOOD_VOLUME(_unit) > BLOOD_VOLUME_CLASS_2_HEMORRHAGE) exitwith {true};

// Below class 2 haemorrhage: 50 % chance to be stable
if ((GET_BLOOD_VOLUME(_unit) <= BLOOD_VOLUME_CLASS_2_HEMORRHAGE) && {random 2 < 1}) exitwith {true};

// Below class 4 haemorrhage: 50 % chance to be stable
if ((GET_BLOOD_VOLUME(_unit) <= BLOOD_VOLUME_CLASS_4_HEMORRHAGE) && {random 2 < 1}) exitwith {true};
