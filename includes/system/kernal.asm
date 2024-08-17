/**
 * @file kernal.asm
 *
 * Various KERNAL ROM functions and calling macros.
 **/

#importonce

#import "std_lib/memory.asm"

.const SYSTEM_KERNAL_FILL_PAGES    = $C5A7
.const SYSTEM_KERNAL_VIDEO_RESET   = $D84E
.const SYSTEM_KERNAL_READ_KEYBOARD = $DB11
.const SYSTEM_KERNAL_COMPLETE_IRQ  = $FCBE
.const SYSTEM_KERNAL_RESET         = $FFF6

/**
 * Reset machine using ROM reset routine.
 **/
.macro System_Kernal_MachineReset() {
    //Disable interrupts, just in case
    sei

    //Set ROM to high memory
    StdLib_Memory_EnableHighROM()

    //CPU reset routine in ROM
    jmp SYSTEM_KERNAL_RESET
}

/**
 * Fill 256 byte long pages using kernal routine.
 *
 * Changes:
 *   A, X and Y registers
 *
 * @param numberOfPages number of pages to be filled.
 * @param startAddress start address of the first page (must be round to page boundary).
 * @param value value to fill pages with.
 **/
.macro System_Kernal_FillPages(numberOfPages, startAddress, value) {
    .errorif mod(startAddress, 256) != 0, "Start address must be round to page boundary (divisible by 256)"

    ldx #numberOfPages
    ldy #>startAddress
    lda #value
    jsr SYSTEM_KERNAL_FILL_PAGES
}