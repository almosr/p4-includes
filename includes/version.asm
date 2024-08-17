/**
 * @file version.asm
 *
 * P4 Includes project version.
 **/

#importonce

#import "kickass/string.asm"

/**
 * Current version of P4 Includes.
 **/
.const P4_INCLUDES_VERSION = "0.1.0"
.const P4_INCLUDES_VERSION_MAJOR = 0
.const P4_INCLUDES_VERSION_MINOR = 1
.const P4_INCLUDES_VERSION_PATCH = 0

/**
 * Check for minimum version of P4 includes.
 *
 * When minimum version is not met then stops compiling with a specific error.
 *
 * @param version required minimum version as string.
 **/
.function P4Includes_Version_AtLest(version) {
    .var split = Kickass_String_Split(version, '.')
    .var parts = List()
    .if (split.size() != 3) .error "Invalid version string, must consists of three parts delimited by dot (.), actual: " + version
    .for(var i = 0; i < 3; i++) {
        .var part = split.get(i)
        .if (!Kickass_String_IsNumber(part) || part.size() == 0) .error "Invalid version string, must consist of digits and dot (.) only, actual: " + version
        .eval parts.add(part.asNumber())
    }

    .var inputMajor = parts.get(0)
    .var inputMinor = parts.get(1)
    .var inputPatch = parts.get(2)
    .if (P4_INCLUDES_VERSION_MAJOR > inputMajor) {
        .return true
    } else {
        .if (P4_INCLUDES_VERSION_MAJOR == inputMajor) {
            .if (P4_INCLUDES_VERSION_MINOR > inputMinor) {
                .return true
            } else {
                .if (P4_INCLUDES_VERSION_MINOR == inputMinor) {
                    .if (P4_INCLUDES_VERSION_PATCH >= inputPatch) {
                        .return true
                    }
                }
            }
        }
    }

    .error "P4 Includes required minimum version is not met, required at least: " + version + ", actual: " + P4_INCLUDES_VERSION
}

/**
 * Check for exact version of P4 includes.
 *
 * When exact version is not met then stops compiling with a specific error.
 *
 * @param version required exact version as string.
 **/
.function P4Includes_Version_Exactly(version) {
    .if (P4_INCLUDES_VERSION != version) .error "P4 Includes required version is not met, required: " + version + ", actual: " + P4_INCLUDES_VERSION
}


/**
 * Check provided version and compare it to the actual version regarding compatibility.
 *
 * Note: this function is useful for checking backward compatibility of a newer release only.
 *       When a newer version is specified compared to the current version then it returns
 *       `false` because it does not know anything about a later release.
 *
 * @param version target version as a string.
 * @return `true` when specified version is compatible with the current version, `false` otherwise.
 **/
.function P4Includes_Version_IsCompatible(version) {
    .if (version == P4_INCLUDES_VERSION) {
        //Current version is compatible with itself (of course).
        .return true
    } else {
        .print "WARNING: unknown version '" + version +"', unable to check compatibility."
        .return false
    }
}

/**
 * Print current version of P4 includes to compiler log.
 **/
.function P4Includes_Version_Print() {
    .print "P4 Includes version: " + P4_INCLUDES_VERSION
}
