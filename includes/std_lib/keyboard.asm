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
    lda #$FF                                //Latch must be set to off, so joysticks won't be interfere with keyboard
    sta HARDWARE_TED_KEYBOARD_LATCH
    lda HARDWARE_TED_KEYBOARD_LATCH
    and #keyTest.key
}

/**
 * Read state of the listed keys and return associated values when pressed.
 * When multiple keys must be monitored at the same time then this macro produces
 * a shorter code than repeated `StdLib_Keyboard_ReadKey` calls.
 *
 * Changes:
 *   A and X registers
 *
 * @param keyTestList a KickAssembler List that consist of multiple pairs of
 *        HARDWARE_KEYBOARD_TEST_KEY_* element followed by a byte value that is
 *        returned when the key is detected. The keys are checked in the order
 *        of the list, only the associated value for the first pressed key is returned.
 *        Multiple keys may use the same associated value.
 *        Associated values must not contain 0.
 *
 * @return A register - associated byte value for the pressed key or 0 when none of the
           listed keys are pressed. Z flag is set when no key press was detected.
 **/
.macro StdLib_Keyboard_ReadKeys(keyTestList) {
    .if (mod(keyTestList.size(), 2) != 0) .error "Parameter keyTestList does not contain key-value pairs."

    .var keyTestMapping = List()
    .for(var i = 0; i < keyTestList.size(); i += 2) {
        .var keyTest = keyTestList.get(i)
        .var keyValue = keyTestList.get(i + 1)
        .if (keyValue == 0) .error "Value associated with the key must not be zero."

        .eval keyTestMapping.add(keyTest.row, keyTest.key, keyValue)
    }

    ldx #0
!cyc:
    lda !key_test_rows+,x     //Get the row selection
    sta HARDWARE_TED_KEYBOARD_ROW_SELECT
    lda #$FF                //Latch must be set to off, so joysticks won't be interfere with keyboard
    sta HARDWARE_TED_KEYBOARD_LATCH
    lda HARDWARE_TED_KEYBOARD_LATCH
    and !key_test_keys+,x     //Mask the key column
    beq !key_found+
    inx
    cpx #keyTestMapping.size() / 3
    bne !cyc-

    lda #0          //No pressed key has been found
    beq !exit+

    //Inline the mapping data which will be skipped by execution
!key_test_rows:
    .for(var i = 0; i < keyTestMapping.size(); i += 3) {
        .byte keyTestMapping.get(i)
    }

!key_test_keys:
    .for(var i = 0; i < keyTestMapping.size(); i += 3) {
        .byte keyTestMapping.get(i + 1)
    }

!key_test_values:
    .for(var i = 0; i < keyTestMapping.size(); i += 3) {
        .byte keyTestMapping.get(i + 2)
    }

!key_found:
    lda !key_test_values-,x     //Read associated value to the key
!exit:
}