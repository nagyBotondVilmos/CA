@REM This batch file is used to compile and run the strpelda program

@REM compile the strpelda program
.\nasm.exe -f win32 .\ionum.asm
.\nasm.exe -f win32 .\iostr.asm
.\nasm.exe -f win32 .\strings.asm
.\nasm.exe -f win32 .\strpelda.asm
.\nlink.exe .\strpelda.obj .\ionum.obj .\iostr.obj .\strings.obj -lmio -o .\strpelda.exe
cls

@REM run the strpelda program
.\strpelda.exe

@REM remove all object and executable files
del .\strpelda.obj .\ionum.obj .\iostr.obj .\strings.obj .\strpelda.exe