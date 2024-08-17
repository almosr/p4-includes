/**
 * @file ted.asm
 *
 * TED registers and related functions/macros.
 **/

#importonce

// Timers
.const HARDWARE_TED_TIMER_1_LOW                     = $FF00
.const HARDWARE_TED_TIMER_1_HIGH                    = $FF01
.const HARDWARE_TED_TIMER_2_LOW                     = $FF02
.const HARDWARE_TED_TIMER_2_HIGH                    = $FF03
.const HARDWARE_TED_TIMER_3_LOW                     = $FF04
.const HARDWARE_TED_TIMER_3_HIGH                    = $FF05

// Screen control
.const HARDWARE_TED_SCREEN_CONTROL_1                = $FF06
.const HARDWARE_TED_SCREEN_CONTROL_2                = $FF07
.const HARDWARE_TED_CURSOR_POSITION_HIGH            = $FF0C
.const HARDWARE_TED_CURSOR_POSITION_LOW             = $FF0D
.const HARDWARE_TED_BITMAP_SCREEN_ADDRESS           = $FF12
.const HARDWARE_TED_CHARSET_ADDRESS                 = $FF13
.const HARDWARE_TED_CHARACTER_SCREEN_ADDRESS        = $FF14
.const HARDWARE_TED_COLOR_BACKGROUND                = $FF15
.const HARDWARE_TED_COLOR_SPECIAL_1                 = $FF16
.const HARDWARE_TED_COLOR_SPECIAL_2                 = $FF17
.const HARDWARE_TED_COLOR_SPECIAL_3                 = $FF18
.const HARDWARE_TED_COLOR_BORDER                    = $FF19

// Screen render
.const HARDWARE_TED_RENDER_CHARACTER_POSITION_HIGH  = $FF1A
.const HARDWARE_TED_RENDER_CHARACTER_POSITION_LOW   = $FF1B
.const HARDWARE_TED_RENDER_RASTER_LINE_HIGH         = $FF1C
.const HARDWARE_TED_RENDER_RASTER_LINE_LOW          = $FF1D
.const HARDWARE_TED_RENDER_RASTER_COLUMN            = $FF1E
.const HARDWARE_TED_RENDER_CHARACTER_SCAN_LINE      = $FF1F

// Keyboard
.const HARDWARE_TED_KEYBOARD_LATCH                  = $FF08
.const HARDWARE_TED_KEYBOARD_ROW_SELECT             = $FD30

// Interrupt
.const HARDWARE_TED_INTERRUPT_REQUEST               = $FF09
.const HARDWARE_TED_INTERRUPT_MASK                  = $FF0A
.const HARDWARE_TED_INTERRUPT_RASTER_LINE_LOW       = $FF0B
.const HARDWARE_TED_INTERRUPT_RASTER_LINE_HIGH      = $FF0A

// Sound
.const HARDWARE_TED_SOUND_CONTROL                   = $FF11
.const HARDWARE_TED_SOUND_VOICE_1_LOW               = $FF0E
.const HARDWARE_TED_SOUND_VOICE_1_HIGH              = $FF12
.const HARDWARE_TED_SOUND_VOICE_2_LOW               = $FF0F
.const HARDWARE_TED_SOUND_VOICE_2_HIGH              = $FF10

// ROM/RAM read control
.const HARDWARE_TED_HIGH_RAM_ENABLE                 = $FF3F
.const HARDWARE_TED_HIGH_ROM_ENABLE                 = $FF3F

