/**
 * @file keyboard.asm
 *
 * Keyboard-related constants.
 * @see std_lib/keyboard/StdLib_Keyboard_ReadKey macro regarding the use of these constants.
 **/

#importonce

/**
 * Select keyboard row 0
 * Keys in this row are: @ F3 F2 F1 HELP RETURN DEL
 **/
.const HARDWARE_KEYBOARD_SELECT_ROW_0 = %11111110

/**
 * Select keyboard row 1
 * Keys in this row are: SHIFT E S Z 4 A W 3
 **/
.const HARDWARE_KEYBOARD_SELECT_ROW_1 = %11111101

/**
 * Select keyboard row 2
 * Keys in this row are: X T F C 6 D R 5
 **/
.const HARDWARE_KEYBOARD_SELECT_ROW_2 = %11111011

/**
 * Select keyboard row 3
 * Keys in this row are: V U H B 8 G Y 7
 **/
.const HARDWARE_KEYBOARD_SELECT_ROW_3 = %11110111

/**
 * Select keyboard row 4
 * Keys in this row are: N O K M 0 J I 9
 **/
.const HARDWARE_KEYBOARD_SELECT_ROW_4 = %11101111

/**
 * Select keyboard row 5
 * Keys in this row are: , - : . CURSOR_UP  L P CURSOR_DOWN
 **/
.const HARDWARE_KEYBOARD_SELECT_ROW_5 = %11011111

/**
 * Select keyboard row 6
 * Keys in this row are: / + = ESCAPE CURSOR_RIGHT ; * CURSOR_LEFT
 **/
.const HARDWARE_KEYBOARD_SELECT_ROW_6 = %10111111

/**
 * Select keyboard row 7
 * Keys in this row are: RUN/STOP Q CBM SPACE 2 CONTROL HOME 1
 **/
.const HARDWARE_KEYBOARD_SELECT_ROW_7 = %01111111

/**
 * Keyboard result for @
 **/
.const HARDWARE_KEYBOARD_KEY_AT            = %10000000
/**
 * Keyboard result for Shift
 **/
.const HARDWARE_KEYBOARD_KEY_SHIFT         = %10000000
/**
 * Keyboard result for X
 **/
.const HARDWARE_KEYBOARD_KEY_X             = %10000000
/**
 * Keyboard result for V
 **/
.const HARDWARE_KEYBOARD_KEY_V             = %10000000
/**
 * Keyboard result for N
 **/
.const HARDWARE_KEYBOARD_KEY_N             = %10000000
/**
 * Keyboard result for ,
 **/
.const HARDWARE_KEYBOARD_KEY_COMMA         = %10000000
/**
 * Keyboard result for /
 **/
.const HARDWARE_KEYBOARD_KEY_FORWARD_SLASH = %10000000
/**
 * Keyboard result for Run/Stop
 **/
.const HARDWARE_KEYBOARD_KEY_RUN_STOP      = %10000000

/**
 * Keyboard result for F3
 **/
.const HARDWARE_KEYBOARD_KEY_F3            = %01000000
/**
 * Keyboard result for E
 **/
.const HARDWARE_KEYBOARD_KEY_E             = %01000000
/**
 * Keyboard result for T
 **/
.const HARDWARE_KEYBOARD_KEY_T             = %01000000
/**
 * Keyboard result for U
 **/
.const HARDWARE_KEYBOARD_KEY_U             = %01000000
/**
 * Keyboard result for O
 **/
.const HARDWARE_KEYBOARD_KEY_O             = %01000000
/**
 * Keyboard result for -
 **/
.const HARDWARE_KEYBOARD_KEY_MINUS         = %01000000
/**
 * Keyboard result for +
 **/
.const HARDWARE_KEYBOARD_KEY_PLUS          = %01000000
/**
 * Keyboard result for Q
 **/
.const HARDWARE_KEYBOARD_KEY_Q             = %01000000

/**
 * Keyboard result for F2
 **/
.const HARDWARE_KEYBOARD_KEY_F2            = %00100000
/**
 * Keyboard result for S
 **/
.const HARDWARE_KEYBOARD_KEY_S             = %00100000
/**
 * Keyboard result for F
 **/
.const HARDWARE_KEYBOARD_KEY_F             = %00100000
/**
 * Keyboard result for H
 **/
.const HARDWARE_KEYBOARD_KEY_H             = %00100000
/**
 * Keyboard result for K
 **/
.const HARDWARE_KEYBOARD_KEY_K             = %00100000
/**
 * Keyboard result for :
 **/
