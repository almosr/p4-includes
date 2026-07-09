/**
 * Example program for std_lib/random
 *
 * The sample draws random images to the screen using various
 * random number generation macros from the includes.
 *
 * Demonstrates how to:
 *   - Use kernal calls for various operations, like reading keyboard,
 *     printing to screen and delays;
 *   - Set up hardware timer-based random number generation;
 *   - Use arithmetic random number generation with the same seed multiple times
 *     that produces the same pseudo-random output sequence for every iteration;
 *   - Initialise arithmetic random number generation using timer-based generation for
 *     different pseudo-random output sequence for every iteration;
 *   - Use timer-based random number generation that produces different actual
 *     random output sequence for every iteration.
 **/

//Enable convenient structures, must be done before imports
#define P4_INCLUDES_TED_STRUCTURE

#import "hardware/color.asm"
#import "hardware/screen.asm"
#import "hardware/ted.asm"
#import "hardware/ted.asm"
#import "kickass/memory.asm"
#import "std_lib/random.asm"
#import "system/address.asm"
#import "system/kernal.asm"

//Kickass directive: for printing using kernal function encode the texts in PETSCII format
.encoding "petscii_mixed"

//Allocate some zero-page registers that will be used by drawing
.namespace zp {
    *=$D0 "Zero page registers" virtual

    screen_pointer:         Kickass_Memory_ZeroPage_Integer()
    new_screen_pointer:     Kickass_Memory_ZeroPage_Integer()
    char:                   Kickass_Memory_ZeroPage_Byte()
    counter:                Kickass_Memory_ZeroPage_Byte()
    rnd_seed1:              Kickass_Memory_ZeroPage_Integer()   //Seed must be 2 words long
    rnd_seed2:              Kickass_Memory_ZeroPage_Integer()
}

*= SYSTEM_ADDRESS_BASIC_START "Basic Upstart"
    BasicUpstart(start)

*= $1010 "Code"
start:
    //Initialise timer-based random number generation,
    //must be called at least once per program execution.
    StdLib_Random_Initialise()

    //Set up screen
    jsr SYSTEM_KERNAL_VIDEO_RESET
    lda #Hardware_Color_Code(HARDWARE_COLOR_WHITE, 7)   //Set border and background color to white
    sta Ted.ColBorder
    sta Ted.ColBg

restart:
    //Draw an image using arithmetic random number generation
    //with a specific seed.
    jsr draw_pseudo_random_same_seed

    //Clear the image using arithmetic random number generation
    //with the same seed as before, so the random numbers in
    //the iteration will be the exact same, thus removes the
    //previously drawn image.
    jsr clear_pseudo_random_same_seed

    //Draw an image using arithmetic random number generation
    //with a timer-based random number generated seed.
    jsr draw_pseudo_random_different_seed

    //Draw an image using timer-based random number generation.
    jsr draw_simple_random

    //Start again
    jmp restart

//-------------------------------
draw_pseudo_random_same_seed:
    System_Kernal_Print("[lower][red][clr][blue]Draw [reverse on]PSEUDO-RANDOM[reverse off] with specific seed")
    lda #$66        //Checkered character for drawing
    sta zp.char

    //Set up random number generation routine
    StdLib_Memory_SetMemory(random_pseudo, random_routine)

    //Set up random seed
    StdLib_Memory_CopyAddressFromMemory(fixed_rnd_seed1, zp.rnd_seed1)
    StdLib_Memory_CopyAddressFromMemory(fixed_rnd_seed2, zp.rnd_seed2)
    jmp draw

random_pseudo:
    StdLib_Random_Generate_Arithmetic(zp.rnd_seed1, 0, 3)
    rts

//-------------------------------
clear_pseudo_random_same_seed:
    System_Kernal_Print("[lower][home][esc]q[green]Clear [reverse on]PSEUDO-RANDOM[reverse off] with previous seed")
    lda #'.'        //Dot character for clearing
    sta zp.char
    //Random routine is the same as previously

    //Set up same random seed as before
    StdLib_Memory_CopyAddressFromMemory(fixed_rnd_seed1, zp.rnd_seed1)
    StdLib_Memory_CopyAddressFromMemory(fixed_rnd_seed2, zp.rnd_seed2)
    jmp draw

//-------------------------------
draw_pseudo_random_different_seed:
    System_Kernal_Print("[lower][blue][clr][orange]Draw [reverse on]PSEUDO-RANDOM[reverse off] with random seed")
    lda #$66        //Checkered character for drawing
    sta zp.char

    //Set up random seed with 4 random numbers generated using hardware timers
    jsr random_simple_256
    sta zp.rnd_seed1.lo
    jsr random_simple_256
    sta zp.rnd_seed1.hi
    jsr random_simple_256
    sta zp.rnd_seed2.lo
    jsr random_simple_256
    sta zp.rnd_seed2.hi

    //Set up random number generation routine
    StdLib_Memory_SetMemory(random_simple_4, random_routine)

    jmp draw

