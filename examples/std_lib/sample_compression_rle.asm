/**
 * Example program for std_lib/compression_rle
 *
 * Demonstrates how to:
 *   - Set up RLE unpacking;
 *   - Pack (compress) a file into the code output at compile time;
 *   - Create your own compressed data manually at compile time;
 *   - Unpack (decompress) data at runtime.
 **/

#import "std_lib/compression_rle.asm"
#import "hardware/color.asm"
#import "hardware/screen.asm"
#import "system/address.asm"
#import "kickass/memory.asm"
#import "kickass/load_binary.asm"

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
    //Unpack screen data directly to the screen
    StdLib_Compression_Rle_Unpack(unpacker, compressed_color_data, SYSTEM_ADDRESS_SCREEN_MEMORY_COLORS)
    StdLib_Compression_Rle_Unpack(unpacker, compressed_character_data, SYSTEM_ADDRESS_SCREEN_MEMORY_CHARACTERS)

    //Wait indefinitely
    jmp *

    //Put unpacker routine here, unpacking will be jumping here
unpacker:
    StdLib_Compression_Rle_Unpacker(zp.src_reg, zp.dest_reg, zp.tmp_reg)

//--------- Data section
*= * "Data"

compressed_color_data:

    //Create beautiful colors.
    //Each row on the screen will be a different shade of the same color.
    .var screenColorList = List()
    .for(var y = 0; y < HARDWARE_SCREEN_HEIGHT; y++) {
        //Add one screen row of colors, luminance is depending on the row number (0 - 7)
        Kickass_List_AddMultiple(screenColorList, HARDWARE_SCREEN_WIDTH, Hardware_Color_Code(HARDWARE_COLOR_DARK_BLUE, mod(y, 7)))
    }

    //Create packed data from color list
    //Check compilation output, you will find the name `Colors`
    //and see how much space the packed (compressed) data requires.
    StdLib_CompressionRle_Pack("Colors", screenColorList)

compressed_character_data:

    //Load ASCII art binary file into a list.
    //It consists of one complete screen of characters, no color matrix.
    .var asciiArtList = Kickass_LoadBinary_LoadToList("../data/hi_p4_ascii.prg")

    //Remove loading address (first two bytes)
    .eval asciiArtList.remove(0)
    .eval asciiArtList.remove(0)

    //Invert each character
    .for(var i = 0; i < asciiArtList.size(); i++) {
        .eval asciiArtList.set(i, asciiArtList.get(i) | $80)
    }

    //Create packed data from character list.
    //Check compilation output, you will find the name `P4 ASCII art`
    //and see how much space the packed (compressed) data reauires.
    StdLib_CompressionRle_Pack("P4 ASCII art", asciiArtList)