;Nev: Nagy Botond-Vilmos
;Csoport: 513/2
;Feladat: L4 - Modulok

%include 'mio.inc'
%include 'ionum.inc'
%include 'iostr.inc'

global main

section .text
sum_32:
    mov     eax, [elso_32]
    mov     ebx, [masodik_32]
    add     eax, ebx
    mov     ebx, [harmadik_32]
    add     eax, ebx
    ret

sum_64:
    mov     eax, [elso_64_a]
    mov     edx, [elso_64_d]
    mov     ebx, [masodik_64_a]
    mov     ecx, [masodik_64_d]
    clc
    add     eax, ebx
    adc     edx, ecx
    mov     ebx, [harmadik_64_a]
    mov     ecx, [harmadik_64_d]
    clc
    add     eax, ebx
    adc     edx, ecx
    ret

main:
    .elso_32:
        mov     esi, str_be_32_int
        call    WriteStr
        call    ReadInt
        jc      .hiba_32_1
        mov     [elso_32], eax

        call    mio_writeln

        mov     esi, str_ki_int
        call    WriteStr
        mov     eax, [elso_32]
        call    WriteInt

        call    mio_writeln

        mov     esi, str_ki_hex
        call    WriteStr
        mov     eax, [elso_32]
        call    WriteHex

        call    mio_writeln

        mov     esi, str_ki_bin
        call    WriteStr
        mov     eax, [elso_32]
        call    WriteBin

        call    mio_writeln
    
    .masodik_32:
        mov     esi, str_be_32_hex
        call    WriteStr
        call    ReadHex
        jc      .hiba_32_2
        mov     [masodik_32], eax

        call    mio_writeln

        mov     esi, str_ki_int
        call    WriteStr
        mov     eax, [masodik_32]
        call    WriteInt

        call    mio_writeln

        mov     esi, str_ki_hex
        call    WriteStr
        mov     eax, [masodik_32]
        call    WriteHex

        call    mio_writeln

        mov     esi, str_ki_bin
        call    WriteStr
        mov     eax, [masodik_32]
        call    WriteBin

        call    mio_writeln

    .harmadik_32:
        mov     esi, str_be_32_bin
        call    WriteStr
        call    ReadBin
        jc      .hiba_32_3
        mov     [harmadik_32], eax

        call    mio_writeln

        mov     esi, str_ki_int
        call    WriteStr
        mov     eax, [harmadik_32]
        call    WriteInt

        call    mio_writeln

        mov     esi, str_ki_hex
        call    WriteStr
        mov     eax, [harmadik_32]
        call    WriteHex

        call    mio_writeln

        mov     esi, str_ki_bin
        call    WriteStr
        mov     eax, [harmadik_32]
        call    WriteBin

        call    mio_writeln

    .osszeg_32:
        call    sum_32
        
        mov     esi, str_ki_sum_int
        call    WriteStr
        call    WriteInt

        call    mio_writeln

        mov     esi, str_ki_sum_hex
        call    WriteStr
        call    WriteHex

        call    mio_writeln

        mov     esi, str_ki_sum_bin
        call    WriteStr
        call    WriteBin

        call    mio_writeln



    .64bit:
    .elso_64:
        mov     esi, str_be_64_int
        call    WriteStr
        call    ReadInt64
        jc      .hiba_64_1
        mov     [elso_64_a], eax
        mov     [elso_64_d], edx

        call    mio_writeln

        mov     esi, str_ki_int
        call    WriteStr
        mov     eax, [elso_64_a]
        mov     edx, [elso_64_d]
        call    WriteInt64

        call    mio_writeln

        mov     esi, str_ki_hex
        call    WriteStr
        mov     eax, [elso_64_a]
        mov     edx, [elso_64_d]
        call    WriteHex64

        call    mio_writeln

        mov     esi, str_ki_bin
        call    WriteStr
        mov     eax, [elso_64_a]
        mov     edx, [elso_64_d]
        call    WriteBin64

        call    mio_writeln

    .masodik_64:
        mov     esi, str_be_64_hex
        call    WriteStr
        call    ReadHex64
        jc      .hiba_64_2
        mov     [masodik_64_a], eax
        mov     [masodik_64_d], edx

        call    mio_writeln

        mov     esi, str_ki_int
        call    WriteStr
        mov     [masodik_64_a], eax
        mov     [masodik_64_d], edx
        call    WriteInt64

        call    mio_writeln

        mov     esi, str_ki_hex
        call    WriteStr
        mov     [masodik_64_a], eax
        mov     [masodik_64_d], edx
        call    WriteHex64

        call    mio_writeln

        mov     esi, str_ki_bin
        call    WriteStr
        mov     [masodik_64_a], eax
        mov     [masodik_64_d], edx
        call    WriteBin64

        call    mio_writeln

    .harmadik_64:
        mov     esi, str_be_64_bin
        call    WriteStr
        call    ReadBin64
        jc      .hiba_64_3
        mov     [harmadik_64_a], eax
        mov     [harmadik_64_d], edx

        call    mio_writeln

        mov     esi, str_ki_int
        call    WriteStr
        mov     [harmadik_64_a], eax
        mov     [harmadik_64_d], edx
        call    WriteInt64

        call    mio_writeln

        mov     esi, str_ki_hex
        call    WriteStr
        mov     [harmadik_64_a], eax
        mov     [harmadik_64_d], edx
        call    WriteHex64

        call    mio_writeln

        mov     esi, str_ki_bin
        call    WriteStr
        mov     [harmadik_64_a], eax
        mov     [harmadik_64_d], edx
        call    WriteBin64

        call    mio_writeln
    
    .osszeg_64:
        call    sum_64

        mov     esi, str_ki_sum_int
        call    WriteStr
        call    WriteInt64

        call    mio_writeln

        mov     esi, str_ki_sum_hex
        call    WriteStr
        call    WriteHex64

        call    mio_writeln

        mov     esi, str_ki_sum_bin
        call    WriteStr
        call    WriteBin64

        call    mio_writeln



    jmp     .vege



    .hiba_32_1:
        call    mio_writeln
        mov     esi, str_hiba
        call    WriteStr
        call    mio_writeln
        jmp     .elso_32
    
    .hiba_32_2:
        call    mio_writeln
        mov     esi, str_hiba
        call    WriteStr
        call    mio_writeln
        jmp     .masodik_32
    
    .hiba_32_3:
        call    mio_writeln
        mov     esi, str_hiba
        call    WriteStr
        call    mio_writeln
        jmp     .harmadik_32
    .hiba_64_1:
        call    mio_writeln
        mov     esi, str_hiba
        call    WriteStr
        call    mio_writeln
        jmp     .elso_64
    
    .hiba_64_2:
        call    mio_writeln
        mov     esi, str_hiba
        call    WriteStr
        call    mio_writeln
        jmp     .masodik_64
    
    .hiba_64_3:
        call    mio_writeln
        mov     esi, str_hiba
        call    WriteStr
        call    mio_writeln
        jmp     .harmadik_64
    
    .vege:
    ret

