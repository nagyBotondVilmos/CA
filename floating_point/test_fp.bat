@REM This batch file is used to compile and run the float program

@REM compile the float program
.\nasm.exe -f win32 .\float.asm
.\nlink.exe .\float.obj -lmio -o .\float.exe

cls

@REM run the float program
.\float.exe

@REM remove all object and executable files
del .\float.obj .\float.exe