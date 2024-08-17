/**
 * @file gfx.asm
 *
 * Graphics manipulation-related functions and macros
 **/

#importonce

#import "std_lib/binary.asm"

/**
 * Get background color ($FF15) directly from memory from loaded P4I bitmap file.
 *
 * Changes:
 *   A register
 *
 * @param fileStartAddress start addess of loaded file in memory.
 *
 * @return A register - background color in TED format.
 **/
.macro StdLib_Gfx_P4I_GetBackgroundColor(fileStartAddress) {
    lda fileStartAddress + $03FF
    StdLib_Binary_SwapNibbles()
}

/**
 * Get third color ($FF16) directly from memory from loaded P4I bitmap file.
 *
 * Changes:
 *   A register
 *
 * @param fileStartAddress start addess of loaded file in memory.
 *
 * @return A register - third color in TED format.
 **/
.macro StdLib_Gfx_P4I_GetThirdColor(fileStartAddress) {
    lda fileStartAddress + $03FE
    StdLib_Binary_SwapNibbles()
}
