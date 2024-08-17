/**
 * Example program for gfx/interpolation.
 *
 * This small demonstration moves a text-based logo on the screen
 * using pre-defined data tables that were generated by interpolation functions.
 * By pressing space key it moves to the next table.
 *
 * Demonstrates how to:
 *   - Generate data tables at compile time using interpolation functions.
 *   - Define color codes using color names and luminance value.
 *   - Use kernal routine for filling up memory with specific value easily.
 *   - Set up and handle interrupts for specific raster lines when kernal routines are disabled.
 *   - Wait for a specific key press when kernal routines are disabled.
 **/

//Enable convenient structures, must be done before imports
#define P4_INCLUDES_TED_STRUCTURE
#define P4_INCLUDES_CHARACTER_STRUCTURE

#import "gfx/interpolation.asm"
#import "hardware/characters.asm"
#import "hardware/color.asm"
#import "hardware/screen.asm"
#import "hardware/ted.asm"
#import "kickass/memory.asm"
#import "std_lib/interrupt.asm"
#import "std_lib/keyboard.asm"
#import "std_lib/subroutine.asm"
#import "system/address.asm"
#import "system/kernal.asm"

//--------- Definitions

.const COLOR_BLACK        = Hardware_Color_Code(HARDWARE_COLOR_BLACK,      0)
.const COLOR_SKY_BLUE     = Hardware_Color_Code(HARDWARE_COLOR_LIGHT_BLUE, 5)
.const COLOR_GRASS_GREEN  = Hardware_Color_Code(HARDWARE_COLOR_GREEN,      3)
.const COLOR_SUN_YELLOW   = Hardware_Color_Code(HARDWARE_COLOR_YELLOW,     7)

//Logo position on screen will be starting from row #6
.const LOGO_SCREEN_ADDRESS = SYSTEM_ADDRESS_SCREEN_MEMORY_CHARACTERS + Hardware_Screen_CalculateOffset(0, 6)

//Offset for last row on the screen
.const LAST_ROW_OFFSET = Hardware_Screen_CalculateOffset(0, 24)

//Actual address of last row on screen
.const LAST_ROW_ADDRESS = SYSTEM_ADDRESS_SCREEN_MEMORY_CHARACTERS + LAST_ROW_OFFSET

//Allocate some zero-page registers that will be used by logo animation
.namespace zp {
    *=$D0 "Zero page registers" virtual

    //Registers for logo movement rendering
    shift_table:    Kickass_Memory_ZeroPage_Integer()
    offset_table:   Kickass_Memory_ZeroPage_Integer()
    logo_position:  Kickass_Memory_ZeroPage_Integer()
    logo_counter:   Kickass_Memory_ZeroPage_Byte()

    //Registers for logo name copying to screen
    text_src:       Kickass_Memory_ZeroPage_Integer()

    //Current effect counter
    current_effect: Kickass_Memory_ZeroPage_Byte()
}

//Set text encoding to standard screen uppercase characters
.encoding "screencode_upper"

//--------- Initialization

*= SYSTEM_ADDRESS_BASIC_START "Basic Upstart"
    BasicUpstart(start)

*= $1010 "Code"
start:
    //Clean screen with logo color
    System_Kernal_FillPages(4, SYSTEM_ADDRESS_SCREEN_MEMORY_COLORS, COLOR_SKY_BLUE)

	//Clean screen with space character
    System_Kernal_FillPages(4, SYSTEM_ADDRESS_SCREEN_MEMORY_CHARACTERS, Chars.Space)

	//Clean last row on screen with specific text color
	StdLib_Memory_Fill(SYSTEM_ADDRESS_SCREEN_MEMORY_COLORS + LAST_ROW_OFFSET, COLOR_SUN_YELLOW, HARDWARE_SCREEN_WIDTH)

    //Set up interrupt, but don't enable it yet
    StdLib_Interrupt_Setup_Direct(interrupt, false)

    //Enable raster interrupt only
    lda #2
    sta Ted.IntMask

    //Set up interrupt to be triggered at the beginning of the screen
    jsr init_upper_screen_interrupt

    lda #COLOR_BLACK
    sta Ted.ColBorder   //Set border color, background color will be set by screen building

    //Hide cursor: system puts the cursor to the
    //last character of the invisible area while a program
    //is executed.
    //When we use sub-character horizontal shifting
    //without covering the first character column then
    //last character from the previous (invisible) screen
    //becomes visible.
    //To solve this we move the cursor to the second
    //last character.
    lda #$FF
    sta Ted.CursPosHi
    lda #$FE
    sta Ted.CursPosLo

    //Init logo animation with first effect
    lda #0
    sta.zp zp.current_effect
    jsr print_name

    //Enable interrupt
    cli

