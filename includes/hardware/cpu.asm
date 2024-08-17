/**
 * @file cpu.asm
 *
 * CPU registers and related functions/macros.
 **/

#importonce

.const HARDWARE_CPU_RESET_DISPATCH      = $FFFC
.const HARDWARE_CPU_INTERRUPT_DISPATCH  = $FFFE
