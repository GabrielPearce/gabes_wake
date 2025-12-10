#include "\z\ace\addons\medical_engine\script_macros_medical.hpp"
#include "\z\ace\addons\medical_engine\script_macros_config.hpp"
#include "\z\ace\addons\main\script_mod.hpp"
#include "\z\ace\addons\main\script_macros.hpp"

params ["_unit"];

if (GET_BLOOD_VOLUME(_unit) > BLOOD_VOLUME_CLASS_2_HEMORRHAGE) exitwith {true};

if ((GET_BLOOD_VOLUME(_unit) <= BLOOD_VOLUME_CLASS_2_HEMORRHAGE) && {random 2 < 1}) exitwith {true};

if ((GET_BLOOD_VOLUME(_unit) <= BLOOD_VOLUME_CLASS_4_HEMORRHAGE) && {random 2 < 1}) exitwith {true};
