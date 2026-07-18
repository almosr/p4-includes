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