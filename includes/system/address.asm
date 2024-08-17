/**
 * @file address.asm
 *
 * Various system addresses.
 **/

#importonce

.const SYSTEM_ADDRESS_PRESSED_KEY                       = $C6
.const SYSTEM_ADDRESS_SOFT_IRQ_VECTOR                   = $0314
.const SYSTEM_ADDRESS_CHARACTER_SWITCH_ENABLED          = $0547
.label SYSTEM_ADDRESS_SCREEN_MEMORY_COLORS              = $0800
.label SYSTEM_ADDRESS_SCREEN_MEMORY_CHARACTERS          = $0C00
.const SYSTEM_ADDRESS_BASIC_START                       = $1001
.const SYSTEM_ADDRESS_GRAPHICS_MEMORY_LUMINANCE_MATRIX  = $1800
.const SYSTEM_ADDRESS_GRAPHICS_MEMORY_COLOR_MATRIX      = $1C00
.const SYSTEM_ADDRESS_GRAPHICS_MEMORY_BITMAP            = $2000
