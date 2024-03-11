@REM This batch file is used to compile and run the iopelda program

@REM compile the iopelda program
.\nasm.exe -f win32 .\ionum.asm
.\nasm.exe -f win32 .\iostr.asm
.\nasm.exe -f win32 .\iopelda.asm
.\nlink.exe .\iopelda.obj .\iostr.obj .\ionum.obj -lmio -o .\iopelda.exe

cls

@REM run the iopelda program
.\iopelda.exe

@REM remove all object and executable files
del .\iopelda.obj .\iostr.obj .\ionum.obj .\iopelda.exe