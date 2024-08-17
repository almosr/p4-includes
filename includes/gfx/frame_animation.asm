/**
 * @file frame_animation.asm
 *
 * Standard library frame animation
 */
#importonce

#import "std_lib/compression_rle.asm"
#import "kickass/load_binary.asm"
#import "internal/logging.asm"
#import "internal/gfx/frame_animation.asm"

/**
 * Render a packed (compressed) frame difference to code output.
 *
 * Size of input frames must match exactly.
 * Maximum supported data size is 65534 ($FFFE) bytes.
 *
 * @param baseFrame base (start) frame bytes in a list that used for calculating differences from.
 * @param newFrame new (next) frame bytes in a list that used for calculating differences to.
*/
.macro Gfx_FrameAnimation_Pack(baseFrame, newFrame) {
    .if (baseFrame.size() != newFrame.size()) .error "Input frame sizes are different, base frame: " + baseFrame.getSize() +", new frame: " + newFrame.getSize()

    //Size must be limited to be less than the value used for stop control word
    .if (baseFrame.size() > INTERNAL_GFX_FRAME_ANIMATION_MAX_SIZE) .error "Frame data is too large, maximum size " + INTERNAL_GFX_FRAME_ANIMATION_MAX_SIZE + "(" + toHexString(INTERNAL_GFX_FRAME_ANIMATION_MAX_SIZE) + "), actual: " + baseFrame.size()

    //Is there any value in the lists?
    .if (baseFrame.size() > 0) {

        //Yes, we can start comparing
        .var copyMode = true
        .var startOffset = 0
        .var baseValue = 0
        .var newValue = 0
        .var buffer = List()
        .var chunkCount = 0

        .for(var i = 0; i < baseFrame.size(); i++) {
            .eval baseValue = baseFrame.get(i)
            .eval newValue = newFrame.get(i)

            .if (baseValue == newValue) {
                .if (copyMode) {
                    //We have to switch mode
                    .eval copyMode = false

                    //Dump collected bytes if there was any
                    .if (buffer.size() > 0) {
                        Internal_Gfx_FrameAnimation_RenderChunk(chunkCount, startOffset, buffer)
                    }
                }
            } else {
                .if (!copyMode) {
                    //We have to switch mode
                    .eval copyMode = true

                    //Remember start offset, will be dumped to output later on
                    .eval startOffset = i
                    .eval buffer = List()
                    .eval chunkCount++
                }
                .eval buffer.add(newValue)
            }
        }

        .if (copyMode) {
            Internal_Gfx_FrameAnimation_RenderChunk(chunkCount, startOffset, buffer)
        }
    }

    //Emit stop control word to close frame
    .word INTERNAL_GFX_FRAME_ANIMATION_CONTROL_STOP
}

/**
 * Render a sequence of packed (compressed) frame differences to code output from input files.
 *
 * This macro takes a specified number of files and creates a sequence of differences for
 * animation rendering out of the frames.
 * Files must be named as: `baseFilenameXXX.extension`, where XXX is a sequence number starting from 0.
 * Sequence number should be padded with zeroes to cover the maximum number of digits required by
 * the number of files. For example: 17 files require two digits, so should be named as 00, 01, .., 17.
 *
 * @param baseFileName path and base file name for input files, name of all files should start with this string.
 * @param extension optional extension for all files, or empty string when not needed.
 * @param numberOfFiles number of files to process, minimum is 2.
 * @param stripLoadingAddress when set to `true` then first two bytes (loading address) will be removed from each file,
 *                            when `false` then files will be processed unchanged.
 **/
