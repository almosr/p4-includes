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
.const SYSTEM_KERNAL_INFOUT        = $FF4F
.const SYSTEM_KERNAL_CINT          = $FF81
.const SYSTEM_KERNAL_IOINIT        = $FF84
.const SYSTEM_KERNAL_RAMTAS        = $FF87
.const SYSTEM_KERNAL_RESTOR        = $FF8A
.const SYSTEM_KERNAL_VECTOR        = $FF8D
.const SYSTEM_KERNAL_SETMSG        = $FF90
.const SYSTEM_KERNAL_SECND         = $FF93
.const SYSTEM_KERNAL_TKSA          = $FF96
.const SYSTEM_KERNAL_MEMTOP        = $FF99
.const SYSTEM_KERNAL_MEMBOT        = $FF9C
.const SYSTEM_KERNAL_SCNKEY        = $FF9F
.const SYSTEM_KERNAL_SETTMO        = $FFA2
.const SYSTEM_KERNAL_ACPTR         = $FFA5
.const SYSTEM_KERNAL_CIOUT         = $FFA8
.const SYSTEM_KERNAL_UNTLK         = $FFAB
.const SYSTEM_KERNAL_UNLSN         = $FFAE
.const SYSTEM_KERNAL_LISTN         = $FFB1
.const SYSTEM_KERNAL_TALK          = $FFB4
.const SYSTEM_KERNAL_READST        = $FFB7
.const SYSTEM_KERNAL_SETLFS        = $FFBA
.const SYSTEM_KERNAL_SETNAM        = $FFBD
.const SYSTEM_KERNAL_OPEN          = $FFC0
.const SYSTEM_KERNAL_CLOSE         = $FFC3
.const SYSTEM_KERNAL_CHKIN         = $FFC6
.const SYSTEM_KERNAL_CHOUT         = $FFC9
.const SYSTEM_KERNAL_CLRCH         = $FFCC
.const SYSTEM_KERNAL_CHRIN         = $FFCF
.const SYSTEM_KERNAL_CHROUT        = $FFD2
.const SYSTEM_KERNAL_LOADSP        = $FFD5
.const SYSTEM_KERNAL_SAVESP        = $FFD8
.const SYSTEM_KERNAL_SETTIM        = $FFDB
.const SYSTEM_KERNAL_RDTIM         = $FFDE
.const SYSTEM_KERNAL_STOP          = $FFE1
.const SYSTEM_KERNAL_GETIN         = $FFE4
.const SYSTEM_KERNAL_CLALL         = $FFE7
.const SYSTEM_KERNAL_UDTIM         = $FFEA
.const SYSTEM_KERNAL_SCRORG        = $FFED
.const SYSTEM_KERNAL_PLOT          = $FFF0
.const SYSTEM_KERNAL_IOBASE        = $FFF3
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