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

    .var keyRowGroups = List()
    .for(var i = 0; i < keyTestList.size(); i += 2) {
        .var keyTest = keyTestList.get(i)
        .var keyValue = keyTestList.get(i + 1)
        .if (keyValue == 0) .error "Value associated with the key must not be zero."

        .var leave = false
        .var group = 0
        //This iteration walks through the already collected key row groups,
        //trying to find a group for the key.
        //If it runs out of groups then creates a new group.
        .while(!leave) {
            //Have we reached the end of the group list yet?
            .if (keyRowGroups.size() == group) {
                //End reached, new group is required,
                //add one with the row, key and associated value pre-populated
                .var newGroup = List().add(keyTest.row, keyTest.key, keyValue)
                .eval keyRowGroups.add(newGroup)

                //Found the goup for the key, leaving
                .eval leave = true
            } else {
                .var currentGroup = keyRowGroups.get(group)
                .var foundKey = false
                //Search for the same key ID in this group
                .for(var k = 1; k < currentGroup.size(); k += 2) {
                    .if (currentGroup.get(k) == keyTest.key) {
                        .eval foundKey = true
                    }
                }
                //When the same key ID has not been found in the group then this key test can be added
                .if (!foundKey) {
                    //Add the row to the group rows
                    .eval currentGroup.set(0, currentGroup.get(0) & keyTest.row)
                    //Add the key and value to the group
                    .eval currentGroup.add(keyTest.key, keyValue)

                    //Found the goup for the key, leaving
                    .eval leave = true
                } else {
                    //Move to the next group
                    .eval group++
                }
            }
        }
    }

    //Create test code for all groups
    .for(var i = 0; i < keyRowGroups.size(); i++) {
        .var group = keyRowGroups.get(i)

            lda #group.get(0)       //First list item is the row
            sta HARDWARE_TED_KEYBOARD_ROW_SELECT
            lda #$FF                //Latch must be set to off, so joysticks won't be interfere with keyboard
            sta HARDWARE_TED_KEYBOARD_LATCH
            lda HARDWARE_TED_KEYBOARD_LATCH
            tax                     //Read value is stored in X register

        //Test for each key in this group
        .var first = true
        .for(var k = 1; k < group.size(); k += 2) {
            .if (first)  {
                //For first key the read value is already present in A register
                .eval first = false
            } else {
                //For subsequent keys read value is restored from X register
                txa
            }
                and #group.get(k)   //Check the bit specific to the key
                bne !+                      //Key is not pressed, skip to next
                lda #group.get(k + 1)   //Key is pressed, load value (never zero)
                bne !exit+                  //Leave the processing
            !:
        }
    }

        lda #0          //No key found
    !exit:
}