/*
 * Replacement for ACE3 conditionCardiacArrestTimer.
 * Always returns false so that units in the "CardiacArrest" state
 * never hit the built‑in death timer.  Combined with our custom
 * handleStateCardiacArrest this prevents the engine from killing
 * units when cardiac arrest would normally expire.
 */
params ["_unit"];

false
