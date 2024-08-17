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