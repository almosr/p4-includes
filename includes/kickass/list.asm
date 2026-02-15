/**
 * @file list.asm
 *
 * List-related macros and functions.
 **/

#importonce

/**
 * Copy a specific item into a list multiple times.
 *
 * @param list target list.
 * @param count number of times to copy the item.
 * @param item item to copy.
 **/
.macro Kickass_List_AddMultiple(list, count, item) {
    .for(var i = 0; i < count; i++) {
        .eval list.add(item)
    }
}

/**
 * Add all bytes to list from binary data that was loaded by KickAssembler's `LoadBinary` function.
 *
 * @param binary source binary.
 * @param list target list.
 **/
.function Kickass_List_AddFromBinary(binary, list) {
    .for(var i = 0; i < binary.getSize(); i++) {
        .eval list.add(binary.get(i))
    }
}

/**
 * Create a new list from binary data that was loaded by KickAssembler's `LoadBinary` function.
 *
 * @param binary source binary.
 *
 * @return new list with the copy of bytes from binary parameter.
 **/
.function Kickass_List_CreateFromBinary(binary) {
    .var list = List()

    .eval Kickass_List_AddFromBinary(binary, list)

    .return list
}

/**
 * Dumps list items into code as bytes.
 *
 * @param byteList list to dump into code.
 **/
.macro Kickass_List_DumpBytesToCode(byteList) {
    .for(var i = 0; i < byteList.size(); i++) {
        .byte byteList.get(i)
    }
}

/**
 * Dumps list items into code as words.
 *
 * @param wordList list to dump into code.
 **/
.macro Kickass_List_DumpWordsToCode(wordList) {
    .for(var i = 0; i < wordList.size(); i++) {
        .word wordList.get(i)
    }
}

/**
 * Dumps word list items into code into two separate sets for low and high byte.
 * These can be accessed as `.lo` and `.hi` appended to the label at the macro call position.
 *
 * @param wordList list to dump into code.
 **/
.macro Kickass_List_DumpWordsLowHighToCode(wordList) {
    .label lo = *
    .for(var i = 0; i < wordList.size(); i++) {
        .byte wordList.get(i) & 255
    }

    .label hi = *
    .for(var i = 0; i < wordList.size(); i++) {
        .byte floor(wordList.get(i) / 256)
    }
}

/**
 * Find a value in a list.
 *
 * @param list list for finding the value in.
 * @param value value to look for.
 * @return index of the value when found, or -1 when missing from the list.
 **/
.function Kickass_List_Find(list, value) {
    .for(var i = 0; i < list.size(); i++) {
        .if (list.get(i) == value) {
            .return i
        }
    }
    .return -1
}