.macro Gfx_FrameAnimation_PackSequence(baseFileName, extension, numberOfFrames, stripLoadingAddress) {
    .if (numberOfFrames < 2) .error "Animation sequence packing failed, minimum required frames: 2, actual: " + numberOfFrames

    //Find out how many digits do we need to count up to the number of frames
    .var counterDigits = ceil(log10(numberOfFrames))

    .var previousFrame = Internal_Gfx_FrameAnimation_LoadFile(baseFileName, extension, 0, counterDigits, stripLoadingAddress)

    .for(var i = 1; i < numberOfFrames; i++) {
        .var currentFrame = Internal_Gfx_FrameAnimation_LoadFile(baseFileName, extension, i, counterDigits, stripLoadingAddress)
        Gfx_FrameAnimation_Pack(previousFrame, currentFrame)
        .eval previousFrame = currentFrame
    }
}

/**
 * Set up start address for animation data before playback.
 * This macro rewinds the playback back to the beginning.
 * An instance of `StdLib_Compression_Rle_Unpacker` macro must be included in the code and provided to this macro.
 *
 * Changes:
 *   A register
 *
 * @param unpackerRef label where `StdLib_Compression_Rle_Unpacker` macro was imported.
 * @param address start address of data structure produced by `Gfx_FrameAnimation_Pack` or
 *                `Gfx_FrameAnimation_PackSequence` macro.
 **/
.macro Gfx_FrameAnimation_SetDataStartAddress(unpackerRef, address) {
    //Load start address of animation data to the same register pair that is used by compression
    StdLib_Memory_LoadAddressToRegisters(address, unpackerRef.reg_src)
}

/**
 * Set up start address for animation data before playback.
 * This macro rewinds the playback back to the beginning.
 * An instance of `StdLib_Compression_Rle_Unpacker` macro must be included in the code and provided to this macro.
 *
 * Changes:
 *   A register
 *
 * @param unpackerRef label where `StdLib_Compression_Rle_Unpacker` macro was imported.
 * @param address address of word in memory that contains the start address of data structure
 *                produced by `Gfx_FrameAnimation_Pack` or `Gfx_FrameAnimation_PackSequence` macro.
 **/
.macro Gfx_FrameAnimation_SetDataStartAddressFromMemory(unpackerRef, address) {
    //Load start address of animation data from memory to the same register pair that is used by compression
    StdLib_Memory_CopyAddressFromMemory(address, unpackerRef.reg_src)
}

/**
 * Unpack frame data into memory relative to a base address.
 * Before executing code from this macro `Gfx_FrameAnimation_SetDataStartAddress` macro should be
 * used for setting up start address.
 * An instance of `StdLib_Compression_Rle_Unpacker` macro must be included in the code and provided to this macro.
 *
 * Changes:
 *   A and Y registers
 *
 * @param unpackerRef label where `StdLib_Compression_Rle_Unpacker` macro was imported.
 * @param baseAddress base address of target for frame unpacking, represents the base address of
 *                    the compressed data/files, all offsets will be added to this address.
 * @return after unpacking zero-page registers that were provided to the unpacker will contain the next address
 *         in memory behind the compressed and uncompressed data.
 **/
.macro Gfx_FrameAnimation_Unpack(unpackerRef, baseAddress) {
    !loop:
        ldy #1
        //Check if we finished, combine address bytes,
        //it will only be zero when both bytes are zero
        lda (unpackerRef.reg_src),y
        dey
        cmp #>INTERNAL_GFX_FRAME_ANIMATION_CONTROL_STOP
        bne !+

        //Finished playback, skip stop control word
        StdLib_Memory_AddToRegisters(unpackerRef.reg_src, 2)
        jmp !finished+

        //Init target address address (y = 0 here)
    !:  lda (unpackerRef.reg_src),y
        clc
        .if ((<baseAddress) != 0) {
            adc #<baseAddress
        }
        sta.zp unpackerRef.reg_dest
        iny
        lda (unpackerRef.reg_src),y
        adc #>baseAddress
        sta.zp unpackerRef.reg_dest + 1

        //Skip address word
        StdLib_Memory_AddToRegisters(unpackerRef.reg_src, 2)

        //Call decompress routine directly, all registers are set
        jsr unpackerRef.unpack
        jmp !loop-

    !finished:
}
