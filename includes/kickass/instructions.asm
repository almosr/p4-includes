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

/**
 * Pseudo-command for BEQ branch to a long jump when target address is out of range.
 * This instruction can be used instead of the native instruction when the distance
 * for the branch is out of [-128, 127] range.
 *
 * @param target target address of the branching.
 */
.pseudocommand beql target {
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
        bvc !+
        jmp target
    !:
}