section .data
    str_hiba            dd      "Hiba: ervenytelen bemenet! Irja be ujra a szamot", 0
    str_be_32_int       dd      "Irja be a 32 bites decimalis szamot: ", 0
    str_be_32_hex       dd      "Irja be a 32 bites hexa szamot: ", 0
    str_be_32_bin       dd      "Irja be a 32 bites binaris szamot: ", 0
    str_be_64_int       dd      "Irja be a 64 bites decimalis szamot: ", 0
    str_be_64_hex       dd      "Irja be a 64 bites hexa szamot: ", 0
    str_be_64_bin       dd      "Irja be a 64 bites binaris szamot: ", 0
    str_ki_int          dd      "A szam decimalis alakban: ", 0
    str_ki_hex          dd      "A szam hexa alakban: ", 0
    str_ki_bin          dd      "A szam binaris alakban: ", 0
    str_ki_sum_int      dd      "A harom szam osszege decimalis alakban: ", 0
    str_ki_sum_hex      dd      "A harom szam osszege hexa alakban: ", 0
    str_ki_sum_bin      dd      "A harom szam osszege binaris alakban: ", 0

section .bss
    elso_32             resd    256
    masodik_32          resd    256
    harmadik_32         resd    256
    elso_64_a           resd    256
    elso_64_d           resd    256
    masodik_64_a        resd    256
    masodik_64_d        resd    256
    harmadik_64_a       resd    256
    harmadik_64_d       resd    256