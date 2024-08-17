//--------------------- Internals for Hardware/Screen

#importonce

.macro Internal_Hardware_Screen_InitBitmap(bitmapAddress, colorMatrixAddress, borderColor, multicolor) {
    lda #borderColor
    sta HARDWARE_TED_COLOR_BORDER

    Hardware_Ted_SetBitmapAddress(bitmapAddress)

    lda #>colorMatrixAddress
    sta HARDWARE_TED_CHARACTER_SCREEN_ADDRESS

    lda HARDWARE_TED_SCREEN_CONTROL_2
    .if (multicolor) {
        ora #%00010000  //Multicolor mode on
    } else {
        and #%11101111  //Multicolor mode off
    }
    sta HARDWARE_TED_SCREEN_CONTROL_2

    lda HARDWARE_TED_SCREEN_CONTROL_1
    and #%00001111
    ora #%00110000  //Hi-res mode on, screen on, EHC mode off
    sta HARDWARE_TED_SCREEN_CONTROL_1
}
