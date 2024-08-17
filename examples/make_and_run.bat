del out\*.* /Q

call kickass -showmem -libdir ../includes/ -define P4_INCLUDES_VERBOSE_LOGGING std_lib/sample_compression_rle.asm -o out\compression_rle_g1010.prg
IF %ERRORLEVEL% NEQ 0 (
   EXIT /B 
)

yape .\out\compression_rle_g1010.prg

call kickass -showmem -libdir ../includes/ -define P4_INCLUDES_VERBOSE_LOGGING gfx/sample_frame_animation.asm -o out\frame_animation_g1010.prg
IF %ERRORLEVEL% NEQ 0 (
   EXIT /B
)

yape .\out\frame_animation_g1010.prg

call kickass -showmem -libdir ../includes/ -define P4_INCLUDES_VERBOSE_LOGGING gfx/sample_interpolation.asm -o out\sample_interpolation_g1010.prg
IF %ERRORLEVEL% NEQ 0 (
   EXIT /B
)

yape .\out\sample_interpolation_g1010.prg
