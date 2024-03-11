;Nev: Nagy Botond-Vilmos
;Csoport: 513/2
;Feladat: L4 - Modulok

%include 'mio.inc'
%include 'iostr.inc'
%include 'strings.inc'
%include 'ionum.inc'

global main

section .text
main:
    .elso:
        mov     esi, str_be_1
        call    WriteStr
        mov     ecx, 256
        mov     esi, elso
        call    ReadStr

        call    mio_writeln

        mov     esi, str_len
        call    WriteStr
        mov     esi, elso
        call    StrLen
        call    WriteInt

        call    mio_writeln

        mov     esi, str_ki_com
        call    WriteStr
        mov     esi, elso
        mov     edi, elso_com
        call    StrCompact
        mov     esi, edi
        call    WriteStr

        call    mio_writeln

        mov     esi, str_ki_com_k
        call    WriteStr
        mov     esi, elso_com
        call    StrLower
        call    WriteStr

        call    mio_writeln

        mov     esi, str_be_2
        call    WriteStr
        mov     ecx, 256
        mov     esi, masodik
        call    ReadStr

        call    mio_writeln

        mov     esi, str_len
        call    WriteStr
        mov     esi, masodik
        call    StrLen
        call    WriteInt

        call    mio_writeln

        mov     esi, str_ki_com
        call    WriteStr
        mov     esi, masodik
        mov     edi, masodik_com
        call    StrCompact
        mov     esi, edi
        call    WriteStr

        call    mio_writeln

        mov     esi, str_ki_com_n
        call    WriteStr
        mov     esi, masodik_com
        call    StrUpper
        call    WriteStr

        call    mio_writeln

        mov     esi, elso
        call    StrUpper
        mov     edi, elso
        mov     esi, masodik
        call    StrLower
        call    StrCat


        mov     esi, str_er_ki
        call    WriteStr
        mov     esi, edi
        call    WriteStr

        call    mio_writeln

        mov     esi, str_len
        call    WriteStr
        mov     esi, elso
        call    StrLen
        call    WriteInt



        ret


section .data
    str_be_1        dd          "Irja be az elso stringet: ", 0
    str_be_2        dd          "Irja be a masodik stringet: ", 0
    str_len         dd          "A string hossza: ", 0
    str_ki_com      dd          "Kompaktalt forma: ", 0
    str_ki_com_k    dd          "Kompaktalt forma kisbetukkel: ", 0
    str_ki_com_n    dd          "Kompaktalt forma nagybetukkel: ", 0
    str_er_ki       dd          "Elso string nagybetus verzioja + masodik string kisbetus verziojat: ", 0
section .bss
    elso            resd        256
    elso_com        resd        256
    masodik         resd        256
    masodik_com     resd        256