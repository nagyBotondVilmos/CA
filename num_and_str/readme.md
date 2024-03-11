# Author
Nagy Botond-Vilmos

# Numbers and strings
This directory contains the implementation of most commonly used functions for numerbers and strings in x86 Assembly.

# Files
`ionum.asm`: integral number input/output procedures
- ReadInt():(EAX)         - 32 bit signed integer read
- WriteInt(EAX):()        - 32 bit signed integer write
- ReadInt64():(EDX:EAX)   - 64 bit signed integer read
- WriteInt64(EDX:EAX):()  - 64 bit signed integer write
- ReadBin():(EAX)         - 32 bit binary read (positive)
- WriteBin(EAX):()        - 32 bit binary write (positive)
- ReadBin64():(EDX:EAX)   - 64 bit binary read (positive)
- WriteBin64(EDX:EAX):()  - 64 bit binary write (positive)
- ReadHex():(EAX)         - 32 bit hexadecimal read (positive)
- WriteHex(EAX):()        - 32 bit hexadecimal write (positive)
- ReadHex64():(EDX:EAX)   - 64 bit hexadecimal read (positive)
- WriteHex64(EDX:EAX):()  - 64 bit hexadecimal write (positive)

Note: in the case of 64 bit integers, the high 32 bits are stored in EDX and the low 32 bits are stored in EAX.
    
`iostr.asm`: string input/output procedures
- ReadStr(ESI, ECX max length):()     - string read procedure (C style, read until enter)
- WriteStr(ESI):()                    - string write procedure
- ReadLnStr(ESI, ECX):()              - same as ReadStr() but also writes a new line
- WriteLnStr(ESI):()                  - same as WriteStr() but also writes a new line
- NewLine():()                        - writes a new line

Note: ESI is used as a pointer to the string and ECX is used as the maximum length of the string or the length of the string.
    
`strings.asm`: string operations
- StrLen(ESI):(EAX)           - returns the length of the string in pointed by ESI
- StrCat(EDI, ESI):()         - concatenates the strings pointed by ESI and EDI (result: EDI = EDI + ESI)
- StrUpper(ESI):()            - converts the string pointed by ESI to uppercase
- StrLower(ESI):()            - converts the string pointed by ESI to lowercase
- StrCompact(ESI, EDI):()     - copies the string pointed by ESI to EDI, excluding the following characters:
                                space (32), tab (9), carriage return (13), line feed (10)

# Testing
To test the procedures, you can use the `test_num.bat` and `test_str.bat` files for which I created 2 test cases for each procedure.
- numbers (`iopelda.asm`):
    - reads 3 32 bit integers and writes them in decimal, binary and hexadecimal
    - adds the 3 numbers and writes the result in decimal, binary and hexadecimal
    - reads 3 64 bit integers and writes them in decimal, binary and hexadecimal
    - adds the 3 numbers and writes the result in decimal, binary and hexadecimal
- strings (`strpelda.asm`):
    - reads a string and writes its length, compacted version, compacted version to lowercase
    - reads another string and writes its length, compacted version, compacted version to uppercase
    - creates a new string in memory formed by the concatenation of the first string to uppercase and the second string to lowercase
    - writes the new string and its length

# Final notes
- in order to be able to run the tests, you have to use Windows
- all files except which I mentioned are not mine, they are provided by the university