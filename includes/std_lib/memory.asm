/**
 * @file memory.asm
 *
 * Standard library memory operations.
 **/

#importonce

#import "hardware/ted.asm"

/**
 * Enable RAM instead of RAM for reading starting from $8000 address.
 **/
.macro StdLib_Memory_EnableHighRAM() {
    sta HARDWARE_TED_HIGH_RAM_ENABLE
}

/**
 * Enable RAM instead of ROM for reading starting from $8000 address.
 **/
.macro StdLib_Memory_EnableHighROM() {
    sta HARDWARE_TED_HIGH_ROM_ENABLE
}

/**
 * Set a 16 bit integer (little-endian) to specified memory address.
 *
 * Changes:
 *   A register
 *
 * @param address target memory address to be loaded.
 * @param int16 integer to copy into memory (16 bit).
 **/
.macro StdLib_Memory_SetMemory(int16, address) {
    lda #<int16
    sta address
    lda #>int16
    sta address+1
}

/**
 * Load address to zero-page register pair.
 *
 * Changes:
 *   A register
 *
 * @param address address to be loaded.
 * @param zp_target zero-page target register for address.
 **/
.macro StdLib_Memory_LoadAddressToRegisters(address, zp_target) {
    lda #<address
    sta.zp zp_target
    lda #>address
    sta.zp zp_target + 1
}

/**
 * Copy a source zero-page register to another register.
 *
 * Changes:
 *   A register
 *
 * @param zp_src zero-page src register.
 * @param zp_target zero-page target register.
 **/
.macro StdLib_Memory_CopyRegister(zp_src, zp_target) {
    lda.zp zp_src
    sta.zp zp_target
}

/**
 * Copy a source zero-page register to another register and add an 8 bit integer to it.
 *
 * Changes:
 *   A register, C flag
 *
 * @param zp_src - zero-page src register.
 * @param zp_target - zero-page target register (can be the same as zp_src).
 * @param byte - integer to be added to register.
 **/
.macro StdLib_Memory_CopyRegisterWithAdd(zp_src, zp_target, byte) {
    lda.zp zp_src
    clc
    adc #byte
    sta.zp zp_target
}

/**
 * Add a 16 bit integer to a zero-page register pair.
 *
 * Changes:
 *   A register, C flag
 *
 * @param zp_target - zero-page target register for additon.
 * @param int - integer to be added to register.
 **/
.macro StdLib_Memory_AddToRegisters(zp_target, int) {
    lda.zp zp_target
    clc
    adc #<int
    sta.zp zp_target
    lda.zp zp_target+1
    adc #>int
    sta.zp zp_target+1
}

/**
 * Add a byte from a memory address to a zero-page register pair.
 *
 * Changes:
 *   A register, C flag
 *
 * @param zp_target zero-page target register for additon.
 * @param address address of byte to be added to register.
 **/
.macro StdLib_Memory_AddByteFromAddressToRegisters(zp_target, address) {
    lda.zp zp_target
    clc
    adc address
    sta.zp zp_target
    lda.zp zp_target+1
    adc #0
    sta.zp zp_target+1
}

/**
 * Add a byte from a memory address to a zero-page register pair and
 * also increase their value by 1.
 *
 * Changes:
 *   A register, C flag
 *
 * @param zp_target - zero-page target register for additon.
 * @param address - address of byte to be added to register.
 **/
.macro StdLib_Memory_AddBytePlus1FromAddressToRegisters(zp_target, address) {
    lda.zp zp_target
    sec
    adc address
    sta.zp zp_target
    lda.zp zp_target+1
    adc #0
    sta.zp zp_target+1
}

/**
 * Add an integer from a memory address to a zero-page register pair.
 *
 * Changes:
 *   A register, C flag
 *
 * @param zp_target zero-page target register for additon.
 * @param address address of integer to be added to register.
 **/
