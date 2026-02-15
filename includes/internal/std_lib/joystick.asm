//--------------------- Internals for Std Lib/Joystick
#importonce

#import "kickass/list.asm"

.macro Internal_StdLib_Joystick_ValidatePort(port) {
    .if ((port != 1) && (port != 2) && (port != 3)) .error "Unrecnognised joystick port, must be 1, 2 or 3 for both ports, current: " + port
}

.macro Internal_StdLib_Joystick_Test(port, flag) {
    .var validFlags = List().add(HARDWARE_JOYSTICK_DIRECTION_LEFT, HARDWARE_JOYSTICK_DIRECTION_RIGHT, HARDWARE_JOYSTICK_DIRECTION_UP, HARDWARE_JOYSTICK_DIRECTION_DOWN, HARDWARE_JOYSTICK_FIRE_JOY_1, HARDWARE_JOYSTICK_FIRE_JOY_2,  HARDWARE_JOYSTICK_FIRE_JOY_1 | HARDWARE_JOYSTICK_FIRE_JOY_2)
    .if (Kickass_List_Find(validFlags, flag) == -1) .error "Unrecognised joystick result flag: " + flag

    StdLib_Joystick_Read(port)
    and #flag
}