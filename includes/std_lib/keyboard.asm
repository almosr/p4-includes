/**
 * @file keyboard.asm
 *
 * Standard library keyboard operations.
 * @see hardware/keyboard regarding constants for these macros.
 **/

#importonce

#import "hardware/keyboard.asm"
#import "hardware/ted.asm"

/**
 * Read state of the keyboard.
 *
 * Changes:
 *   A register
 *
 * @return flag Z - cleared when any key is pressed, set when no key is pressed.
 **/
.macro StdLib_Keyboard_IsKeyPressed() {
    lda #0      //Select all rows
    sta HARDWARE_TED_KEYBOARD_ROW_SELECT
    sta HARDWARE_TED_KEYBOARD_LATCH
    lda HARDWARE_TED_KEYBOARD_LATCH
    eor #$FF    //Check for any zero bits
}

/**
 * Read state of a specific key.
 *
 * Changes:
 *   A register
 *
 * @param keyTest HARDWARE_KEYBOARD_TEST_KEY_* structure from
 *                hardware/keyboard for the key to be tested.
 *
 * @return flag Z - cleared when key is pressed, set when not pressed.
 **/
.macro StdLib_Keyboard_ReadKey(keyTest) {
    lda #keyTest.row
    sta HARDWARE_TED_KEYBOARD_ROW_SELECT
    sta HARDWARE_TED_KEYBOARD_LATCH
    lda HARDWARE_TED_KEYBOARD_LATCH
    and #keyTest.key
}