.const HARDWARE_KEYBOARD_KEY_COLON         = %00100000
/**
 * Keyboard result for =
 **/
.const HARDWARE_KEYBOARD_KEY_EQUALS        = %00100000
/**
 * Keyboard result for Commodore key
 **/
.const HARDWARE_KEYBOARD_KEY_CBM           = %00100000

/**
 * Keyboard result for F1
 **/
.const HARDWARE_KEYBOARD_KEY_F1            = %00010000
/**
 * Keyboard result for Z
 **/
.const HARDWARE_KEYBOARD_KEY_Z             = %00010000
/**
 * Keyboard result for C
 **/
.const HARDWARE_KEYBOARD_KEY_C             = %00010000
/**
 * Keyboard result for B
 **/
.const HARDWARE_KEYBOARD_KEY_B             = %00010000
/**
 * Keyboard result for M
 **/
.const HARDWARE_KEYBOARD_KEY_M             = %00010000
/**
 * Keyboard result for .
 **/
.const HARDWARE_KEYBOARD_KEY_DOT           = %00010000
/**
 * Keyboard result for Escape
 **/
.const HARDWARE_KEYBOARD_KEY_ESCAPE        = %00010000
/**
 * Keyboard result for Space
 **/
.const HARDWARE_KEYBOARD_KEY_SPACE         = %00010000

/**
 * Keyboard result for Help
 **/
.const HARDWARE_KEYBOARD_KEY_HELP          = %00001000
/**
 * Keyboard result for 4
 **/
.const HARDWARE_KEYBOARD_KEY_4             = %00001000
/**
 * Keyboard result for 6
 **/
.const HARDWARE_KEYBOARD_KEY_6             = %00001000
/**
 * Keyboard result for 8
 **/
.const HARDWARE_KEYBOARD_KEY_8             = %00001000
/**
 * Keyboard result for 0
 **/
.const HARDWARE_KEYBOARD_KEY_0             = %00001000
/**
 * Keyboard result for Cursor up
 **/
.const HARDWARE_KEYBOARD_KEY_CURSOR_UP     = %00001000
/**
 * Keyboard result for Cursor right
 **/
.const HARDWARE_KEYBOARD_KEY_CURSOR_RIGHT  = %00001000
/**
 * Keyboard result for 2
 **/
.const HARDWARE_KEYBOARD_KEY_2             = %00001000

/**
 * Keyboard result for Pound
 **/
.const HARDWARE_KEYBOARD_KEY_POUND         = %00000100
/**
 * Keyboard result for A
 **/
.const HARDWARE_KEYBOARD_KEY_A             = %00000100
/**
 * Keyboard result for D
 **/
.const HARDWARE_KEYBOARD_KEY_D             = %00000100
/**
 * Keyboard result for G
 **/
.const HARDWARE_KEYBOARD_KEY_G             = %00000100
/**
 * Keyboard result for J
 **/
.const HARDWARE_KEYBOARD_KEY_J             = %00000100
/**
 * Keyboard result for L
 **/
.const HARDWARE_KEYBOARD_KEY_L             = %00000100
/**
 * Keyboard result for ;
 **/
.const HARDWARE_KEYBOARD_KEY_SEMICOLON     = %00000100
/**
 * Keyboard result for Control
 **/
.const HARDWARE_KEYBOARD_KEY_CONTROL       = %00000100

/**
 * Keyboard result for Return
 **/
.const HARDWARE_KEYBOARD_KEY_RETURN        = %00000010
/**
 * Keyboard result for W
 **/
.const HARDWARE_KEYBOARD_KEY_W             = %00000010
/**
 * Keyboard result for R
 **/
.const HARDWARE_KEYBOARD_KEY_R             = %00000010
/**
 * Keyboard result for Y
 **/
.const HARDWARE_KEYBOARD_KEY_y             = %00000010
/**
 * Keyboard result for I
 **/
.const HARDWARE_KEYBOARD_KEY_I             = %00000010
/**
 * Keyboard result for P
 **/
.const HARDWARE_KEYBOARD_KEY_P             = %00000010
/**
 * Keyboard result for *
 **/
.const HARDWARE_KEYBOARD_KEY_ASTERISK      = %00000010
/**
 * Keyboard result for Home
 **/
.const HARDWARE_KEYBOARD_KEY_HOME          = %00000010

/**
 * Keyboard result for Delete
 **/
.const HARDWARE_KEYBOARD_KEY_DELETE        = %00000001
/**
 * Keyboard result for 3
 **/
