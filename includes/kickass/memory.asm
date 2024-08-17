/**
 * @file memory.asm
 *
 * Kickass memory-related helper functions/macros.
 **/

#importonce

/**
 * Zero-page register allocation helper for byte size.
 *
 * Use it together with `virtual` address space.
 **/
.macro Kickass_Memory_ZeroPage_Byte() {
    .byte   0
}

/**
 * Zero-page register allocation helper for integer size.
 *
 * Use it together with `virtual` address space.
 * Part of integer registers allocated with this helper can be referred to using `.lo` and `.hi` modifiers.
 **/
.macro Kickass_Memory_ZeroPage_Integer() {
    .label lo = *
    .label hi = * + 1
    .word 0
}