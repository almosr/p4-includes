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

/**
 * Convert a 16 bit integer into 3 byte long packed dest number.
 *
 * Created by Andrew Jacobs
 * Source: https://codebase64.net/doku.php?id=base:more_hexadecimal_to_decimal_conversion
 *
 * Changes:
 *   A and X registers, D flag (cleared)
 *
 * @param src source integer address (2 bytes, little endian).
 * @param dest destination packed dest number address (3 bytes).
 **/
.macro StdLib_Binary_WordToPackedBCD(src, dest) {
        sed		        //Switch to decimal mode
        lda #$00        //Ensure the result is clear
		sta dest+0
		sta dest+1
		sta dest+2

        ldx #16         //Number of source bits (16)

!convert:
        asl src+0	    //Shift out one bit
		rol src+1
		lda dest+0	    //And add into result
		adc dest+0
		sta dest+0
		lda dest+1	    //Propagating any carry
		adc dest+1
		sta dest+1
		lda dest+2	    //...thru whole result
		adc dest+2
		sta dest+2

        dex             //And repeat for next bit
        bne !convert-

        cld             //Back to binary
}