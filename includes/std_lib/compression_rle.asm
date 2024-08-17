/**
 * @file compression_rle.asm
 *
 * Standard library RLE compression.
 **/

#importonce

#import "std_lib/memory.asm"
#import "internal/logging.asm"
#import "internal/std_lib/compression_rle.asm"

/**
  * Render a STOP command byte to compressed data to code output.
  **/
.macro StdLib_CompressionRle_RenderStop() {
    .byte INTERNAL_STD_LIB_COMPRESSION_RLE_CONTROL_STOP
}

/**
 * Render a packed (compressed) block to code output.
 *
 * @param length number of repetitions in uncompressed data.
 * @param value repeated byte value.
 */
.macro StdLib_CompressionRle_RenderPacked(length, value) {
    .if (length > INTERNAL_STD_LIB_COMPRESSION_RLE_MAX_LENGTH || length < 1) .error "Invalid run length, must be between 1 and " + INTERNAL_STD_LIB_COMPRESSION_RLE_MAX_LENGTH + ", actual: " + length

    //Special case: 1 long will be rendered as copy instead of packed
    .if (length == 1) {
        .byte INTERNAL_STD_LIB_COMPRESSION_RLE_CONTROL_COPY + 1, value
    } else {
        //Non-special case: store length as less by 1, because 1 long is covered and 0 length is not possible
        .byte INTERNAL_STD_LIB_COMPRESSION_RLE_CONTROL_REPEAT + length - 1, value
    }
}

/**
 * Render a copied (uncompressed) block to code output.
 *
 * @param value copied byte values in a list.
 **/
.macro StdLib_CompressionRle_RenderCopy(values) {
    .var length = values.size()
    .if (length > INTERNAL_STD_LIB_COMPRESSION_RLE_MAX_LENGTH || length < 1) .error "Invalid number of copied values, must be between 1 and " + INTERNAL_STD_LIB_COMPRESSION_RLE_MAX_LENGTH + ", actual: " + length

    .byte INTERNAL_STD_LIB_COMPRESSION_RLE_CONTROL_COPY + length - 1
    .fill length, values.get(i)
}

/**
 * Pack a list of bytes and render compressed data to code output.
 *
 * @param name name of the compressed block (for logging only).
 * @param value byte values in a list.
 **/
.macro StdLib_CompressionRle_Pack(name, values) {

    .var outputSize = 0

    //Is there any value in the list?
    .if (values.size() > 0) {

        //Yes, we can start compressing
        .var prev = values.get(0)
        .var copyMode = true
        .var runLength = 0
        .var current = 0
        .var buffer = List().add(prev)

        .for(var i = 1; i < values.size(); i++) {
            .eval current = values.get(i)

            .if (current == prev) {
                .if (copyMode) {
                    //We have to switch mode
                    .eval buffer.remove(buffer.size() - 1)  //Remove last item from copy buffer, that is the same as current
                    .if (buffer.size() > 0) {
                        StdLib_CompressionRle_RenderCopy(buffer)
                        .eval outputSize += buffer.size() + 1   //Outputted 1 control byte + copied bytes
                    }
                    .eval copyMode = false
                    .eval runLength = 1
                }
                .if (runLength == INTERNAL_STD_LIB_COMPRESSION_RLE_MAX_LENGTH) {
                    //Maximum length reached
                    StdLib_CompressionRle_RenderPacked(runLength, prev)
                    .eval outputSize += 1 + 1   //Outputted 1 control byte + 1 value byte
                    .eval runLength = 0
                }
                .eval runLength++
            } else {
                .if (!copyMode) {
                    //We have to switch mode
                    StdLib_CompressionRle_RenderPacked(runLength, prev)
                    .eval outputSize += 1 + 1   //Outputted 1 control byte + 1 value byte
                    .eval runLength = 0
                    .eval buffer = List()
                    .eval copyMode = true
                }
                .if (buffer.size() == INTERNAL_STD_LIB_COMPRESSION_RLE_MAX_LENGTH) {
                    //Maximum length reached
                    StdLib_CompressionRle_RenderCopy(buffer)
                    .eval outputSize += buffer.size() + 1   //Outputted 1 control byte + copied bytes
                    .eval buffer = List()
                }
                .eval buffer.add(current)
                .eval prev = current
            }
        }

        .if (copyMode) {
            StdLib_CompressionRle_RenderCopy(buffer)
            .eval outputSize += buffer.size() + 1   //Outputted 1 control byte + copied bytes
        } else {
            StdLib_CompressionRle_RenderPacked(runLength, prev)
            .eval outputSize += 1 + 1   //Outputted 1 control byte + 1 value byte
        }
    }

    //Emit stop control byte to close compressed data
    StdLib_CompressionRle_RenderStop()

    .eval Internal_P4_LogVerbose(name +" - RLE compressed data, input size: " + values.size() + ", compressed size: " + outputSize)
}

