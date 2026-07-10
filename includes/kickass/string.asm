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

/**
 * Convert ASCII string to PETSCII.
 * Only alphanumeric and punctuation characters are supported.
 *
 * @param str ASCII string to convert.
 * @return PETSCII string bytes in a list.
 **/
.function Kickass_String_AsciiStringToPetscii(str) {
    .var result = List()
    .for(var i = 0; i < str.size(); i++) {
        .eval result.add(Kickass_String_AsciiToPetscii(str.charAt(i)))
    }
    .return result
}

/**
 * Convert ASCII character to PETSCII.
 * Only alphanumeric and punctuation characters are supported.
 *
 * @param chr ASCII character to convert.
 * @return PETSCII character byte.
 **/
.function Kickass_String_AsciiToPetscii(chr) {
    .if ((chr >= 'a') && (chr <= 'z')) {
        .return chr + $20
    }

    .return chr
}

/**
 * Convert an escaped string to PETSCII string, replace special escape sequences with their character code.
 *
 * Escaped PETSCII characters are:
 * `\[` - bracket `[`, to be able to print it without interpreting it as escaped character (PETSCII: $1B)
 * `[home]` - move cursor to home (PETSCII: $13)
 * `[clr]` - clear screen and move cursor home (PETSCII: $93)
 * `[esc]` - escape (PETSCII: $9B)
 * `[return]` - return (PETSCII: $8D)
 * `[delete]` - delete one character back (PETSCII: $94)
 * `[lower]` - switch to lowercase characters (PETSCII: $8E)
 * `[upper]` - switch to uppercase characters (PETSCII: $CE)
 * `[up]` - move cursor up (PETSCII: $D1)
 * `[down]` - move cursor down (PETSCII: $91)
 * `[left]` - move cursor left (PETSCII: $DD)
 * `[right]` - move cursor right (PETSCII: $9D)
 * `[reverse on]` - turn reverse mode on (PETSCII: $92)
 * `[reverse off]` - turn reverse mode off (PETSCII: $D2)
 * `[pound]` - pound character (PETSCII: $1C)
 * `[pi]` - PI character (PETSCII: $FF)
 * `[sh space]` - SHIFT+SPACE character - solid space (PETSCII: $A0)
 * `[red]` - red colour (PETSCII: $1C)
 * `[green]` - green colour (PETSCII: $1E)
 * `[blue]` - blue colour (PETSCII: $1F)
 * `[orange]` - orange colour (PETSCII: $81)
 * `[black]` - black colour (PETSCII: $90)
 * `[brown]` - brown colour (PETSCII: $95)
 * `[pink]` - pink colour (PETSCII: $96)
 * `[dark gray]` - dark gray colour (PETSCII: $97)
 * `[gray]` - gray colour (PETSCII: $98)
 * `[light green]` - light green colour (PETSCII: $99)
 * `[light blue]` - light blue colour (PETSCII: $9A)
 * `[light gray]` - light gray colour (PETSCII: $9B)
 * `[purple]` - purple colour (PETSCII: $9C)
 * `[yellow]` - yellow colour (PETSCII: $9E)
 * `[cyan]` - cyan colour (PETSCII: $9F)
 * `[white]` - white colour (PETSCII: $05)
 *
 * Note: make sure text encoding for KickAssembler is set to ASCII using
 * one of these directives: `.encoding "petscii_mixed"` or `.encoding "petscii_uppercase"`.
 *
 * @param text static text to convert.
 * @return PETSCII text as string.
 **/
.function Kickass_String_CovertToPetscii(text) {
    .var escapedText = ""
    .var escapeMode = false
    .var escape = ""
    .var escaped = ""
    .var escapes = List().add(
        "home",         @"\$13",
        "clr",          @"\$93",
        "esc",          @"\$1B",
        "return",       @"\$0D",
        "delete",       @"\$14",
        "lower",        @"\$0E",
        "upper",        @"\$8E",
        "up",           @"\$91",
        "down",         @"\$11",
        "left",         @"\$9D",
        "right",        @"\$1D",
        "reverse on",   @"\$12",
        "reverse off",  @"\$92",
        "pound",        @"\$5C",
        "pi",           @"\$FF",
        "sh space",     @"\$A0",
        "red",          @"\$1C",
        "green",        @"\$1E",
        "blue",         @"\$1F",
        "orange",       @"\$81",
        "black",        @"\$90",
        "brown",        @"\$95",
        "pink",         @"\$96",
        "dark gray",    @"\$97",
        "gray",         @"\$98",
        "light green",  @"\$99",
        "light blue",   @"\$9A",
        "light gray",   @"\$9B",
        "purple",       @"\$9C",
        "yellow",       @"\$9E",
        "cyan",         @"\$9F",
        "white",        @"\$05")

    .for(var i = 0; i < text.size(); i++) {
        .var char = text.charAt(i)
        .if (escapeMode) {
            //Escape mode is on
            .if (char == "]") {
                //Found closing bracket, finish escaped sequence
                .eval escaped = ""
                .for(var j = 0; j < escapes.size(); j += 2) {
                    .if (escapes.get(j) == escape) {
                        .eval escaped = escapes.get(j + 1)
                        .eval j = escapes.size()
                    }
                }
                .if (escaped == "") .error "Could not find escaped character: [" + escape + "]"
                .eval escapedText = escapedText + escaped
                .eval escapeMode = false
                .eval escape = ""
            } else {
                .eval escape = escape + char
            }
        } else {
            //Escape mode is off
            .if ((char == "\") && (i + 1 < text.size()) && (text.charAt(i + 1) == "[")) {
                //Escaped bracket found
                .eval escapedText = escapedText + "["
                //Skip next character
                .eval i = i + 1
            } else {
                .if (char == "[") {
                    //Found opening braket, turn escape mode on
                    .eval escapeMode = true
                } else {
                    //Just another character to the final text
                    .eval escapedText = escapedText + char
                }
            }
        }
    }

    .if (escapeMode) .error "Escaped sequence is not closed: [" + escape

    .return escapedText
}