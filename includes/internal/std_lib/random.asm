//--------------------- Internals for Std Lib/Random
#importonce

#import "kickass/functions.asm"

.macro Internal_StdLib_Random_RangeCheck(rangeMinimum, rangeMaximum) {
    .if (rangeMinimum >= rangeMaximum) .error "Range minimum parameter must be smaller than range maximum parameter, current minimum: " + rangeMinimum +", current maximum: " + rangeMaximum
    .eval Kickass_Functions_CheckRanges(List().add("rangeMinimum", rangeMinimum, 0, 255, "rangeMaximum", rangeMaximum, 0, 255))
}

.macro Internal_StdLib_Random_ScaleToRange(rangeMinimum, rangeMaximum, rethrow) {
    //Length of the generated range
    .var length = rangeMaximum - rangeMinimum

    //Number of bits required to repesent the generated range
    .var bits = floor(log(length) / log(2)) + 1

    //Bit mask for getting as many bits from random number as needed
    .var bitMask = pow(2, bits) - 1

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
                jmp rethrow     //When larger then we need a new random number
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