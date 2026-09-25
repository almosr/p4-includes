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
 * @param count requested number of `NOP` instructions (0 - 65535)
 */
.pseudocommand nopn count {
    .var number = count.getValue()
    .eval Kickass_Functions_CheckRange("count", number, 0, 65535)

    .for(var i = 0; i < number; i++) {
        nop
    }
}

/**
 * Pseudo-command for BEQ branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand beql target {
    .if (target.getType() != AT_ABSOLUTE) .error "Only absolute addressing can be used with BEQL instruction"

        bne !+
        jmp target
    !:
}

/**
 * Pseudo-command for BNE branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand bnel target {
    .if (target.getType() != AT_ABSOLUTE) .error "Only absolute addressing can be used with BNEL instruction"

        beq !+
        jmp target
    !:
}

/**
 * Pseudo-command for BCC branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand bccl target {
    .if (target.getType() != AT_ABSOLUTE) .error "Only absolute addressing can be used with BCCL instruction"

        bcs !+
        jmp target
    !:
}

/**
 * Pseudo-command for BCS branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand bcsl target {
    .if (target.getType() != AT_ABSOLUTE) .error "Only absolute addressing can be used with BCSL instruction"

        bcc !+
        jmp target
    !:
}

/**
 * Pseudo-command for BPL branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand bpll target {
    .if (target.getType() != AT_ABSOLUTE) .error "Only absolute addressing can be used with BPLL instruction"

        bmi !+
        jmp target
    !:
}

/**
 * Pseudo-command for BMI branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand bmil target {
    .if (target.getType() != AT_ABSOLUTE) .error "Only absolute addressing can be used with BMIL instruction"

        bpl !+
        jmp target
    !:
}

/**
 * Pseudo-command for BVC branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand bvcl target {
    .if (target.getType() != AT_ABSOLUTE) .error "Only absolute addressing can be used with BVCL instruction"

        bvs !+
        jmp target
    !:
}

/**
 * Pseudo-command for BVS branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand bvsl target {
    .if (target.getType() != AT_ABSOLUTE) .error "Only absolute addressing can be used with BVSL instruction"

        bvc !+
        jmp target
    !:
}

/**
 * Pseudo-command for incrementing a word sized data by 1 that is stored
 * on consecutive bytes in memory in little endian format (low, high).
 *
 * @param address target address of the word data, only works with absolute addressing.
 */
.pseudocommand incw address {
    .var type = address.getType()
    .if (type != AT_ABSOLUTE && type != AT_ABSOLUTEX && type != AT_ABSOLUTEY) .error "Only absolute addressing modes can be used with INCW instruction"

        inc address
        bne !+
        inc CmdArgument(address.getType(), address.getValue() + 1)
    !:
}

/**
 * Pseudo-command for decrementing a word sized data by 1 that is stored
 * on consecutive bytes in memory in little endian format (low, high).
 *
 * Changes:
 *  A register
 *
 * @param address target address of the word data, only works with absolute addressing.
 */
.pseudocommand decw address {
    .var type = address.getType()
    .if (type != AT_ABSOLUTE && type != AT_ABSOLUTEX && type != AT_ABSOLUTEY) .error "Only absolute addressing modes can be used with DECW instruction"

        lda address
        bne !+
        dec CmdArgument(address.getType(), address.getValue() + 1)
    !:  dec address
}
