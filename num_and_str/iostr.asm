;Nev: Nagy Botond-Vilmos
;Csoport: 513/2
;Feladat: L4 - Modulok

%include 'mio.inc'

global ReadStr, WriteStr, ReadLnStr, WriteLnStr, NewLine

section .text
ReadStr:
    push    eax
    push    edx
    mov     edx, 0
    .beolvas:
        call    mio_readchar

        cmp     al, 13
        je      .vege

        cmp     al, 8
        je      .backspace

        call    mio_writechar

        mov     [esi + edx], al
        inc     edx

        jmp     .beolvas

        .backspace:
            cmp     edx, 0
            je      .beolvas
            dec     edx
            call    mio_writechar
            mov     al, 32
            call    mio_writechar
            mov     al, 8
            call    mio_writechar
            jmp     .beolvas

    .vege:
    mov     [esi + edx], byte 0
    mov     [esi + ecx], byte 0
    pop     edx
    pop     eax
    ret

WriteStr:
    push    eax
    push    ecx
    mov     ecx, 0
    .kiir:
        mov     al, [esi + ecx]
        cmp     al, 0
        je      .vege
        call    mio_writechar
        inc     ecx
        jmp     .kiir
    .vege:
    pop     ecx
    pop     eax
    ret

ReadLnStr:
    push    eax
    push    edx
    mov     edx, 0
    .beolvas:
        call    mio_readchar

        cmp     al, 13
        je      .vege

        cmp     al, 8
        je      .backspace

        call    mio_writechar

        mov     [esi + edx], al
        inc     edx

        jmp     .beolvas

        .backspace:
            cmp     edx, 0
            je      .beolvas
            dec     edx
            call    mio_writechar
            mov     al, 32
            call    mio_writechar
            mov     al, 8
            call    mio_writechar
            jmp     .beolvas

    .vege:
    mov     [esi + edx], byte 0
    mov     [esi + ecx], byte 0
    call    mio_writeln
    pop     edx
    pop     eax
    ret

WriteLnStr:
    push    eax
    push    ecx
    mov     ecx, 0
    .kiir:
        mov     al, [esi + ecx]
        cmp     al, byte 0
        je      .vege
        call    mio_writechar
        inc     ecx
        jmp     .kiir
    .vege:
    call    mio_writeln
    pop     ecx
    pop     eax
    ret

NewLine:
    push    eax
    mov     eax, 0
    mov     al, 13
    call    mio_writechar
    pop     eax
    ret