//--------------------- Internal logging-related functions

#importonce

//*** Internal verbose logging
//*** Log message will be printed only when P4_INCLUDES_VERBOSE_LOGGING define is present.
//*** Input:
//***   message - message to print to compiler log.
.function Internal_P4_LogVerbose(message) {
    #if P4_INCLUDES_VERBOSE_LOGGING
        .print message
    #endif
}