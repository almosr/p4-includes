/**
 * @file characters.asm
 *
 * Screen character code definitions.
 * Note: graphic and repeated characters are not listed.
 **/

#importonce

.const HARDWARE_CHARACTER_AT                    = 0
.const HARDWARE_CHARACTER_UPPERCASE_A           = 1
.const HARDWARE_CHARACTER_UPPERCASE_B           = 2
.const HARDWARE_CHARACTER_UPPERCASE_C           = 3
.const HARDWARE_CHARACTER_UPPERCASE_D           = 4
.const HARDWARE_CHARACTER_UPPERCASE_E           = 5
.const HARDWARE_CHARACTER_UPPERCASE_F           = 6
.const HARDWARE_CHARACTER_UPPERCASE_G           = 7
.const HARDWARE_CHARACTER_UPPERCASE_H           = 8
.const HARDWARE_CHARACTER_UPPERCASE_I           = 9
.const HARDWARE_CHARACTER_UPPERCASE_J           = 10
.const HARDWARE_CHARACTER_UPPERCASE_K           = 11
.const HARDWARE_CHARACTER_UPPERCASE_L           = 12
.const HARDWARE_CHARACTER_UPPERCASE_M           = 13
.const HARDWARE_CHARACTER_UPPERCASE_N           = 14
.const HARDWARE_CHARACTER_UPPERCASE_O           = 15
.const HARDWARE_CHARACTER_UPPERCASE_P           = 16
.const HARDWARE_CHARACTER_UPPERCASE_Q           = 17
.const HARDWARE_CHARACTER_UPPERCASE_R           = 18
.const HARDWARE_CHARACTER_UPPERCASE_S           = 19
.const HARDWARE_CHARACTER_UPPERCASE_T           = 20
.const HARDWARE_CHARACTER_UPPERCASE_U           = 21
.const HARDWARE_CHARACTER_UPPERCASE_V           = 22
.const HARDWARE_CHARACTER_UPPERCASE_W           = 23
.const HARDWARE_CHARACTER_UPPERCASE_X           = 24
.const HARDWARE_CHARACTER_UPPERCASE_Y           = 25
.const HARDWARE_CHARACTER_UPPERCASE_Z           = 26
.const HARDWARE_CHARACTER_SQUARE_BRAKET_OPEN    = 27
.const HARDWARE_CHARACTER_POUND                 = 28
.const HARDWARE_CHARACTER_SQUARE_BRAKET_CLOSE   = 29
.const HARDWARE_CHARACTER_ARROW_UP              = 30
.const HARDWARE_CHARACTER_ARROW_LEFT            = 31
.const HARDWARE_CHARACTER_SPACE                 = 32
.const HARDWARE_CHARACTER_EXCLAMATION_MARK      = 33
.const HARDWARE_CHARACTER_DOUBLE_QUOTES         = 34
.const HARDWARE_CHARACTER_HASH                  = 35
.const HARDWARE_CHARACTER_DOLLAR                = 36
.const HARDWARE_CHARACTER_PERCENTAGE            = 37
.const HARDWARE_CHARACTER_AMPERSAND             = 38
.const HARDWARE_CHARACTER_APOSTROPHE            = 39
.const HARDWARE_CHARACTER_CURLY_BRAKET_OPEN     = 40
.const HARDWARE_CHARACTER_CURLY_BRAKET_CLOSE    = 41
.const HARDWARE_CHARACTER_ASTERISK              = 42
.const HARDWARE_CHARACTER_PLUS                  = 43
.const HARDWARE_CHARACTER_COMMA                 = 44
.const HARDWARE_CHARACTER_MINUS                 = 45
.const HARDWARE_CHARACTER_DOT                   = 46
.const HARDWARE_CHARACTER_FORWARD_SLASH         = 47
.const HARDWARE_CHARACTER_NUMBER_0              = 48
.const HARDWARE_CHARACTER_NUMBER_1              = 49
.const HARDWARE_CHARACTER_NUMBER_2              = 50
.const HARDWARE_CHARACTER_NUMBER_3              = 51
.const HARDWARE_CHARACTER_NUMBER_4              = 52
.const HARDWARE_CHARACTER_NUMBER_5              = 53
.const HARDWARE_CHARACTER_NUMBER_6              = 54
.const HARDWARE_CHARACTER_NUMBER_7              = 55
.const HARDWARE_CHARACTER_NUMBER_8              = 56
.const HARDWARE_CHARACTER_NUMBER_9              = 57
.const HARDWARE_CHARACTER_COLON                 = 58
.const HARDWARE_CHARACTER_SEMICOLON             = 59
.const HARDWARE_CHARACTER_LESS_THAN             = 60
.const HARDWARE_CHARACTER_EQUALS                = 61
.const HARDWARE_CHARACTER_MORE_THAN             = 62
.const HARDWARE_CHARACTER_QUESTION_MARK         = 63
//...
.const HARDWARE_CHARACTER_PI                    = 94
//...
.const HARDWARE_CHARACTER_LOWERCASE_A           = 129
.const HARDWARE_CHARACTER_LOWERCASE_B           = 130
.const HARDWARE_CHARACTER_LOWERCASE_C           = 131
.const HARDWARE_CHARACTER_LOWERCASE_D           = 132
.const HARDWARE_CHARACTER_LOWERCASE_E           = 133
.const HARDWARE_CHARACTER_LOWERCASE_F           = 134
.const HARDWARE_CHARACTER_LOWERCASE_G           = 135
.const HARDWARE_CHARACTER_LOWERCASE_H           = 136
.const HARDWARE_CHARACTER_LOWERCASE_I           = 137
.const HARDWARE_CHARACTER_LOWERCASE_J           = 138
.const HARDWARE_CHARACTER_LOWERCASE_K           = 139
.const HARDWARE_CHARACTER_LOWERCASE_L           = 140
.const HARDWARE_CHARACTER_LOWERCASE_M           = 141
.const HARDWARE_CHARACTER_LOWERCASE_N           = 142
.const HARDWARE_CHARACTER_LOWERCASE_O           = 143
.const HARDWARE_CHARACTER_LOWERCASE_P           = 144
.const HARDWARE_CHARACTER_LOWERCASE_Q           = 145
.const HARDWARE_CHARACTER_LOWERCASE_R           = 146
.const HARDWARE_CHARACTER_LOWERCASE_S           = 147
.const HARDWARE_CHARACTER_LOWERCASE_T           = 148
.const HARDWARE_CHARACTER_LOWERCASE_U           = 149
.const HARDWARE_CHARACTER_LOWERCASE_V           = 150
.const HARDWARE_CHARACTER_LOWERCASE_W           = 151
.const HARDWARE_CHARACTER_LOWERCASE_X           = 152
.const HARDWARE_CHARACTER_LOWERCASE_Y           = 153
.const HARDWARE_CHARACTER_LOWERCASE_Z           = 154
//...
.const HARDWARE_CHARACTER_TICK                  = 250

