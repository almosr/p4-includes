/**
 * @file functions.asm
 *
 * Kickass function and macro-related helpers.
 **/

#importonce

/**
 * Validate an integer or float argument for a function or macro call.
 * Argument is validated against the specified numeric range.
 * When the value is outside of the range then compiling stops
 * with a descriptive error.
 *
 * @param name name of the argument.
 * @param value value of the argument.
 * @param minimum minimum expected value of the argument.
 * @param maximum maximum expected value of the argument.
 **/
.function Kickass_Functions_CheckRange(name, value, minimum, maximum) {
    .if (value < minimum || value > maximum) .error "Argument '" + name + "' is out of bounds, expected: [" + minimum + " .. " + maximum + "], actual: " + value
}

/**
 * Validate a list of integer or float arguments for a function or macro call.
 * Arguments are validated against their specified numeric range.
 * When the value is outside of the range then compiling stops
 * with a descriptive error.
 *
 * @param arguments list of arguments to validate, each argument must be
 *        specified with these items in the list:
 *        - name of the argument;
 *        - value of the argument;
 *        - minimum expected value of the argument;
 *        - maximum expected value of the argument.
 **/
.function Kickass_Functions_CheckRanges(arguments) {
    .if (mod(arguments.size(), 4) != 0) .error "Argument list must consist of name, value, minimum, maximum, actual: " + arguments

   .for(var i = 0; i < arguments.size(); i += 4) {
        .eval Kickass_Functions_CheckRange(arguments.get(i), arguments.get(i + 1), arguments.get(i + 2), arguments.get(i + 3))
   }
}

/**
 * Validate an integer or float argument for a function or macro call.
 * Argument is validated against a specific minimum value.
 * When the value is less than the specified minimum then compiling
 * stops with a descriptive error.
 *
 * @param name name of the argument.
 * @param value value of the argument.
 * @param minimum minimum expected value of the argument.
 **/
.function Kickass_Functions_CheckMinimum(name, value, minimum) {
    .if (value < minimum) .error "Argument '" + name + "' is less than expected: " + minimum + ", actual: " + value
}

/**
 * Validate an integer or float argument for a function or macro call.
 * Argument is validated against a specific maximum value.
 * When the value is more than the specified minimum then compiling
 * stops with a descriptive error.
 *
 * @param name name of the argument.
 * @param value value of the argument.
 * @param maximum maximum expected value of the argument.
 **/
.function Kickass_Functions_CheckMaximum(name, value, maximum) {
    .if (value > maximum) .error "Argument '" + name + "' is more than expected: " + maximum + ", actual: " + value
}