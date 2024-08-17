/**
 * @file key_scan.asm
 *
 * System key scan codes.
 *
 * Key scan codes as read by OS functions.
 * These are the codes returned at $C6 address by IRQ keyboard reading routine.
 **/

#importonce

.const SYSTEM_KEY_SCAN_CURSOR_LEFT  = $30
.const SYSTEM_KEY_SCAN_CURSOR_RIGHT = $33
.const SYSTEM_KEY_SCAN_CURSOR_UP    = $2B
.const SYSTEM_KEY_SCAN_CURSOR_DOWN  = $28

.const SYSTEM_KEY_SCAN_SPACE        = $3C
