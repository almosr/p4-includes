//--------------------- Internals for Std Lib/RLE compression
#importonce

.const INTERNAL_STD_LIB_COMPRESSION_RLE_CONTROL_STOP = $80
.const INTERNAL_STD_LIB_COMPRESSION_RLE_CONTROL_REPEAT = $80     //Length will be added to it
.const INTERNAL_STD_LIB_COMPRESSION_RLE_CONTROL_COPY = $00       //Length will be added to it
.const INTERNAL_STD_LIB_COMPRESSION_RLE_MAX_LENGTH = $80         //Maximum length that can be stored in one chunk

