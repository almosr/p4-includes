/**
 * @file interrupt.asm
 *
 * Interrupt-related functions.
 **/

#importonce

#import "hardware/cpu.asm"
#import "std_lib/memory.asm"

/**
 * Set up direct (non-OS compatible) interrupt.
 *
 * Changes:
 *   A register
 *
 * @param address new interrupt start address.
 * @param enable enable interrupt after setting it up when `true`, skip enabling otherwise.
 **/
.macro StdLib_Interrupt_Setup_Direct(address, enable) {
    sei

    //Disable ROM at high address
    StdLib_Memory_EnableHighRAM()

    StdLib_Memory_SetMemory(address, HARDWARE_CPU_INTERRUPT_DISPATCH)

    .if (enable) {
        cli
    }
}
