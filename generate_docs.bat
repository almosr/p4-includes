rmdir ..\output /s /q

python ..\KickAssemblerToDoxygen\KickAssemblerToDoxygen.py .

doxygen Doxyfile
