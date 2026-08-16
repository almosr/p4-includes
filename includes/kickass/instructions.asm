/**
 * @file instructions.asm
 *
 * Kickass enhanced assembly instructions.
 **/

#importonce

#import "kickass/functions.asm"

/**
 * Pseudo-command for emitting specific number of `NOP` instructions to the code.
 *
 * @param argument requested number of `NOP` instructions (0 - 65535)
 */
.pseudocommand nopn count {
    .var number = count.getValue()
    .eval Kickass_Functions_CheckRange("argument", number, 0, 65535)

    .for(var i = 0; i < number; i++) {
        nop
    }
}