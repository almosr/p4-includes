//--------------------- Interals for gfx/frame animation
#importonce

.const INTERNAL_GFX_FRAME_ANIMATION_CONTROL_STOP = $FFFF
.const INTERNAL_GFX_FRAME_ANIMATION_MAX_SIZE = INTERNAL_GFX_FRAME_ANIMATION_CONTROL_STOP - 1

.macro Internal_Gfx_FrameAnimation_RenderChunk(chunkCount, startOffset, data) {
    //Render offset address to output
    .word startOffset

    //Compress collected bytes to output
    StdLib_CompressionRle_Pack("frame chunk #" + chunkCount + " (offset: $" + toHexString(startOffset) + ")", data)
}

.function Internal_Gfx_FrameAnimation_LoadFile(baseFileName, extension, frameIndex, counterDigits, stripLoadingAddress) {
    .var counter = "" + frameIndex

    //Pad frame index number with zeroes
    .for(var i = counter.size(); i < counterDigits; i++) {
        .eval counter = "0" + counter
    }

    //Add dot in front of extension when provided
    .var extStr = ""
    .if (extension.size() != 0) {
        .eval extStr = "." + extension
    }

    .var fileName = baseFileName + counter + extStr

    .eval Internal_P4_LogVerbose("Processing animation frame: " + fileName)

    .var result = Kickass_LoadBinary_LoadToList(fileName)

    .if (stripLoadingAddress) {
        .eval result.remove(0)
        .eval result.remove(0)
    }

    .return result
}
