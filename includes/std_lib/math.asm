/**
 * @file math.asm
 *
 * Standard mathematical operations.
 **/

#importonce

/**
 * Multiply two byte size integers.
 *
 * Changes:
 *   A, X and Y registers, source1_address (cleared)
 *
 * @param source1_address address of source byte #1.
 * @param source2_address address of source byte #2.
 * @param result_address address of destiation word (2 bytes).
 * @return result of multiplication in result_address.
 **/
.macro StdLib_Multiply_Byte2Byte(source1_address, source2_address, result_address) {
        ldx #7                  //Store number of iterations for a byte in counter

        lda #0
        sta result_address      //Clear LSB of result
        tay                     //Clear MSB of result that is stored in Y register
        beq !+                  //Skip rotation of empty result

    !cyc:
        asl result_address      //Multiply result by 2
        rol                     //A register stores the MSB from previous addition, multiply it by 2
        tay                     //Store MSB of result in Y register
    !:
        asl source1_address     //Get next bit from source #1
        bcc !skip+              //When not set then skip addition

        lda source2_address     //When bit was set then add source #2 to result
        clc
        adc result_address
        sta result_address      //Store LSB or result
        tya                     //MSB of result is stored in Y register, move it to A register
        adc #0                  //Add carry bit to MSB of result

    !skip:
        dex                     //Decrease bit counter
        bpl !cyc-               //If more bits left then iterate
        sta result_address + 1  //Store MSB of result
}

/**
 * Multiply two byte size integers with unrolled iteration.
 *
 * Note: while this macro generates much faster code than
 * `StdLib_Multiply_Byte2Byte`, the generated code is much larger.
 *
 * Changes:
 *   A, X and Y registers, source1_address (cleared)
 *
 * @param source1_address address of source byte #1.
 * @param source2_address address of source byte #2.
 * @param result_address address of destiation word (2 bytes).
 * @return result of multiplication in result_address.
 **/
.macro StdLib_Multiply_Byte2Byte_Unrolled(source1_address, source2_address, result_address) {
        lda #0
        sta result_address      //Clear LSB of result
        tay                     //Clear MSB of result that is stored in Y register

        //Copy multiplication by addition for each bit in the source #1 byte
        .for(var i = 0; i < 8; i++) {

                //For the first iteration result is still empty, skip multiplication
                .if (i != 0) {
                    asl result_address      //Multiply result by 2
                    rol                     //A register stores the MSB from previous addition, multiply it by 2
                    tay                     //Store MSB of result in Y register
                }

                asl source1_address     //Get next bit from source #1
                bcc !skip+              //When not set then skip addition

                lda source2_address     //When bit was set then add source #2 to result
                clc
                adc result_address
                sta result_address      //Store LSB or result
                tya                     //MSB of result is stored in Y register, move it to A register
                adc #0                  //Add carry bit to MSB of result

            !skip:
        }

        sta result_address + 1  //Store MSB of result
}

/**
 * Multiply a byte size integer to a constant byte size integer.
 * This macro produces an optimised code that executes the necessary
 * operations only for multiplication with the constant value.
 *
 * Changes:
 *   A and Y registers
 *
 * @param source_address address of source byte.
 * @param int source byte constant, must not be zero.
 * @param result_address address of destiation word (2 bytes).
 * @return result of multiplication in result_address.
 **/
.macro StdLib_Multiply_Byte2Byte_Const(source_address, int, result_address) {
    .if (int == 0) .error "Parameter `int` must not be zero."

    //Flag for signaling when result is not empty anymore
    .var hasResult = false

    //Iterate through exponents of 2 from high to low
    .for(var i = 7; i >= 0; i--) {

        //Check if shifting code needed for the result already.
        .if (hasResult) {
            asl result_address      //Multiply result by 2
            rol                     //A register stores the MSB from previous addition, multiply it by 2
        }

        //Check whether the current bit is set in the constant
        .if ((int & pow(2, i)) != 0) {
        
            //If we don't have result set previously then set it now
            .if (!hasResult) {

                //When the bit is set then we will have result already and different operations are needed
                .eval hasResult = true
                
                lda source_address      //Copy the source to result
                sta result_address
                lda #0                  //Clear MSB of result that is stored in A register

            } else {
                tay                     //Store MSB of result in Y register

                //We have result already, add source to the result
                lda source_address     //Add source to result
                clc
                adc result_address
                sta result_address      //Store LSB or result
                tya                     //MSB of result is stored in Y register, move it to A register
                adc #0                  //Add carry bit to MSB of result
            }
        }
    }

    sta result_address + 1  //Store MSB of result
}

/**
 * Multiply a byte size integer to a constant byte size integer using
 * a look-up table.
 *
 * Note: this macro produces very fast multiplication, but the look-up
 * table requires 512 bytes in the code. The look-up table will be
 * inlined in the code directly and the routine will jump over it.
 * Consider using `StdLib_Multiply_Byte2Byte_Const` macro instead,
 * for small constants that could produce almost as fast, but much
 * smaller code.
 *
 * Changes:
 *   A and X registers
 *
 * @param source_address address of source byte.
 * @param int source byte constant, must not be zero.
 * @param result_address address of destiation word (2 bytes).
 * @param subroutine if set to `false` then the macro continues the execution after the look-up table,
          when `true` then an RTS isntruction is added to the end of the macro, so it returns from
          a subroutine call.
 * @return result of multiplication in result_address.
 **/
.macro StdLib_Multiply_Byte2Byte_Table(source_address, int, result_address, subroutine) {
        ldx source_address      //Load source to X register for indexing
        lda !lookup_low+,x      //Get result LSB from lookup table
        sta result_address      //Put it to result target address
        lda !lookup_high+,x     //Get result MSB from lookup table
        sta result_address + 1  //Put it to result target address
        .if (subroutine) {
            rts
        } else {
            jmp !skip+          //Skip over lookup table
        }

    !lookup_low:
        .fill 256, <(i * int)

    !lookup_high:
        .fill 256, >(i * int)

    !skip:
}