//--------- Main thread routine
wait_for_key:
    //Wait for space key press
!:  StdLib_Keyboard_ReadKey(HARDWARE_KEYBOARD_TEST_KEY_SPACE)
    bne !-

    //Change to next effect
    jsr change_effect

    //Wait for key release
!:  StdLib_Keyboard_IsKeyPressed()
    bne !-
    jmp wait_for_key

change_effect:
    ldx.zp zp.current_effect
    inx
!:  lda effect_name_lengths,x   //Check effect index with name lengths, 0 value means no more effects
    bne !+
    ldx #0                      //No more effect left, go back to first one

!:  stx.zp zp.current_effect
    jsr print_name
    lda #0                      //Reset logo effect counter, so always starts from beginning
    sta.zp zp.logo_counter
    rts

print_name:
    //Copy address of effect name to registers
    lda.zp zp.current_effect
    StdLib_Memory_CopyAddressFromTable(effect_names, zp.text_src)

    //Clear text area
    StdLib_Memory_Fill(LAST_ROW_ADDRESS, Chars.Space, HARDWARE_SCREEN_WIDTH)

    //Calculate name offset for centering it on the screen.
    //We are going to copy the text backwards, so we should
    //calculate the end offset on the screen.
    lda effect_name_lengths,x
    tay                             //Save length for later in Y
    lsr                             //Halve text length
    clc
    adc #HARDWARE_SCREEN_WIDTH/2 - 1  //Add to half screen width (minus one to get index instead of length)
    tax                             //Load calculated offset to X for target address indexing

    //Copy text to screen
    dey                             //Y contains the full length, index of last character is one less
!:  lda (zp.text_src),y
    sta LAST_ROW_ADDRESS,x
    dex
    dey                             //Until length runs out (underflows)
    bpl !-
    rts

//--------- Interrupt
interrupt:
    //Save all three registers, so the interrupt routine can use them freely
    StdLib_SaveReg_AXY(regload)

    //Acknowledge raster interrupt, so it will be triggered again next time
    asl Ted.IntReq

    .label interrupt_target = * + 1
    jsr $0000       //This jump will be set by screen init routines

regload:
    //Restore all three registers
    StdLib_RestoreReg_AXY()

    //Return from interrupt
    rti

init_upper_screen_interrupt:
    lda #0                   //Trigger interrupt at raster line #0
    sta Ted.IntRastLineLo

    //Jump to upper_screen routine from interrupt
    StdLib_Memory_SetMemory(upper_screen, interrupt_target)
    rts

init_lower_screen_interrupt:
    lda #194                 //Trigger interrupt at raster line #194 (last character row on screen)
    sta Ted.IntRastLineLo

    //Jump to upper_screen routine from interrupt
    StdLib_Memory_SetMemory(lower_screen, interrupt_target)
    rts


//--------- Screen building
upper_screen:
    //Wait for next line, so we set the color outside of visible area
    Hardware_Ted_WaitForNextRasterLine()

    //Set background color to black
    lda #COLOR_BLACK
    sta Ted.ColBg

    //Set horizontal shift in screen control 2 ($FF07) register,
    //this value will be overwritten by logo movement routine.
    .label horizontal_shift = * + 1
    lda #0
    ora #8                   //Keep the screen 40 characters wide
    sta Ted.ScrCtrl2

    //Set up interrupt to be triggered again at lower screen section
    jmp init_lower_screen_interrupt

lower_screen:
    //Wait for next line, so we set the color outside of visible area
    Hardware_Ted_WaitForNextRasterLine()

    //Set background color to green
    lda #COLOR_GRASS_GREEN
    sta Ted.ColBg

    //Set horizontal shift to 0 in screen control 2 ($FF07) register
    lda #8
    sta Ted.ScrCtrl2

    jsr move_logo

    //Set up interrupt to be triggered again at upper screen section
    jmp init_upper_screen_interrupt


