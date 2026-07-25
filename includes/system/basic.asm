/**
 * @file basic.asm
 *
 * Various Commodore BASIC-related functions and calling macros.
 **/

#importonce

#import "kickass/functions.asm"
#import "kickass/list.asm"
#import "kickass/string.asm"

/**
 * Insert BASIC start code with SYS command into the code.
 *
 * @param targetAddress target address for the SYS command, must be a valid 16 bit address and available at first pass (constant).
 * @param lineNumber line number for the BASIC line in listing, must be a number in [0..65535] range and available at first pass (constant).
 * @param additionalText text after SYS command in BASIC listing, or empty string when not needed.
 **/
.macro System_Basic_Startup(targetAddress, lineNumber, additionalText) {
    .eval Kickass_Functions_CheckRanges(List().add("targetAddress", targetAddress, 0, 65535, "lineNumber", lineNumber, 0, 65535))

    .var bytes = List()

    //Add line number first
    .eval bytes.add(lineNumber & 255)
    .eval bytes.add(lineNumber >> 8)

    //Add BASIC SYS command
    .eval bytes.add($9E)

    //Add target address
    .var addressStr = "" + targetAddress
    .for (var i = 0; i < addressStr.size(); i++) {
        .eval bytes.add(addressStr.charAt(i))
    }

    //Add text
    .if (additionalText.size() > 0) {
        //Add separator space character
        .eval bytes.add(' ')

        .var upper = additionalText.toUpperCase()
        .eval bytes.addAll(Kickass_String_AsciiStringToPetscii(upper))
    }

    //BASIC line terminator
    .eval bytes.add(0)

    //Pointer to BASIC next line
    .var nextLine = * + bytes.size() + 2

    //BASIC program terminator
    .eval bytes.add(0,0)

    //Pointer to next line to code
    .word nextLine

    //Dump collected BASIC code bytes
    Kickass_List_DumpBytesToCode(bytes)
}