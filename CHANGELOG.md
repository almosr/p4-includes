# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - pending

### Added

- `kickass/list.asm`, `Kickass_List_DumpBytesToCode` and `Kickass_List_DumpWordsToCode` -
  new macros for dumping KickAssembler lists as bytes or words to the code
- `kickass/list.asm`, `Kickass_List_DumpWordsLowHighToCode` - new macro for dumping KickAssembler word list as low and
  high bytes to the code.
- `kickass/list.asm`, `Kickass_List_Find` - new function for finding a value in a KickAssembler list.
- `std_lib/binary.asm`, `StdLib_Binary_WordToPackedBCD` - new macro for converting word-sized integer to packed BCD.
- `std_lib/binary.asm`, `StdLib_Binary_Int16ToPackedBCD` - new function for converting word-sized integer to packed BCD.
- Introduced the concept of version tags for compatibility check, see constants `P4_INCLUDES_VERSION_TAG_*` in
  `version.asm`.
- `kickass/load_binary.asm`, `KICKASS_LOAD_BINARY_HIRES_P4I_TEMPLATE` - binary file definition for Botticelli Hi-Res
  P4I file format.
- `std_lib/memory.asm`, `StdLib_Memory_Fill_Blocks` - new macro for filling multiple 256 byte long memory blocks with
  the same value.
- `std_lib/memory.asm`, `StdLib_Memory_Fill_Unrolled` - new macro for filling memory with a specific value using
  unrolled store operations.
- `std_lib/memory.asm`, `StdLib_Memory_Copy_Unrolled` - new macro for copying memory using unrolled load/store
  operations.
- `std_lib/memory.asm`, `StdLib_Memory_Fill_Blocks_Register` - new macro for filling multiple 256 byte long memory
  blocks with
  the same value from A register.
- `std_lib/random.asm`, `StdLib_Random_Generate_Simple` and `StdLib_Random_Generate` - new macros for generating random
  number from a specific range.
- `std_lib/joystick.asm` and `hardware/joystick.asm` - various constants and macros for handling joysticks.

### Fixed

- Version checking function, previously failed to parse the version provided version string.
- `std_lib/keyboard.asm`, `StdLib_Keyboard_ReadKey` - keyboard latch was not set correctly when reading keys, so
  joysticks were read at the same time.

## [0.1.0] - 2024-08-17

Initial public release.