//When P4_INCLUDES_CHARACTER_STRUCTURE is defined then create a character set namespace with shorter names for convenience
#if P4_INCLUDES_CHARACTER_STRUCTURE
    /**
     * Namespace for accessing characters conveniently.
     **/
    .namespace Chars {
        .label At                   = HARDWARE_CHARACTER_AT
        .label UpperA               = HARDWARE_CHARACTER_UPPERCASE_A
        .label UpperB               = HARDWARE_CHARACTER_UPPERCASE_B
        .label UpperC               = HARDWARE_CHARACTER_UPPERCASE_C
        .label UpperD               = HARDWARE_CHARACTER_UPPERCASE_D
        .label UpperE               = HARDWARE_CHARACTER_UPPERCASE_E
        .label UpperF               = HARDWARE_CHARACTER_UPPERCASE_F
        .label UpperG               = HARDWARE_CHARACTER_UPPERCASE_G
        .label UpperH               = HARDWARE_CHARACTER_UPPERCASE_H
        .label UpperI               = HARDWARE_CHARACTER_UPPERCASE_I
        .label UpperJ               = HARDWARE_CHARACTER_UPPERCASE_J
        .label UpperK               = HARDWARE_CHARACTER_UPPERCASE_K
        .label UpperL               = HARDWARE_CHARACTER_UPPERCASE_L
        .label UpperM               = HARDWARE_CHARACTER_UPPERCASE_M
        .label UpperN               = HARDWARE_CHARACTER_UPPERCASE_N
        .label UpperO               = HARDWARE_CHARACTER_UPPERCASE_O
        .label UpperP               = HARDWARE_CHARACTER_UPPERCASE_P
        .label UpperQ               = HARDWARE_CHARACTER_UPPERCASE_Q
        .label UpperR               = HARDWARE_CHARACTER_UPPERCASE_R
        .label UpperS               = HARDWARE_CHARACTER_UPPERCASE_S
        .label UpperT               = HARDWARE_CHARACTER_UPPERCASE_T
        .label UpperU               = HARDWARE_CHARACTER_UPPERCASE_U
        .label UpperV               = HARDWARE_CHARACTER_UPPERCASE_V
        .label UpperW               = HARDWARE_CHARACTER_UPPERCASE_W
        .label UpperX               = HARDWARE_CHARACTER_UPPERCASE_X
        .label UpperY               = HARDWARE_CHARACTER_UPPERCASE_Y
        .label UpperZ               = HARDWARE_CHARACTER_UPPERCASE_Z
        .label SquareBraketOpen     = HARDWARE_CHARACTER_SQUARE_BRAKET_OPEN
        .label Pound                = HARDWARE_CHARACTER_POUND
        .label SquareBraketClose    = HARDWARE_CHARACTER_SQUARE_BRAKET_CLOSE
        .label ArrowUp              = HARDWARE_CHARACTER_ARROW_UP
        .label ArrowLeft            = HARDWARE_CHARACTER_ARROW_LEFT
        .label Space                = HARDWARE_CHARACTER_SPACE
        .label ExclamationMark      = HARDWARE_CHARACTER_EXCLAMATION_MARK
        .label DoubleQuotes         = HARDWARE_CHARACTER_DOUBLE_QUOTES
        .label Hash                 = HARDWARE_CHARACTER_HASH
        .label Dollar               = HARDWARE_CHARACTER_DOLLAR
        .label Percentage           = HARDWARE_CHARACTER_PERCENTAGE
        .label Ampersand            = HARDWARE_CHARACTER_AMPERSAND
        .label Apostrophe           = HARDWARE_CHARACTER_APOSTROPHE
        .label CurlyBraketOpen      = HARDWARE_CHARACTER_CURLY_BRAKET_OPEN
        .label CurlyBraketClose     = HARDWARE_CHARACTER_CURLY_BRAKET_CLOSE
        .label Asterisk             = HARDWARE_CHARACTER_ASTERISK
        .label Plus                 = HARDWARE_CHARACTER_PLUS
        .label Comma                = HARDWARE_CHARACTER_COMMA
        .label Minus                = HARDWARE_CHARACTER_MINUS
        .label Dot                  = HARDWARE_CHARACTER_DOT
        .label ForwardSlash         = HARDWARE_CHARACTER_FORWARD_SLASH
        .label Num0                 = HARDWARE_CHARACTER_NUMBER_0
        .label Num1                 = HARDWARE_CHARACTER_NUMBER_1
        .label Num2                 = HARDWARE_CHARACTER_NUMBER_2
        .label Num3                 = HARDWARE_CHARACTER_NUMBER_3
        .label Num4                 = HARDWARE_CHARACTER_NUMBER_4
        .label Num5                 = HARDWARE_CHARACTER_NUMBER_5
        .label Num6                 = HARDWARE_CHARACTER_NUMBER_6
        .label Num7                 = HARDWARE_CHARACTER_NUMBER_7
        .label Num8                 = HARDWARE_CHARACTER_NUMBER_8
        .label Num9                 = HARDWARE_CHARACTER_NUMBER_9
        .label Colon                = HARDWARE_CHARACTER_COLON
        .label Semicolon            = HARDWARE_CHARACTER_SEMICOLON
        .label LessThan             = HARDWARE_CHARACTER_LESS_THAN
        .label Equals               = HARDWARE_CHARACTER_EQUALS
        .label MoreThan             = HARDWARE_CHARACTER_MORE_THAN
        .label QuestionMark         = HARDWARE_CHARACTER_QUESTION_MARK
        .label Pi                   = HARDWARE_CHARACTER_PI
        .label LowerA               = HARDWARE_CHARACTER_LOWERCASE_A
        .label LowerB               = HARDWARE_CHARACTER_LOWERCASE_B
        .label LowerC               = HARDWARE_CHARACTER_LOWERCASE_C
        .label LowerD               = HARDWARE_CHARACTER_LOWERCASE_D
        .label LowerE               = HARDWARE_CHARACTER_LOWERCASE_E
        .label LowerF               = HARDWARE_CHARACTER_LOWERCASE_F
        .label LowerG               = HARDWARE_CHARACTER_LOWERCASE_G
        .label LowerH               = HARDWARE_CHARACTER_LOWERCASE_H
        .label LowerI               = HARDWARE_CHARACTER_LOWERCASE_I
        .label LowerJ               = HARDWARE_CHARACTER_LOWERCASE_J
        .label LowerK               = HARDWARE_CHARACTER_LOWERCASE_K
        .label LowerL               = HARDWARE_CHARACTER_LOWERCASE_L
        .label LowerM               = HARDWARE_CHARACTER_LOWERCASE_M
        .label LowerN               = HARDWARE_CHARACTER_LOWERCASE_N
        .label LowerO               = HARDWARE_CHARACTER_LOWERCASE_O
        .label LowerP               = HARDWARE_CHARACTER_LOWERCASE_P
        .label LowerQ               = HARDWARE_CHARACTER_LOWERCASE_Q
        .label LowerR               = HARDWARE_CHARACTER_LOWERCASE_R
        .label LowerS               = HARDWARE_CHARACTER_LOWERCASE_S
        .label LowerT               = HARDWARE_CHARACTER_LOWERCASE_T
        .label LowerU               = HARDWARE_CHARACTER_LOWERCASE_U
        .label LowerV               = HARDWARE_CHARACTER_LOWERCASE_V
        .label LowerW               = HARDWARE_CHARACTER_LOWERCASE_W
        .label LowerX               = HARDWARE_CHARACTER_LOWERCASE_X
        .label LowerY               = HARDWARE_CHARACTER_LOWERCASE_Y
        .label LowerZ               = HARDWARE_CHARACTER_LOWERCASE_Z
        .label Tick                 = HARDWARE_CHARACTER_TICK
    }
#endif