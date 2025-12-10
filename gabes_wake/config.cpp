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
    // === Cardiac Arrest overrides (NEW) ===
    class overwrite_ace_medical_status {
        tag = "ace_medical_status";  // must match ACE tag
        class ace_medical_status {
            // keep your hasStableVitals override
            class hasStableVitals {
                file = "\gabes_wake\functions\fnc_hasStableVitals.sqf";
            };
            // NEW: never allow CA to be set
            class setCardiacArrest {
                file = "\gabes_wake\functions\fnc_setCardiacArrest.sqf";
            };
            // NEW: always report "not in CA"
            class isInCardiacArrest {
                file = "\gabes_wake\functions\fnc_isInCardiacArrest.sqf";
            };
        };
    };

    // === Your existing unconscious tick override ===
    class overwrite_ace_medicalstatemachine {
        tag = "ace_medical_statemachine";
        class ace_medical_statemachine {
            class handleStateUnconscious {
                file = "\gabes_wake\functions\fnc_5seconds.sqf";
            };
        };
    };
};
