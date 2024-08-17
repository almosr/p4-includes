/**
 * @file subroutine.asm
 *
 * Subroutine call-related functions.
 **/

#importonce

/**
 * Save register A for restoring.
 *
 * Use it in pair with StdLib_RestoreReg_A() macro at restoring.
 *
 * @praram target target restore macro label.
 **/
.macro StdLib_SaveReg_A(target) {
    sta target.a+1
}

/**
 * Save register X for restoring.
 *
 * Use it in pair with StdLib_RestoreReg_X() macro at restoring.
 *
 * @param target target restore macro label.
 **/
.macro StdLib_SaveReg_X(target) {
    stx target.x+1
}

/**
 * Save register Y for restoring.
 *
 * Use it in pair with StdLib_RestoreReg_Y() macro at restoring.
 *
 * @param target target restore macro label.
 **/
.macro StdLib_SaveReg_Y(target) {
    sty target.y+1
}

/**
 * Save register A and X for restoring.
 *
 * Use it in pair with StdLib_RestoreReg_AX() macro at restoring.
 *
 * @param target target restore macro label.
 **/
.macro StdLib_SaveReg_AX(target) {
    sta target.a+1
    stx target.x+1
}

/**
 * Save register A and Y for restoring.
 *
 * Use it in pair with StdLib_RestoreReg_AY() macro at restoring.
 *
 * @param target target restore macro label.
 **/
.macro StdLib_SaveReg_AY(target) {
    sta target.a+1
    sty target.y+1
}

/**
 * Save register X and Y for restoring.
 *
 * Use it in pair with StdLib_RestoreReg_XY() macro at restoring.
 *
 * @param target target restore macro label.
 **/
.macro StdLib_SaveReg_XY(target) {
    stx target.x+1
    sty target.y+1
}

/**
 * Save register A, X and Y for restoring.
 *
 * Use it in pair with StdLib_RestoreReg_AXY() macro at restoring.
 *
 * @param target - target restore macro label.
 **/
.macro StdLib_SaveReg_AXY(target) {
    sta target.a+1
    stx target.x+1
    sty target.y+1
}

/**
 * Restore register A from saved state.
 *
 * Use it in pair with StdLib_SaveReg_A() macro at saving.
 *
 * Changes:
 *   A register
 **/
.macro StdLib_RestoreReg_A() {
    a:  lda #0
}

/**
 * Restore register X from saved state.
 *
 * Use it in pair with StdLib_SaveReg_X() macro at saving.
 *
 * Changes:
 *   X register
 **/
.macro StdLib_RestoreReg_X() {
    x:  ldx #0
}

/**
 * Restore register Y from saved state.
 *
 * Use it in pair with StdLib_SaveReg_Y() macro at saving.
 *
 * Changes:
 *   Y register
 **/
.macro StdLib_RestoreReg_Y() {
    y:  ldy #0
}

/**
 * Restore register A and X from saved state.
 *
 * Use it in pair with StdLib_SaveReg_AX() macro at saving.
 *
 * Changes:
 *   A and X registers
 **/
.macro StdLib_RestoreReg_AX() {
    a:  lda #0
    x:  ldx #0
}

/**
 * Restore register A and Y from saved state.
 *
 * Use it in pair with StdLib_SaveReg_AY() macro at saving.
 *
 * Changes:
 *   A and Y registers
 **/
.macro StdLib_RestoreReg_AY() {
    a:  lda #0
    y:  ldy #0
}

/**
 * Restore register X and Y from saved state.
 *
 * Use it in pair with StdLib_SaveReg_XY() macro at saving.
 *
 * Changes:
 *   X and Y registers
 **/
.macro StdLib_RestoreReg_XY() {
    x:  ldx #0
    y:  ldy #0
}

/**
 * Restore register A, X and Y from saved state.
 *
 * Use it in pair with StdLib_SaveReg_AXY() macro at saving.
 *
 * Changes:
 *   A, X and Y registers
 **/
.macro StdLib_RestoreReg_AXY() {
    a:  lda #0
    x:  ldx #0
    y:  ldy #0
}

/**
 * Save register A to stack.
 *
 * Use it in pair with StdLib_StackRestoreReg_A() macro at restoring.
 **/
.macro StdLib_StackSaveReg_A() {
    pha
}

/**
 * Save register A and X to stack.
 *
 * Use it in pair with StdLib_StackRestoreReg_AX() macro at restoring.
 **/
.macro StdLib_StackSaveReg_AX() {
    pha
    txa
    pha
}

/**
 * Save register A and Y to stack.
 *
 * Use it in pair with StdLib_StackRestoreReg_AY() macro at restoring.
 **/
.macro StdLib_StackSaveReg_AY() {
    pha
    tya
    pha
}

/**
 * Save register A, X and Y to stack.
 *
 * Use it in pair with StdLib_StackRestoreReg_AXY() macro at restoring.
 **/
.macro StdLib_StackSaveReg_AXY() {
    pha
    tya
    pha
    txa
    pha
}

/**
 * Restore register A from stack.
 *
 * Use it in pair with StdLib_StackSaveReg_A() macro at saving.
 *
 * Changes:
 *   A register
 **/
.macro StdLib_StackRestoreReg_A() {
    pla
}

/**
 * Restore register A and X from stack.
 *
 * Use it in pair with StdLib_StackSaveReg_AX() macro at saving.
 *
 * Changes:
 *   A and X registers
 **/
.macro StdLib_StackRestoreReg_AX() {
    pla
    tax
    pla
}

/**
 * Restore register A and Y from stack.
 *
 * Use it in pair with StdLib_StackSaveReg_AY() macro at saving.
 *
 * Changes:
 *   A and Y registers
 **/
.macro StdLib_StackRestoreReg_AY() {
    pla
    tay
    pla
}

/**
 * Restore register A, X and Y from stack.
 *
 * Use it in pair with StdLib_StackSaveReg_AXY() macro at saving.
 *
 * Changes:
 *   A, X and Y registers
 **/
.macro StdLib_StackRestoreReg_AXY() {
    pla
    tax
    pla
    tay
    pla
}