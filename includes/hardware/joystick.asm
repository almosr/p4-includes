/**
 * @file joystick.asm
 *
 * Joystick-related constants.
 * @see std_lib/joystick/StdLib_Joystick_Read macro regarding the use of these constants.
 **/

#importonce

/**
 * Select joystick port #1 for reading
 **/
.const HARDWARE_JOYSTICK_SELECT_1 = %11111011

/**
 * Select joystick port #2 for reading
 **/
.const HARDWARE_JOYSTICK_SELECT_2 = %11111101

/**
 * Joystick result for up direction
 **/
.const HARDWARE_JOYSTICK_DIRECTION_UP       = %00000001

/**
 * Joystick result for down direction
 **/
.const HARDWARE_JOYSTICK_DIRECTION_DOWN     = %00000010

/**
 * Joystick result for left direction
 **/
.const HARDWARE_JOYSTICK_DIRECTION_LEFT     = %00000100

/**
 * Joystick result for right direction
 **/
.const HARDWARE_JOYSTICK_DIRECTION_RIGHT    = %00001000

/**
 * Joystick result for port #1 fire
 **/
.const HARDWARE_JOYSTICK_FIRE_JOY_1         = %01000000

/**
 * Joystick result for port #2 fire
 **/
.const HARDWARE_JOYSTICK_FIRE_JOY_2         = %10000000
