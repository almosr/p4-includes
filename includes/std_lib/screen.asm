/**
 * @file screen.asm
 *
 * Standard library screen operations.
 **/

#importonce

#import "hardware/screen.asm"

/**
 * Convert screen coordinates to offset from screen start address.
 *
 * @param x - x coordinate on screen.
 * @param y - y coordinate on screen.
 *
 * @return offset on screen for the specified coordinates.
 **/
.function StdLib_Screen_CoordToOffset(x, y) {
    .return y * HARDWARE_SCREEN_WIDTH + x
}

/**
 * Wait for vertical blank in screen rendering.
 *
 * Note: this macro implements busy-waiting (nothing else can be executed apart from interrupts).
 *
 * Changes:
 *   A register
 **/
.macro StdLib_Screen_WaitForVBlank() {
        //Wait for raster line $FE that is outside of the normally rendered screen
        lda #$fe
    !:  cmp HARDWARE_TED_RENDER_RASTER_LINE_LOW
        bne !-

        //Wait until rendering steps to the next raster line, so this macro could
        //be applied in a loop.
        lda HARDWARE_TED_RENDER_RASTER_LINE_LOW
    !:  cmp HARDWARE_TED_RENDER_RASTER_LINE_LOW
        beq !-
}