.macro StdLib_Memory_AddIntFromAddressToRegisters(zp_target, address) {
    lda.zp zp_target
    clc
    adc address
    sta.zp zp_target
    lda.zp zp_target+1
    adc address+1
    sta.zp zp_target+1
}

/**
 * Add an integer from a memory address to a zero-page register pair and
 * also increase their value by 1.
 *
 * Changes:
 *   A register, C flag
 *
 * @param zp_target zero-page target register for additon.
 * @param address address of integer to be added to register.
 **/
.macro StdLib_Memory_AddIntPlus1FromAddressToRegisters(zp_target, address) {
    lda.zp zp_target
    sec
    adc address
    sta.zp zp_target
    lda.zp zp_target+1
    adc address+1
    sta.zp zp_target+1
}

/**
 * Copy a source zero-page register pair to another register pait and add a 16 bit integer to them.
 *
 * Changes:
 *   A register, C flag
 *
 * @param zp_src zero-page src register.
 * @param zp_target zero-page target register (can be the same as zp_src).
 * @param int integer to be added to register.
 **/
.macro StdLib_Memory_CopyRegistersWithAdd(zp_src, zp_target, int) {
    lda.zp zp_src
    clc
    adc #<int
    sta.zp zp_target
    lda.zp zp_src+1
    adc #>int
    sta.zp zp_target+1
}

/**
 * Copy address from a memory address to zero-page register pair.
 *
 * Changes:
 *   A register
 *
 * @param srcAddress address of source memory.
 * @param zp_target target for address.
 *
 * @return address in zp_target register pair.
 **/
.macro StdLib_Memory_CopyAddressFromMemory(srcAddress, zp_target) {
        lda srcAddress
        sta.zp zp_target
        lda srcAddress+1
        sta.zp zp_target+1
}

/**
 * Copy address from an address table to zero-page register pair.
 *
 * Changes:
 *   A and Y registers
 *
 * @param table base address of source table.
 * @param zp_target target for address.
 * @param A_register index to the table.
 *
 * @return address in zp_target register pair.
 **/
.macro StdLib_Memory_CopyAddressFromTable(table, zp_target) {
        asl
        tay
        lda table,y
        sta.zp zp_target
        lda table+1,y
        sta.zp zp_target+1
}

/**
 * Copy address from a pointer (zero-page register pair) to zero-page register pair.
 *
 * Changes:
 *   A and Y register, X register modified only when source and target register pair are overlapping.
 *
 * @param zp_source zero-page register pair used as pointer.
 * @param zp_target zero-page target register pair for address.
 * @param A_register index to the table.
 *
 * @return address in zp_target register pair.
 **/
.macro StdLib_Memory_CopyAddressFromPointer(zp_source, zp_target) {
    .if (zp_source == zp_target || zp_source + 1 == zp_target) {
        asl
        tay
        lda (zp_source),y
        tax
        iny
        lda (zp_source),y
        stx.zp zp_target
        sta.zp zp_target+1
    } else {
        asl
        tay
        lda (zp_source),y
        sta.zp zp_target
        iny
        lda (zp_source),y
        sta.zp zp_target+1
    }
}

/**
 * Copy memory.
 *
 * Note: overlapping memory areas are not treated differently.
 *
 * Changes:
 *   A and Y register
 *
 * @param source_address source address for memory copy.
 * @param target_address target address for memory copy.
 * @param length length of copy (maximum 255 bytes).
 **/
.macro StdLib_Memory_Copy(source_address, target_address, length) {
    ldy #0
!:  lda source_address,y
    sta target_address,y
    iny
    cpy #length
    bne !-
}

/**
 * Fill memory.
 *
 * Changes:
 *   A and Y register
 *
 * @param target_address target address for memory fill.
 * @param value value for memory fill.
 * @param length length of fill (maximum 256 bytes).
 **/
.macro StdLib_Memory_Fill(target_address, value, length) {
    ldy #length-1
    lda #value
!:  sta target_address,y
    dey
    cpy #$ff
    bne !-
}