/**
 * Copy unpacker routine into code output.
 *
 * The unpacker routine can be placed anywhere in the code base that is reachable by a branch opcode (jsr).
 * Possible to include multiple versions of this routine with different zero-page registers.
 * Unpacking can be started either by using `StdLib_Compression_Rle_Unpack` macro, or by setting up
 * addresses in source and destination zero-page addresses and jump to `unpack` label inside this macro.
 *
 * Changes:
 *   A and Y registers
 *
 * @param zp_reg_src zero-page start address of register pair for compressed source data address.
 * @param zp_reg_dest zero-page start address of register pair for uncompressed destination data address.
 * @param zp_reg_tmp zero-page address of register for temporary values.
 **/
.macro StdLib_Compression_Rle_Unpacker(zp_reg_src, zp_reg_dest, zp_reg_tmp) {
    //Expose zero page registers to unpack macro via labels, so addresses can be loaded into these by setup macro
    .label reg_src = zp_reg_src
    .label reg_dest = zp_reg_dest

    //Exposed start address of the routine via label that will be called by setup macro
    .label unpack = *

    .eval Internal_P4_LogVerbose("Std Lib RLE unpacker included at $" + toHexString(*))

    !cyc:
        ldy	#$00
        lda	(zp_reg_src),y      //Read control byte
        bpl	!copy+              //Jump if copy

        cmp	#INTERNAL_STD_LIB_COMPRESSION_RLE_CONTROL_STOP   //Is this stop control byte?
        bne	!+                  //No, go on with compressed
        StdLib_Memory_AddToRegisters(zp_reg_src, 1)     //Skip stop control byte
        rts                     //Finished

    !:  and	#$7f                //Mask out length from control byte
        sta	zp_reg_tmp          //Uncompressed length stored as length - 1
        iny
        lda	(zp_reg_src),y      //Read value to duplicate
        ldy	zp_reg_tmp          //Y = length - 1
    !:	sta	(zp_reg_dest),y     //Fill destination memory with the same value
        dey
        bpl	!-                  //Until we run out of length (fill between 0 and length - 1 in reverse)

        //Source address steps ahead by 2
        StdLib_Memory_AddToRegisters(zp_reg_src, 2)

        jmp	!cont+
    
    !copy:
        tay
        sty	zp_reg_tmp          //Store length - 1

        inc	zp_reg_src          //Values to copy start from next byte at source address
        bne	!+
        inc	zp_reg_src+1

    !:	lda	(zp_reg_src),y      //Copy values from source to destionation
        sta	(zp_reg_dest),y
        dey
        bpl	!-                  //Until we run out of length (copy between 0 and length - 1 in reverse)

        //Both source and destination addresses step ahead by the length.
        //Length is stored as length - 1, so we also add 1 more to the address.
        StdLib_Memory_AddBytePlus1FromAddressToRegisters(zp_reg_src, zp_reg_tmp)

     !cont:
        StdLib_Memory_AddBytePlus1FromAddressToRegisters(zp_reg_dest, zp_reg_tmp)

        jmp	!cyc-               //Back to next control byte
}

/**
 * Unpack compressed data (setup macro).
 *
 * This macro sets up zero page registers that was provided to the unpacker routine then
 * calls the unpacker routine.
 *
 * Changes:
 *   A and Y registers
 *
 * @param unpacker_ref label where `StdLib_Compression_Rle_Unpacker` macro was imported.
 * @param source_address source address of the compressed data.
 * @param destination_address destination address of decompressed data.
 **/
.macro StdLib_Compression_Rle_Unpack(unpacker_ref, source_address, destination_address) {
    StdLib_Memory_LoadAddressToRegisters(source_address, unpacker_ref.reg_src)
    StdLib_Memory_LoadAddressToRegisters(destination_address, unpacker_ref.reg_dest)
    jsr unpacker_ref.unpack
}