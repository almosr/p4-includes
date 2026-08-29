/**
 * @file image.asm
 *
 * Standard library image processing functinos/macros
 */
#importonce

#import "kickass/list.asm"
#import "internal/gfx/image.asm"

/**
 * Get one character from source, used as operation definition for \ref Gfx_Image_DefineCharset.
 **/
.struct Gfx_Image_CharsetGetChar {
    /** Source binary file reference loaded by LoadBinary() function. **/
    source,
    /** Source character index in the source binary which is also used as target index in the output character set. **/
    sourceIndex
}

/**
 * Copy one character from source to another target index in the output character set, used as operation definition for \ref Gfx_Image_DefineCharset.
 **/
.struct Gfx_Image_CharsetCopyChar {
    /** Source binary file reference loaded by LoadBinary() function. **/
    source,
    /** Source character index in the source binary. **/
    sourceIndex,
    /** Target character index in the output character set. **/
    targetIndex
}

/**
 * Get a number of characters from source, used as operation definition for \ref Gfx_Image_DefineCharset.
 **/
.struct Gfx_Image_CharsetGetChars {
    /** Source binary file reference loaded by LoadBinary() function. **/
    source,
    /** Starting source character index in the source binary which is also used as target index in the output character set. **/
    sourceIndex,
    /** Number of characters to copy. **/
    count
}

/**
 * Copy a number of characters from source to another target index in the output character set, used as operation definition for \ref Gfx_Image_DefineCharset.
 **/
.struct Gfx_Image_CharsetCopyChars {
    /** Source binary file reference loaded by LoadBinary() function. **/
    source,
    /** Starting source character index in the source binary. **/
    sourceIndex,
    /** Starting target character index in the output character set. **/
    targetIndex,
    /** Number of characters to copy. **/
    count
}

/**
 * Assemble a standard 8 byte/character character set out
 * of multiple sources and emit it into the code.
 * Based on a list of defined character operations the character set
 * is copied from the source sets and laid out in the code as expected
 * by the hardware.
 *
 * @param charsetDataList list of character operations, see:
 *        [Gfx_Image_CharsetGetChar], [Gfx_Image_CharsetCopyChar], [Gfx_Image_CharsetGetChars], [Gfx_Image_CharsetCopyChars].
 **/
.macro Gfx_Image_DefineCharset(charsetDataList) {
    .struct Char {
        source,
        index
    }

    .var chars = List()
    .var copiedChars = List()
    Kickass_List_AddMultiple(chars, 256, null)

    .for(var i = 0; i < charsetDataList.size(); i++) {
        .var data = charsetDataList.get(i)
        .var type = data.getStructName()
        .if (type == "Gfx_Image_CharsetGetChar") {
            //Get one specific character from source set
            .eval Internal_Gfx_Image_Charset_Add(chars, data.source, data.sourceIndex, data.sourceIndex)
            .eval copiedChars.add(data.sourceIndex)
        } else {
            .if (type == "Gfx_Image_CharsetCopyChar") {
                //Copy a character from a position in the source set to another position
                .eval Internal_Gfx_Image_Charset_Add(chars, data.source, data.targetIndex, data.sourceIndex)
                .eval copiedChars.add(data.targetIndex)
            } else {
                .if (type == "Gfx_Image_CharsetGetChars") {
                    //Get a range of characters from source set
                    .for(var j = 0; j < data.count; j++) {
                        .eval Internal_Gfx_Image_Charset_Add(chars, data.source, data.sourceIndex + j, data.sourceIndex + j)
                        .eval copiedChars.add(data.sourceIndex + j)
                    }
                } else {
                    .if (type == "Gfx_Image_CharsetCopyChars") {
                        //Get a range of characters from source set
                        .for(var j = 0; j < data.count; j++) {
                            .eval Internal_Gfx_Image_Charset_Add(chars, data.source, data.targetIndex + j, data.sourceIndex + j)
                            .eval copiedChars.add(data.targetIndex + j)
                        }
                    } else {
                        //Unrecognised definition
                        .error "Unrecognised character definition: " + type + " at position: " + i
                    }
                }
            }
        }
    }

    //Copy characters from source charsets

    //Copy only up to the highest PETSCII code
    .var maxChar = copiedChars.get(Kickass_List_FindMaximum(copiedChars))

    .for(var j = 0; j <= maxChar; j++) {
        .var char = chars.get(j)
        //Is this PETSCII code listed among the converted characters?
        //Note: this is a workaround for wrong null check implementation in KickAssembler
        .if ("" + char == "Null") {
            //If not listed then emit empty character bitmap
            .fill 8, 0
        } else {
            //If listed then copy character bitmap
            .fill 8, char.source.get(char.index * 8 + i)
        }
    }
}