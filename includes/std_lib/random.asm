/**
 * @file memory.asm
 *
 * Standard library random number generation operations.
 **/

#importonce

#import "hardware/ted.asm"
#import "internal/std_lib/random.asm"

/**
 * Initialise random number generation.
 *
 * Please note: random number generation is relying on TED's hardware timers,
 * if you are using the timers for other purposes then the generated numbers
 * could be impacted.
 *
 * This macro must be executed only once in the lifetime of the program,
 * it sets up TED Timer #1 with a specific value that shortens its iteration cycle.
 *
 * Changes:
 *   A register
 **/
.macro StdLib_Random_Initialise() {
    lda #35
    sta HARDWARE_TED_TIMER_1_LOW
    lda #3
    sta HARDWARE_TED_TIMER_1_HIGH
}

/**
 * Generate a random number from a specified range using hardware timers.
 * This macro emits case-specific code that relies on TED timers for producing a random number.
 *
 * Changes:
 *   A and X register
 *
 * Please note: The shortcoming is that it does retries when the generated number is outside of the
 * required range.
 * When the upper bound of the length of the range is just over an exponent of 2 then the retry
 * range is equal to the difference to the next exponent of 2.
 * For example: when range is set to [22..151] then the range length is 129, this means random numbers
 * will be generated between 0 and 255 then any numbers over 129 will cause a re-generation. This situation
 * could cause unpredictable significant delays, therefore not recommended.
 *
 * @param rangeMinimum lower (inclusive) bound of the random range, must be between 0 and 255 and less than `rangeMaximum`.
 * @param rangeMaximum upper (inclusive) bound of the random range, must be between 0 and 255 and more than `rangeMinimum`.
 * @return A register - generated random number.
 **/
.macro StdLib_Random_Generate_Simple(rangeMinimum, rangeMaximum) {
    //Validate parameters
    Internal_StdLib_Random_RangeCheck(rangeMinimum, rangeMaximum)

    //Length of the generated range
    .var length = rangeMaximum - rangeMinimum

    //Number of bits required to repesent the generated range
    .var bits = floor(log(length) / log(2)) + 1

    //Bit mask for getting as many bits from random number as needed
    .var bitMask = pow(2, bits) - 1

    //Generate random number in [0..255] range
!rethrow:
    lda HARDWARE_TED_TIMER_2_LOW
    eor HARDWARE_TED_TIMER_3_LOW
    eor HARDWARE_TED_TIMER_1_LOW

    //Scale generated random byte to requested range
    Internal_StdLib_Random_ScaleToRange(rangeMinimum, rangeMaximum, !rethrow-)
}

/**
 * Generate a random number from a specified range using arithmetic operations (pseudo-random number).
 *
 * Created by Ian Bell and David Braben
 * Source: https://elite.bbcelite.com/cassette/main/subroutine/dornd.html
 *
 * For seed initialisation `StdLib_Random_Generate_Simple()` macro can be used when no other entropy
 * source is available.
 *
 * Please note: The shortcoming is that it does retries when the generated number is outside of the
 * required range.
 * When the upper bound of the length of the range is just over an exponent of 2 then the retry
 * range is equal to the difference to the next exponent of 2.
 * For example: when range is set to [22..151] then the range length is 129, this means random numbers
 * will be generated between 0 and 255 then any numbers over 129 will cause a re-generation. This situation
 * could cause unpredictable significant delays, therefore not recommended.
 *
 * @param seedAddress address of random seed that is used as a starting point, 4 bytes are used at the target address as seed.
 * @param rangeMinimum lower (inclusive) bound of the random range, must be between 0 and 255 and less than `rangeMaximum`.
 * @param rangeMaximum upper (inclusive) bound of the random range, must be between 0 and 255 and more than `rangeMinimum`.
 * @return A register - generated random number, new seed will be returned to the memory where `seedAddress` is pointing
           to for the next generation round.
 **/
.macro StdLib_Random_Generate_Arithmetic(seedAddress, rangeMinimum, rangeMaximum) {
    //Validate parameters
     Internal_StdLib_Random_RangeCheck(rangeMinimum, rangeMaximum)

    //Generate random number in [0..255] range
!rethrow:
    clc
    lda seedAddress
    rol
    tax
    adc seedAddress+2
    sta seedAddress
    stx seedAddress+2
    
    lda seedAddress+1
    tax       
    adc seedAddress+3
    sta seedAddress+1
    stx seedAddress+3

    //Scale generated random byte to requested range
    Internal_StdLib_Random_ScaleToRange(rangeMinimum, rangeMaximum, !rethrow-)
}