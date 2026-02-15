/**
 * @file joystick.asm
 *
 * Standard library joystick operations.
 * @see hardware/joystick regarding constants for these macros.
 **/

#importonce

#import "hardware/joystick.asm"
#import "hardware/ted.asm"
#import "internal/std_lib/joystick.asm"

/**
  * Selector constant for joystick port 1.
  * Use it with any functions in this file where joystick port parameter should be specified.
  **/
.const STD_LIB_JOYSTICK_PORT_1 = 1

/**
  * Selector constant for joystick port 2.
  * Use it with any functions in this file where joystick port parameter should be specified.
  **/
.const STD_LIB_JOYSTICK_PORT_2 = 2

/**
  * Selector constant for joystick both ports.
  * Use it with any functions in this file where joystick port parameter should be specified.
  **/
.const STD_LIB_JOYSTICK_PORT_BOTH = 3

/**
 * Read state of a specific joystick port.
 *
 * @param port joystick port to read, see constants: STD_LIB_JOYSTICK_PORT_*.
 *
 * @return read value, can be masked with either HARDWARE_JOYSTICK_DIRECTION_* or HARDWARE_JOYSTICK_FIRE_JOY_*
 *         constants or a combination of those from hardware/joystick to get the currently pressed switches.
 *         When the masked switch is pressed then the result will be non-zero.
 **/
.macro StdLib_Joystick_Read(port) {
    Internal_StdLib_Joystick_ValidatePort(port)

    lda #HARDWARE_KEYBOARD_UNSELECT_ROWS        //Keyboard results must be disabled
    sta HARDWARE_TED_KEYBOARD_ROW_SELECT
    .var portFlags = %11111111
    .if ((port & STD_LIB_JOYSTICK_PORT_1) == STD_LIB_JOYSTICK_PORT_1) {
        .eval portFlags = portFlags & HARDWARE_JOYSTICK_SELECT_1
    }
    .if ((port & STD_LIB_JOYSTICK_PORT_2) == STD_LIB_JOYSTICK_PORT_2) {
        .eval portFlags = portFlags & HARDWARE_JOYSTICK_SELECT_2
    }
    lda #portFlags
    sta HARDWARE_TED_KEYBOARD_LATCH
    lda HARDWARE_TED_KEYBOARD_LATCH
    eor #$ff
}

/**
 * Test whether left direction is pressed for joystick that is connected to a specific port.
 *
 * Changes:
 *   A register
 *
 * @param port joystick port to read, see constants: STD_LIB_JOYSTICK_PORT_*.
 * @return flag Z - set when direction is pressed, cleared when not pressed.
 **/
.macro StdLib_Joystick_Test_Left(port) {
    Internal_StdLib_Joystick_ValidatePort(port)
    Internal_StdLib_Joystick_Test(port, HARDWARE_JOYSTICK_DIRECTION_LEFT)
}

/**
 * Test whether right direction is pressed for joystick that is connected to a specific port.
 *
 * Changes:
 *   A register
 *
 * @param port joystick port to read, see constants: STD_LIB_JOYSTICK_PORT_*.
 * @return flag Z - set when direction is pressed, cleared when not pressed.
 **/
.macro StdLib_Joystick_Test_Right(port) {
    Internal_StdLib_Joystick_ValidatePort(port)
    Internal_StdLib_Joystick_Test(port, HARDWARE_JOYSTICK_DIRECTION_RIGHT)
}

/**
 * Test whether up direction is pressed for joystick that is connected to a specific port.
 *
 * Changes:
 *   A register
 *
 * @param port joystick port to read, see constants: STD_LIB_JOYSTICK_PORT_*.
 * @return flag Z - set when direction is pressed, cleared when not pressed.
 **/
.macro StdLib_Joystick_Test_Up(port) {
    Internal_StdLib_Joystick_ValidatePort(port)
    Internal_StdLib_Joystick_Test(port, HARDWARE_JOYSTICK_DIRECTION_UP)
}

/**
 * Test whether down direction is pressed for joystick that is connected to a specific port.
 *
 * Changes:
 *   A register
 *
 * @param port joystick port to read, see constants: STD_LIB_JOYSTICK_PORT_*.
 * @return flag Z - set when direction is pressed, cleared when not pressed.
 **/
.macro StdLib_Joystick_Test_Down(port) {
    Internal_StdLib_Joystick_ValidatePort(port)
    Internal_StdLib_Joystick_Test(port, HARDWARE_JOYSTICK_DIRECTION_DOWN)
}

/**
 * Test whether fire is pressed for joystick that is connected to a specific port.
 *
 * Changes:
 *   A register
 *
 * @param port joystick port to read, see constants: STD_LIB_JOYSTICK_PORT_*.
 * @return flag Z - set when fire is pressed, cleared when not pressed.
 **/
.macro StdLib_Joystick_Test_Fire(port) {
    Internal_StdLib_Joystick_ValidatePort(port)
    .var fireFlags = 0
    .if ((port & STD_LIB_JOYSTICK_PORT_1) == STD_LIB_JOYSTICK_PORT_1) {
        .eval fireFlags = fireFlags | HARDWARE_JOYSTICK_FIRE_JOY_1
    }
    .if ((port & STD_LIB_JOYSTICK_PORT_2) == STD_LIB_JOYSTICK_PORT_2) {
        .eval fireFlags = fireFlags | HARDWARE_JOYSTICK_FIRE_JOY_2
    }
    Internal_StdLib_Joystick_Test(port, fireFlags)
}