.const HARDWARE_KEYBOARD_KEY_3             = %00000001
/**
 * Keyboard result for 5
 **/
.const HARDWARE_KEYBOARD_KEY_5             = %00000001
/**
 * Keyboard result for 7
 **/
.const HARDWARE_KEYBOARD_KEY_7             = %00000001
/**
 * Keyboard result for 9
 **/
.const HARDWARE_KEYBOARD_KEY_9             = %00000001
/**
 * Keyboard result for Cursor down
 **/
.const HARDWARE_KEYBOARD_KEY_CURSOR_DOWN   = %00000001
/**
 * Keyboard result for Cursor left
 **/
.const HARDWARE_KEYBOARD_KEY_CURSOR_LEFT   = %00000001
/**
 * Keyboard result for 1
 **/
.const HARDWARE_KEYBOARD_KEY_1             = %00000001

/**
 * Structure that describes row and key (column) for a key test.
 **/
.struct Hardware_Keyboard_KeyTest { row, key }

/**
 * Keyboard test for @
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_AT            = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_0, HARDWARE_KEYBOARD_KEY_AT)
/**
 * Keyboard test for Shift
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_SHIFT         = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_1, HARDWARE_KEYBOARD_KEY_SHIFT)
/**
 * Keyboard test for X
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_X             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_2, HARDWARE_KEYBOARD_KEY_X)
/**
 * Keyboard test for V
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_V             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_3, HARDWARE_KEYBOARD_KEY_V)
/**
 * Keyboard test for N
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_N             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_4, HARDWARE_KEYBOARD_KEY_N)
/**
 * Keyboard test for ,
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_COMMA         = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_5, HARDWARE_KEYBOARD_KEY_COMMA)
/**
 * Keyboard test for /
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_FORWARD_SLASH = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_6, HARDWARE_KEYBOARD_KEY_FORWARD_SLASH)
/**
 * Keyboard test for Run/Stop
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_RUN_STOP      = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_7, HARDWARE_KEYBOARD_KEY_RUN_STOP)

/**
 * Keyboard test for F3
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_F3            = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_0, HARDWARE_KEYBOARD_KEY_F3)
/**
 * Keyboard test for E
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_E             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_1, HARDWARE_KEYBOARD_KEY_E)
/**
 * Keyboard test for T
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_T             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_2, HARDWARE_KEYBOARD_KEY_T)
/**
 * Keyboard test for U
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_U             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_3, HARDWARE_KEYBOARD_KEY_U)
/**
 * Keyboard test for O
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_O             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_4, HARDWARE_KEYBOARD_KEY_O)
/**
 * Keyboard test for -
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_MINUS         = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_5, HARDWARE_KEYBOARD_KEY_MINUS)
/**
 * Keyboard test for +
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_PLUS          = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_6, HARDWARE_KEYBOARD_KEY_PLUS)
/**
 * Keyboard test for Q
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_Q             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_7, HARDWARE_KEYBOARD_KEY_Q)

/**
 * Keyboard test for F2
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_F2            = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_0, HARDWARE_KEYBOARD_KEY_F2)
/**
 * Keyboard test for S
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_S             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_1, HARDWARE_KEYBOARD_KEY_S)
/**
 * Keyboard test for F
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_F             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_2, HARDWARE_KEYBOARD_KEY_F)
/**
 * Keyboard test for H
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_H             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_3, HARDWARE_KEYBOARD_KEY_H)
/**
 * Keyboard test for K
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_K             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_4, HARDWARE_KEYBOARD_KEY_K)
/**
 * Keyboard test for :
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_COLON         = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_5, HARDWARE_KEYBOARD_KEY_COLON)
/**
 * Keyboard test for =
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_EQUALS        = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_6, HARDWARE_KEYBOARD_KEY_EQUALS)
/**
 * Keyboard test for Commodore key
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_CBM           = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_7, HARDWARE_KEYBOARD_KEY_CBM)

/**
 * Keyboard test for F1
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_F1            = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_0, HARDWARE_KEYBOARD_KEY_F1)
/**
 * Keyboard test for Z
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_Z             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_1, HARDWARE_KEYBOARD_KEY_Z)
/**
 * Keyboard test for C
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_C             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_2, HARDWARE_KEYBOARD_KEY_C)
/**
 * Keyboard test for B
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_B             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_3, HARDWARE_KEYBOARD_KEY_B)
/**
 * Keyboard test for M
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_M             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_4, HARDWARE_KEYBOARD_KEY_M)
/**
 * Keyboard test for .
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_DOT           = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_5, HARDWARE_KEYBOARD_KEY_DOT)
/**
 * Keyboard test for Escape
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_ESCAPE        = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_6, HARDWARE_KEYBOARD_KEY_ESCAPE)
/**
 * Keyboard test for Space
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_SPACE         = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_7, HARDWARE_KEYBOARD_KEY_SPACE)

/**
 * Keyboard test for Help
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_HELP          = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_0, HARDWARE_KEYBOARD_KEY_HELP)
/**
 * Keyboard test for 4
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_4             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_1, HARDWARE_KEYBOARD_KEY_4)
/**
 * Keyboard test for 6
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_6             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_2, HARDWARE_KEYBOARD_KEY_6)
/**
 * Keyboard test for 8
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_8             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_3, HARDWARE_KEYBOARD_KEY_8)
/**
 * Keyboard test for 0
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_0             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_4, HARDWARE_KEYBOARD_KEY_0)
/**
 * Keyboard test for Cursor up
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_CURSOR_UP     = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_5, HARDWARE_KEYBOARD_KEY_CURSOR_UP)
/**
 * Keyboard test for Cursor right
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_CURSOR_RIGHT  = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_6, HARDWARE_KEYBOARD_KEY_CURSOR_RIGHT)
/**
 * Keyboard test for 2
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_2             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_7, HARDWARE_KEYBOARD_KEY_2)

/**
 * Keyboard test for Pound
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_POUND         = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_0, HARDWARE_KEYBOARD_KEY_POUND)
/**
 * Keyboard test for A
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_A             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_1, HARDWARE_KEYBOARD_KEY_A)
/**
 * Keyboard test for D
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_D             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_2, HARDWARE_KEYBOARD_KEY_D)
/**
 * Keyboard test for G
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_G             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_3, HARDWARE_KEYBOARD_KEY_G)
/**
 * Keyboard test for J
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_J             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_4, HARDWARE_KEYBOARD_KEY_J)
/**
 * Keyboard test for L
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_L             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_5, HARDWARE_KEYBOARD_KEY_L)
/**
 * Keyboard test for ;
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_SEMICOLON     = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_6, HARDWARE_KEYBOARD_KEY_SEMICOLON)
/**
 * Keyboard test for Control
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_CONTROL       = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_7, HARDWARE_KEYBOARD_KEY_CONTROL)

/**
 * Keyboard test for Return
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_RETURN        = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_0, HARDWARE_KEYBOARD_KEY_RETURN)
/**
 * Keyboard test for W
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_W             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_1, HARDWARE_KEYBOARD_KEY_W)
/**
 * Keyboard test for R
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_R             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_2, HARDWARE_KEYBOARD_KEY_R)
/**
 * Keyboard test for Y
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_y             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_3, HARDWARE_KEYBOARD_KEY_y)
/**
 * Keyboard test for I
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_I             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_4, HARDWARE_KEYBOARD_KEY_I)
/**
 * Keyboard test for P
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_P             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_5, HARDWARE_KEYBOARD_KEY_P)
/**
 * Keyboard test for *
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_ASTERISK      = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_6, HARDWARE_KEYBOARD_KEY_ASTERISK)
/**
 * Keyboard test for Home
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_HOME          = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_7, HARDWARE_KEYBOARD_KEY_HOME)

/**
 * Keyboard test for Delete
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_DELETE        = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_0, HARDWARE_KEYBOARD_KEY_DELETE)
/**
 * Keyboard test for 3
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_3             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_1, HARDWARE_KEYBOARD_KEY_3)
/**
 * Keyboard test for 5
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_5             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_2, HARDWARE_KEYBOARD_KEY_5)
/**
 * Keyboard test for 7
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_7             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_3, HARDWARE_KEYBOARD_KEY_7)
/**
 * Keyboard test for 9
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_9             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_4, HARDWARE_KEYBOARD_KEY_9)
/**
 * Keyboard test for Cursor down
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_CURSOR_DOWN   = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_5, HARDWARE_KEYBOARD_KEY_CURSOR_DOWN)
/**
 * Keyboard test for Cursor left
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_CURSOR_LEFT   = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_6, HARDWARE_KEYBOARD_KEY_CURSOR_LEFT)
/**
 * Keyboard test for 1
 **/
.var HARDWARE_KEYBOARD_TEST_KEY_1             = Hardware_Keyboard_KeyTest(HARDWARE_KEYBOARD_SELECT_ROW_7, HARDWARE_KEYBOARD_KEY_1)