//--------- Logo animation
 move_logo:
    //Load table addresses to zero-page registers for current effect
    lda.zp zp.current_effect
    StdLib_Memory_CopyAddressFromTable(effect_shifts, zp.shift_table)
    lda.zp zp.current_effect
    StdLib_Memory_CopyAddressFromTable(effect_offsets, zp.offset_table)

    //Get position in tables
    ldy.zp zp.logo_counter

    //Copy horizontal shift to screen rendering
    lda (zp.shift_table),y
    sta horizontal_shift

    //Calculate logo position by adding offset to base address
    lda (zp.offset_table),y
    clc
    adc #<LOGO_SCREEN_ADDRESS
    sta.zp zp.logo_position.lo
    lda #>LOGO_SCREEN_ADDRESS
    adc #0                      //For carry over from lower byte addition
    sta.zp zp.logo_position.hi

    //Move to next item from tables
    inc.zp zp.logo_counter

    //Copy logo to screen, first copy the first 256 bytes
    ldy #0
!:  lda logo,y
    sta (zp.logo_position),y
    iny
    bne !-

    //Skip a page ahead
    inc.zp zp.logo_position.hi

    //Then copy the remaining part of the logo that is less than 256 bytes
    ldy #0
!:  lda logo + 256,y
    sta (zp.logo_position),y
    iny
    cpy #logo_end - logo - 256
    bne !-
    rts

//--------- Data section
*= * "Data"

//-- Logo data
logo:
    .var logoData = LoadBinary("../data/hi_p4_ascii.prg")

    .const LOGO_HEIGHT  = 10
    .const LOGO_WIDTH   = 24
    .const LOGO_START_X = 9
    .const LOGO_START_Y = 6
    .const LOGO_SIZE = Hardware_Screen_CalculateOffset(0, LOGO_HEIGHT)
    .const LOGO_SPACE_BEFORE = Hardware_Screen_CalculateOffset(LOGO_START_X - 1, LOGO_START_Y - 1)
    .const LOGO_MOVEMENT_DISTANCE = (HARDWARE_SCREEN_WIDTH - LOGO_WIDTH) * 8

    //Copy as many lines from the file as the height of the logo,
    //but skip empty space before it starts in the file (and also the loading address).
    .fill LOGO_SIZE, logoData.get(i + LOGO_SPACE_BEFORE + 2)
logo_end:

//-- Movement tables
    //Length of each generated data table
    .const DATA_TABLE_LENGTH = 256

    //Collect various data about the effects into these lists,
    //so actual tables can be rendered out of them after all
    //effects are created.
    .var effectNames = List()
    .var effectNameLengths = List()
    .var effectShifts = List()
    .var effectOffsets = List()

    //This macro renders some data into the output and
    //adds the effect to the relevant lists.
.macro AddEffect(data, name) {
    //Add name to output
name_address:
    .text name
    .eval effectNames.add(name_address)
    .eval effectNameLengths.add(name.size())

    //Create sub-character shifts that will be used for setting
    //the horizontal shift register (values between 0 and 7).
shift_address:
    .fill DATA_TABLE_LENGTH, mod(data.get(i), 8)
    .eval effectShifts.add(shift_address)

    //Create character offsets that will be used by the copy routine
    //to move the logo while copying (values between 0 and LOGO_MOVEMENT_DISTANCE / 8).
offset_address:
    .fill DATA_TABLE_LENGTH, data.get(i) / 8
    .eval effectOffsets.add(offset_address)
}

// Quint movement data
    .var quintData = List()
    .for(var i = 0; i < DATA_TABLE_LENGTH; i++) {
        .eval quintData.add(Gfx_Interpolation_Quint(i / DATA_TABLE_LENGTH, 0, LOGO_MOVEMENT_DISTANCE, GFX_INTERPOLATION_WHEN_EASE_IN_OUT))
    }
    AddEffect(quintData, "QUINT EASE-IN/OUT")

// Bounce movement data
    .var bounceData = List()
    .for(var i = 0; i < DATA_TABLE_LENGTH; i++) {
        .eval bounceData.add(Gfx_Interpolation_Bounce(i / DATA_TABLE_LENGTH, 0, LOGO_MOVEMENT_DISTANCE, GFX_INTERPOLATION_WHEN_EASE_OUT))
    }
    AddEffect(bounceData, "BOUNCE EASE-OUT")

// Back movement data
    .var backData = List()
    .for(var i = 0; i < DATA_TABLE_LENGTH; i++) {
        //Back overshoots, so we must be careful with the boundaries of the movement,
        //otherwise it could overflow at the edge.
        .eval backData.add(Gfx_Interpolation_Back(i / DATA_TABLE_LENGTH, 0, LOGO_MOVEMENT_DISTANCE - 8, GFX_INTERPOLATION_WHEN_EASE_OUT))
    }
    AddEffect(backData, "BACK EASE-OUT")

