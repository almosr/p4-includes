/**
 * @file binary.asm
 *
 * Standard library binary operations.
 **/

#importonce

/**
 * Binary operation for swapping the nibbles in a byte.
 *
 * @param byte source byte for processing.
 *
 * @return byte with swapped nibbles.
 **/
.function StdLib_Binary_SwapNibbles(byte) {
    .return ((byte>>4) & $0f) | ((byte<<4) & $f0)
}

/**
 * Binary operation for swapping the nibbles in A register.
 * Source: http://www.6502.org/source/general/SWN.html
 *
 * Changes:
 *   A register
 **/
.macro StdLib_Binary_SwapNibbles() {
    asl
    adc  #$80
    rol
    asl
    adc  #$80
    rol
}