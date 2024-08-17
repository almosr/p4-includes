/**
 * Example program for std_lib/frame_animation.
 *
 * Demonstrates how to:
 *   - Load a Multi Botticelli (P4I) image file and display it on the screen.
 *   - Pack (compress) sequential animation frame files into the code output at compile time;
 *   - Aligning code execution to vertical blank at sccreen rendering.
 *   - Play back packed (compressed) animation at runtime.
 *   - Wait for a specific key press.
 **/

#import "gfx/frame_animation.asm"
#import "hardware/screen.asm"
#import "system/address.asm"
#import "system/key_scan.asm"
#import "std_lib/screen.asm"
#import "kickass/load_binary.asm"
#import "kickass/memory.asm"

.const FILE_NAME_BASE = "../data/anim"
.const FILE_NAME_EXTENSION = "p4i"

//Load first frame for displaying it as base image
.var firstFrameImage = LoadBinary(FILE_NAME_BASE + "00." + FILE_NAME_EXTENSION, KICKASS_LOAD_BINARY_MULTICOLOR_P4I_TEMPLATE)
.const IMAGE_BACKGROUND_COLOR = Kickass_LoadBinary_Multicolor_P4I_GetBackgroundColor(firstFrameImage)
.const IMAGE_SPECIAL_COLOR = Kickass_LoadBinary_Multicolor_P4I_GetThirdColor(firstFrameImage)

//Allocate some zero-page registers that will be used by unpacking routine
.namespace zp {
    *=$D0 "Zero page registers" virtual
    src_reg:    Kickass_Memory_ZeroPage_Integer()
    dest_reg:   Kickass_Memory_ZeroPage_Integer()
    tmp_reg:    Kickass_Memory_ZeroPage_Byte()
}

*= SYSTEM_ADDRESS_BASIC_START "Basic Upstart"
    BasicUpstart(start)

*= $1010 "Code"
start:
    //Turn on multicolor bitmap mode with colors from image file
    Hardware_Screen_InitMulticolorBitmap(SYSTEM_ADDRESS_GRAPHICS_MEMORY_BITMAP, SYSTEM_ADDRESS_GRAPHICS_MEMORY_LUMINANCE_MATRIX, IMAGE_BACKGROUND_COLOR, IMAGE_BACKGROUND_COLOR, IMAGE_SPECIAL_COLOR)

!restart:
    //Initialise animation playback
    Gfx_FrameAnimation_SetDataStartAddress(unpacker, anim)

!loop:
    //Wait 3 full screens before each frame,
    //so animation frame rate will be 50/3 = 8.33 FPS
    ldx #3
!wait:
    //Wait for off screen
    StdLib_Screen_WaitForVBlank()
    dex
    bne !wait-

    //Unpack next frame, base address is the beginning of the color matrix,
    //bitmap is located right after color matrix in memory, so these can be
    //handled as one complete frame.
    Gfx_FrameAnimation_Unpack(unpacker, SYSTEM_ADDRESS_GRAPHICS_MEMORY_LUMINANCE_MATRIX)

    //Is the anim playback done?
    lda.zp zp.src_reg.lo
    cmp #<anim_end
    bne !loop-
    lda.zp zp.src_reg.hi
    cmp #>anim_end
    bne !loop-

    //Wait for space key press to restart
!:  lda.zp SYSTEM_ADDRESS_PRESSED_KEY
    cmp #SYSTEM_KEY_SCAN_SPACE
    bne !-

    //Restore original screen
    Gfx_FrameAnimation_SetDataStartAddress(unpacker, restore_screen)
    Gfx_FrameAnimation_Unpack(unpacker, SYSTEM_ADDRESS_GRAPHICS_MEMORY_LUMINANCE_MATRIX)

    jmp !restart-

    //Put unpacker routine here, unpacking will be jumping here
unpacker:
    StdLib_Compression_Rle_Unpacker(zp.src_reg, zp.dest_reg, zp.tmp_reg)

//Set first frame up in memory to display it at runtime.
*= SYSTEM_ADDRESS_GRAPHICS_MEMORY_LUMINANCE_MATRIX "Image luminance matrix"
    .fill firstFrameImage.getLuminanceMatrixSize(), firstFrameImage.getLuminanceMatrix(i)

*= SYSTEM_ADDRESS_GRAPHICS_MEMORY_COLOR_MATRIX "Image color matrix"
    .fill firstFrameImage.getColorMatrixSize(), firstFrameImage.getColorMatrix(i)

*= SYSTEM_ADDRESS_GRAPHICS_MEMORY_BITMAP "Image bitmap"
    .fill firstFrameImage.getBitmapSize(), firstFrameImage.getBitmap(i)

*= * "Data"
anim:
    //Import and compress 18 frames of animation from file sequence
    Gfx_FrameAnimation_PackSequence(FILE_NAME_BASE, FILE_NAME_EXTENSION, 18, true)
anim_end:

    //Load first and last image
    .var firstFrame = Kickass_LoadBinary_LoadToList(FILE_NAME_BASE + "00." + FILE_NAME_EXTENSION)
    .var lastFrame = Kickass_LoadBinary_LoadToList(FILE_NAME_BASE + "17." + FILE_NAME_EXTENSION)

    //Remove loading addresses
    .eval firstFrame.remove(0)
    .eval firstFrame.remove(0)
    .eval lastFrame.remove(0)
    .eval lastFrame.remove(0)

restore_screen:
    //Create a frame difference pack from last image to first image, so animation can be reset
    Gfx_FrameAnimation_Pack(lastFrame, firstFrame)