random_simple_256:
    StdLib_Random_Generate_Simple(0, 255)
    rts

random_simple_4:
    StdLib_Random_Generate_Simple(0, 3)
    rts

//-------------------------------
draw_simple_random:
    System_Kernal_Print("[lower][green][clr][lower][home][esc]q[purple]Draw [reverse on]TIMER-BASED[reverse off] random")
    jmp draw

//--------------------------
//Draw randomly to the screen by moving the pointer to a random direction.
//Character that is used for drawing must be sent in zp.character,
//random generation routine call address in random_routine.
draw:
    //Start drawing from the middle of the screen
    .const TARGET_ADDRESS = SYSTEM_ADDRESS_SCREEN_MEMORY_CHARACTERS + Hardware_Screen_CalculateOffsetRelative(0.5, 0.5)
    StdLib_Memory_LoadAddressToRegisters(TARGET_ADDRESS, zp.screen_pointer)
    lda #0
    sta zp.counter      //Reset step counter

!draw_cycle:
    ldy #0
    lda zp.char
    sta (zp.screen_pointer),y
    jsr delay
    inc zp.counter
    bne !rethrow+

    System_Kernal_Print("[lower][home][esc]q[black]Press space to continue.")

    //First wait until no key is pressed
!:  jsr SYSTEM_KERNAL_GETIN
    bne !-

    //Wait until space key is pressed
!:  jsr SYSTEM_KERNAL_GETIN
    cmp #' '
    bne !-
    rts

!rethrow:
    //Calculate new coordinate based on random number between 0 and 3
.label random_routine = * + 1
    jsr $0000
    cmp #0
    beq !move_up+
    cmp #1
    beq !move_right+
    cmp #2
    beq !move_down+

    //Move left
    StdLib_Memory_CopyRegistersWithAdd(zp.screen_pointer, zp.new_screen_pointer, -1)
    jmp !move+

!move_up:
    StdLib_Memory_CopyRegistersWithAdd(zp.screen_pointer, zp.new_screen_pointer, -HARDWARE_SCREEN_WIDTH)
    jmp !move+

!move_right:
    StdLib_Memory_CopyRegistersWithAdd(zp.screen_pointer, zp.new_screen_pointer, 1)
    jmp !move+

!move_down:
    StdLib_Memory_CopyRegistersWithAdd(zp.screen_pointer, zp.new_screen_pointer, HARDWARE_SCREEN_WIDTH)

!move:
    //Before moving check whether the move would mean leaving the screen
    .const TOP_OF_SCREEN_ADDRESS = SYSTEM_ADDRESS_SCREEN_MEMORY_CHARACTERS + Hardware_Screen_CalculateOffset(0, 1)
    lda zp.new_screen_pointer.hi
    cmp #>TOP_OF_SCREEN_ADDRESS
    bcc !rethrow-   //When outside then pick another random number
    bne !+
    lda zp.new_screen_pointer.lo
    cmp #<TOP_OF_SCREEN_ADDRESS
    bcc !rethrow-

    .const BOTTOM_OF_SCREEN_ADDRESS = SYSTEM_ADDRESS_SCREEN_MEMORY_CHARACTERS + Hardware_Screen_CalculateOffset(HARDWARE_SCREEN_WIDTH - 1, HARDWARE_SCREEN_HEIGHT - 1)
!:  lda zp.new_screen_pointer.hi
    cmp #>BOTTOM_OF_SCREEN_ADDRESS
    bcc !+
    bcs !rethrow-
    lda zp.new_screen_pointer.lo
    cmp #<BOTTOM_OF_SCREEN_ADDRESS
    bcs !rethrow-

!:
    //Address is inside specified screen memory, use it as new address
    StdLib_Memory_CopyAddressFromMemory(zp.new_screen_pointer, zp.screen_pointer)
    jmp !draw_cycle-

//--------------------------
delay:
    //Read current kernal jiffy clock and store lowest value
    jsr SYSTEM_KERNAL_RDTIM
    sta $E0
    //Read clock again and compare it to stored value,
    //loop while the value doesn't change
!:  jsr SYSTEM_KERNAL_RDTIM
    cmp $E0
    beq !-
    rts

//------------ Data

//Fixed random seed for setting up pseudo-random generation
fixed_rnd_seed1:
    .word $2A56
fixed_rnd_seed2:
    .word $8DD3

