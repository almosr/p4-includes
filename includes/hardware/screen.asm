/**
 * @file screen.asm
 *
 * Standard hardware defined screen properties and related functions/macros.
 **/

#importonce

#import "internal/hardware/screen.asm"
#import "hardware/ted.asm"

.const HARDWARE_SCREEN_WIDTH = 40
.const HARDWARE_SCREEN_HEIGHT = 25

/**
 * Turn on hi-res bitmap screen mode.
 *
 * Changes:
 *   A register
 *
 * @param bitmapAddress bitmap physical address in memory.
 * @param colorMatrixAddress color matrix physical address in memory.
 * @param borderColor border color to be set.
 **/
.macro Hardware_Screen_InitHiresBitmap(bitmapAddress, colorMatrixAddress, borderColor) {
    Internal_Hardware_Screen_InitBitmap(bitmapAddress, colorMatrixAddress, borderColor, false)
}

/**
 * Turn on multicolor bitmap screen mode.
 *
 * Changes:
 *   A register
 *
 * @param bitmapAddress bitmap physical address in memory.
 * @param colorMatrixAddress color matrix physical address in memory.
 * @param backgroundColor background ($FF15) color to be set.
 * @param borderColor border ($FF19) color to be set.
 * @param specialColor special ($FF16) color to be set.
 **/
.macro Hardware_Screen_InitMulticolorBitmap(bitmapAddress, colorMatrixAddress, backgroundColor, borderColor, specialColor) {
    lda #backgroundColor
    sta HARDWARE_TED_COLOR_BACKGROUND
    lda #specialColor
    sta HARDWARE_TED_COLOR_SPECIAL_1

    Internal_Hardware_Screen_InitBitmap(bitmapAddress, colorMatrixAddress, borderColor, true)
}

/**
 * Calculates byte offset in screen for a specific coordinate.
 *
 * @param x horizontal coorinate (0 - 39).
 * @param y vertical coorinate (0 - 24).
 * @return offset from screen starting address.
 **/
.function Hardware_Screen_CalculateOffset(x, y) {
    .errorif x < 0 || x > 39, "X coordinate is out of range"
    .errorif y < 0 || y > 24, "y coordinate is out of range"

    .return x + y * HARDWARE_SCREEN_WIDTH
}