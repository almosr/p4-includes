/**
 * @file string.asm
 *
 * String-related macros and functions.
 **/

#importonce

#import "internal/kickass/string.asm"

/**
 * Split a string into a list of strings by a delimiter character.
 *
 * @param input string to split.
 * @param delimiter delimiter character to split by.
 **/
.function Kickass_String_Split(input, delimiter) {
    .if (delimiter.size() != 1) .error "Delimiter must be exactly one character long, actual: " + delimiter

    .var result = List()
    .var segment = ""
    .for(var i = 0; i < input.size(); i++) {
        .var current = input.charAt(i)
        .if (current == delimiter) {
            .eval result.add(segment)
            .eval segment = ""
        } else {
            .eval segment = segment + current
        }
    }

    .eval result.add(segment)

    .return result
}

/**
 * Checks all characters in a string whether it is a digit or not.
 *
 * @param input string to check.
 * @return `true` when all characters are digits or the string is empty, `false` otherwise.
 **/
.function Kickass_String_IsNumber(input) {
    .for(var i = 0; i < input.size(); i++) {
        .var char = input.charAt(i)
        .if (!INTERNAL_KICKASS_STRING_DIGITS.containsKey(char)) {
            .return false
        }
    }

    .return true
}