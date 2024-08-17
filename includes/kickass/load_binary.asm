/**
 * @file load_binary.asm
 *
 * KickAssembler's Load binary templates and related functions
 **/

#importonce

#import "std_lib/binary.asm"
#import "kickass/list.asm"

/**
 * Multicolor bitmap load binary template, P4I format (Multi Botticelli).
 *
 * Data chunks:
 *   LuminanceMatrix (length: $03e8) - luminance part of pixel colors.
 *   ColorMatrix (length: $03e8) - color part of pixel colors.
 *   BackgroundColor (length: 1) - global background color ($FF15), upper and lower nibble switched.
 *   ThirdColor (length: 1) - global 3rd color ($FF16), upper and lower nibble switched.
 *   Bitmap (length: $1f40) - bitmap of pixels.
 **/
.const KICKASS_LOAD_BINARY_MULTICOLOR_P4I_TEMPLATE = "C64FILE, LuminanceMatrix=$0000, ColorMatrix=$0400, BackgroundColor=$03ff, ThirdColor=$03fe, Bitmap=$0800, Dummy2=$07e8, Dummy1=$03e8"

/**
 * Get background color ($FF15) from loaded P4I bitmap file.
 *
 * @param file loaded P4I bitmap file variable.
 *
 * @return background color in TED format.
 **/
.function Kickass_LoadBinary_Multicolor_P4I_GetBackgroundColor(file) {
    .return StdLib_Binary_SwapNibbles(file.getBackgroundColor(0))
}

/**
 * Get third color ($FF16) from loaded P4I bitmap file.
 *
 * @param file loaded P4I bitmap file variable.
 *
 * @return third color in TED format.
 **/
.function Kickass_LoadBinary_Multicolor_P4I_GetThirdColor(file) {
    .return StdLib_Binary_SwapNibbles(file.getThirdColor(0))
}

/**
 * Load a binary file into a new list
 *
 * @param file file path to load.
 *
 * @return new list with the bytes from binary file.
 **/
.function Kickass_LoadBinary_LoadToList(file) {
    .return Kickass_List_CreateFromBinary(LoadBinary(file))
}