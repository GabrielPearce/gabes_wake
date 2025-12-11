#include "BIS_AddonInfo.hpp"

class CfgPatches {
    class my_mod {
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.10;
        // Make sure we load AFTER ACE medical so our overrides win
        requiredAddons[] = {
            "ace_main",
            "ace_medical_engine",
            "ace_medical_status",
            "ace_medical_statemachine",
            "ace_medical_vitals"
        };
        author = "Your Name";
        authors[] = {"Your Name"};
        version = "1.0";
        versionStr = "1.0";
        versionAr[] = {1,0};
        name = "My Mod";
        url = "http://www.my-mod-website.com";
        onLoadMission = "hint 'My Mod Loaded';";
    };
};

class CfgFunctions {
    // === Cardiac Arrest overrides ===
    class overwrite_ace_medical_status {
        tag = "ace_medical_status";
        class ace_medical_status {
            // override stable vitals to allow low blood with a random chance
            class hasStableVitals {
                file = "\gabes_wake\functions\fnc_hasStableVitals.sqf";
            };
            // block entering cardiac arrest and force unconscious instead
            class setCardiacArrest {
                file = "\gabes_wake\functions\fnc_setCardiacArrest.sqf";
            };
            // always report that no unit is in cardiac arrest
            class isInCardiacArrest {
                file = "\gabes_wake\functions\fnc_isInCardiacArrest.sqf";
            };
        };
    };

    // === Override state machine to remove cardiac arrest ===
    class overwrite_ace_medicalstatemachine {
        tag = "ace_medical_statemachine";
        class ace_medical_statemachine {
            // shorter wake‑up interval and clear cardiac arrest flag
            class handleStateUnconscious {
                file = "\gabes_wake\functions\fnc_5seconds.sqf";
            };
            // redirect cardiac arrest handling to unconscious handler
            class handleStateCardiacArrest {
                file = "\gabes_wake\functions\fnc_handleStateCardiacArrest.sqf";
            };
            // when entering cardiac arrest, treat as entering unconscious
            class enteredStateCardiacArrest {
                file = "\gabes_wake\functions\fnc_enteredStateCardiacArrest.sqf";
            };
            // disable cardiac arrest death timer
            class conditionCardiacArrestTimer {
                file = "\gabes_wake\functions\fnc_conditionCardiacArrestTimer.sqf";
            };
        };
    };
};