// Circular movement data
    .var circularData = List()
    .for(var i = 0; i < DATA_TABLE_LENGTH; i++) {
        .eval circularData.add(Gfx_Interpolation_Circular(i / DATA_TABLE_LENGTH, 0, LOGO_MOVEMENT_DISTANCE, GFX_INTERPOLATION_WHEN_EASE_IN_OUT))
    }
    AddEffect(circularData, "CIRCULAR EASE-IN/OUT")

// Expo movement data
    .var expoData = List()
    .for(var i = 0; i < DATA_TABLE_LENGTH; i++) {
        .eval expoData.add(Gfx_Interpolation_Expo(i / DATA_TABLE_LENGTH, 0, LOGO_MOVEMENT_DISTANCE, GFX_INTERPOLATION_WHEN_EASE_IN))
    }
    AddEffect(expoData, "EXPO EASE-IN")

// Combined movement data
    .var combinedData = List()
    //First half of the path is an ease-out quint
    .for(var i = 0; i < DATA_TABLE_LENGTH / 2; i++) {
        .eval combinedData.add(Gfx_Interpolation_Quint(i / (DATA_TABLE_LENGTH / 2), 0, LOGO_MOVEMENT_DISTANCE, GFX_INTERPOLATION_WHEN_EASE_OUT))
    }
    //Second half is an ease-out bounce, but reversed
    .for(var i = 0; i < DATA_TABLE_LENGTH / 2; i++) {
        .eval combinedData.add(Gfx_Interpolation_Bounce(i / (DATA_TABLE_LENGTH / 2), LOGO_MOVEMENT_DISTANCE, 0, GFX_INTERPOLATION_WHEN_EASE_OUT))
    }
    AddEffect(combinedData, "COMBINED QUINT AND BOUNCE")

// Classic sine movement data
    .var classicData = List()
    //First half of the path is an ease-in/out sine
    .for(var i = 0; i < DATA_TABLE_LENGTH / 2; i++) {
        .eval classicData.add(Gfx_Interpolation_Sine(i / (DATA_TABLE_LENGTH / 2), 0, LOGO_MOVEMENT_DISTANCE, GFX_INTERPOLATION_WHEN_EASE_IN_OUT))
    }
    //Second half is also an ease-in/out sine, but reversed
    .for(var i = 0; i < DATA_TABLE_LENGTH / 2; i++) {
        .eval classicData.add(Gfx_Interpolation_Sine(i / (DATA_TABLE_LENGTH / 2), LOGO_MOVEMENT_DISTANCE, 0, GFX_INTERPOLATION_WHEN_EASE_IN_OUT))
    }
    AddEffect(classicData, "CLASSIC SINE BACK AND FORTH")

// Bounce back from wall using quart movement data
    .var wallData = List()
    //First half of the path is an ease-in quart
    .for(var i = 0; i < DATA_TABLE_LENGTH / 2; i++) {
        .eval wallData.add(Gfx_Interpolation_Quart(i / (DATA_TABLE_LENGTH / 2), 0, LOGO_MOVEMENT_DISTANCE, GFX_INTERPOLATION_WHEN_EASE_IN))
    }
    //Second half is an ease-out quart reversed
    .for(var i = 0; i < DATA_TABLE_LENGTH / 2; i++) {
        .eval wallData.add(Gfx_Interpolation_Quart(i / (DATA_TABLE_LENGTH / 2), LOGO_MOVEMENT_DISTANCE, 0, GFX_INTERPOLATION_WHEN_EASE_OUT))
    }
    AddEffect(wallData, "WALL BOUNCE WITH QUART BACK AND FORTH")

//Render name lengths to output
effect_name_lengths:
    .for(var i = 0; i < effectNameLengths.size(); i++) {
        .byte effectNameLengths.get(i)
    }
    //Table must be terminated with 0, this is the signal for the end of the effect list.
    //Other tables are not terminated, this table will be checked when moving
    //to the next effect.
    .byte 0

//Render effect name addresses to output
effect_names:
    .for(var i = 0; i < effectNames.size(); i++) {
        .word effectNames.get(i)
    }

//Render effect shift addresses to output
effect_shifts:
    .for(var i = 0; i < effectShifts.size(); i++) {
        .word effectShifts.get(i)
    }

//Render effect offset addresses to output
effect_offsets:
    .for(var i = 0; i < effectOffsets.size(); i++) {
        .word effectOffsets.get(i)
    }