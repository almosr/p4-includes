/**
 * @file color.asm
 *
 * Standard hardware defined colors and related functions/macros.
 **/

#importonce

.const HARDWARE_COLOR_BLACK         = $00
.const HARDWARE_COLOR_WHITE         = $01
.const HARDWARE_COLOR_RED          	= $02
.const HARDWARE_COLOR_CYAN          = $03
.const HARDWARE_COLOR_PURPLE        = $04
.const HARDWARE_COLOR_GREEN         = $05
.const HARDWARE_COLOR_BLUE          = $06
.const HARDWARE_COLOR_YELLOW        = $07
.const HARDWARE_COLOR_ORANGE        = $08
.const HARDWARE_COLOR_BROWN         = $09
.const HARDWARE_COLOR_YELLOW_GREEN  = $0A
.const HARDWARE_COLOR_PINK          = $0B
.const HARDWARE_COLOR_BLUE_GREEN    = $0C
.const HARDWARE_COLOR_LIGHT_BLUE    = $0D
.const HARDWARE_COLOR_DARK_BLUE     = $0E
.const HARDWARE_COLOR_LIGHT_GREEN   = $0F

/**
 * Calculate an actual color from color code and luminance.
 *
 * @param code color code value (0 - 15), see HARDWARE_COLOR_* definitions.
 * @param luminance luminance value (0 - 7).
 *
 * @return color code calculated from components.
 **/
.function Hardware_Color_Code(code, luminance) {
    .errorif code < 0 || code > 15, "Color code is out of range"
    .errorif luminance < 0 || luminance > 7, "Luminance is out of range"

    .return (luminance << 4) + code
}

/**
 * Return the luminace part of the specified color.
 *
 * @param color color code (byte).
 *
 * @return luminance part of color code.
 **/
.function Hardware_Color_GetLuminance(color) {
    .return (color >> 4) & 7
}

/**
 * Return the color part of the specified color.
 *
 * @param color color code.
 *
 * @return color part of color code.
 **/
.function Hardware_Color_GetColor(color) {
    .return color & $0F
}
