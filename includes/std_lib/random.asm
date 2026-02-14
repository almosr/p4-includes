/**
 * @file memory.asm
 *
 * Standard library random number generation operations.
 **/

#importonce

#import "hardware/ted.asm"

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
 * Generate a random number from a specified range.
 * This macro emits case-specific code that relies on TED timers for producing a random number.
 *
 * Please note: the algorithm is very simple, it does not rely on any pseudo-random number generation.
 * The shortcoming is that it does retries when the generated number is outside of the required range.
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
    .if (rangeMinimum >= rangeMaximum) .error "Range minimum parameter must be smaller than range maximum parameter, current minimum: " + rangeMinimum +", current maximum: " + rangeMaximum
    .if (rangeMinimum < 0 || rangeMinimum > 255) .error "Range minimum parameter must fall into 0 to 255 range, current: " + rangeMinimum
    .if (rangeMaximum < 0 || rangeMaximum > 255) .error "Range maximum parameter must fall into 0 to 255 range, current: " + rangeMaximum

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

    //Adjust random number only if it is not the special case of [0..255] range,
    //otherwise the number is suitable already.
    .if (length < 255) {
        and #bitMask            //Leave only those bits we are interested in

        //When maximum generated random number after masking is not matching
        //the range length then we need fallback logic for dealing with out of range numbers.
        .if (length != bitMask) {
                cmp #length     //Is the generated number larger than the length?
                bcc !+          //When less or requal then we accept it
                beq !+
                jmp !rethrow-   //When larger then we need a new random number
            !:
        }

        //When the range minimum is not 0 then we must add it to
        //the generated random number to push it into the expected range.
        .if (rangeMinimum != 0) {
            clc
            adc #rangeMinimum
        }
    }
}