//When P4_INCLUDES_TED_STRUCTURE is defined then create a TED namespace with shorter names for convenience
#if P4_INCLUDES_TED_STRUCTURE
    /**
     * Namespace for accessing TED registers conveniently.
     **/
    .namespace Ted {
        // Timers
        .label Timer1Lo     = HARDWARE_TED_TIMER_1_LOW
        .label Timer1Hi     = HARDWARE_TED_TIMER_1_HIGH
        .label Timer2Lo     = HARDWARE_TED_TIMER_2_LOW
        .label Timer2Hi     = HARDWARE_TED_TIMER_2_HIGH
        .label Timer3Lo     = HARDWARE_TED_TIMER_3_LOW
        .label Timer3Hi     = HARDWARE_TED_TIMER_3_HIGH

        // Screen control
        .label ScrCtrl1     = HARDWARE_TED_SCREEN_CONTROL_1
        .label ScrCtrl2     = HARDWARE_TED_SCREEN_CONTROL_2
        .label CursPosHi    = HARDWARE_TED_CURSOR_POSITION_HIGH
        .label CursPosLo    = HARDWARE_TED_CURSOR_POSITION_LOW
        .label BmpAddr      = HARDWARE_TED_BITMAP_SCREEN_ADDRESS
        .label CharsAddr    = HARDWARE_TED_CHARSET_ADDRESS
        .label CharScrAddr  = HARDWARE_TED_CHARACTER_SCREEN_ADDRESS
        .label ColBg        = HARDWARE_TED_COLOR_BACKGROUND
        .label ColSpec1     = HARDWARE_TED_COLOR_SPECIAL_1
        .label ColSpec2     = HARDWARE_TED_COLOR_SPECIAL_2
        .label ColSpec3     = HARDWARE_TED_COLOR_SPECIAL_3
        .label ColBorder    = HARDWARE_TED_COLOR_BORDER

        // Screen render
        .label CharPosHi    = HARDWARE_TED_RENDER_CHARACTER_POSITION_HIGH
        .label CharPosLo    = HARDWARE_TED_RENDER_CHARACTER_POSITION_LOW
        .label RastLineHi   = HARDWARE_TED_RENDER_RASTER_LINE_HIGH
        .label RastLineLo   = HARDWARE_TED_RENDER_RASTER_LINE_LOW
        .label RastCol      = HARDWARE_TED_RENDER_RASTER_COLUMN
        .label CharScanLine = HARDWARE_TED_RENDER_CHARACTER_SCAN_LINE

        // Keyboard
        .label KeybLatch        = HARDWARE_TED_KEYBOARD_LATCH
        .label KeybRow          = HARDWARE_TED_KEYBOARD_ROW_SELECT

        // Interrupt
        .label IntReq           = HARDWARE_TED_INTERRUPT_REQUEST
        .label IntMask          = HARDWARE_TED_INTERRUPT_MASK
        .label IntRastLineLo    = HARDWARE_TED_INTERRUPT_RASTER_LINE_LOW
        .label IntRastLineHi    = HARDWARE_TED_INTERRUPT_RASTER_LINE_HIGH

        // Sound
        .label SndCtrl          = HARDWARE_TED_SOUND_CONTROL
        .label SndVox1Lo        = HARDWARE_TED_SOUND_VOICE_1_LOW
        .label SndVox1Hi        = HARDWARE_TED_SOUND_VOICE_1_HIGH
        .label SndVox2Lo        = HARDWARE_TED_SOUND_VOICE_2_LOW
        .label SndVox2Hi        = HARDWARE_TED_SOUND_VOICE_2_HIGH

        // ROM/RAM read control
        .label RamEnable        = HARDWARE_TED_HIGH_RAM_ENABLE
        .label RomEnable        = HARDWARE_TED_HIGH_ROM_ENABLE
    }
#endif

/**
 * Calculate TED bitmap address from physical address that can be set
 * to bitmap address ($FF12) register.
 *
 * @param physicalAddress physical address of bitmap graphics, must be divisible by $2000.
 *
 * @return value that can be set to bitmap address register.
 **/
.function Hardware_Ted_CalculateBitmapAddress(physicalAddress) {
    .if (mod(physicalAddress, $2000) != 0) .error "Physical address must be divisible by $2000, actual: " + toHexString(physicalAddress)

    .return physicalAddress >> 10
}

/**
 * Set bitmap address in bitmap mode on TED register.
 *
 * Changes:
 *   A register
 *
 * @param bitmapAddress physical addess of bitmap to be set on TED register.
 **/
.macro Hardware_Ted_SetBitmapAddress(bitmapAddress) {
    lda HARDWARE_TED_BITMAP_SCREEN_ADDRESS
    //Clear previously set bitmap address and set RAM bitmap access, keep sound-related bits
    and #%00000011
    ora #Hardware_Ted_CalculateBitmapAddress(bitmapAddress)
    sta HARDWARE_TED_BITMAP_SCREEN_ADDRESS
}

/**
 * Wait for next raster line in screen rendering.
 *
 * Changes:
 *   A register
 **/
.macro Hardware_Ted_WaitForNextRasterLine() {
    lda #$80
!:  cmp HARDWARE_TED_RENDER_RASTER_COLUMN
    bcs !-
}