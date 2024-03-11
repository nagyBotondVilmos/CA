;Nev: Nagy Botond-Vilmos
;Csoport: 513/2
;Feladat: L4 - Modulok

%include 'mio.inc'

global StrLen, StrCat, StrUpper, StrLower, StrCompact

section .text
StrLen:
    push    ecx
    push    edx
    mov     ecx, 0
    mov     eax, 0
    mov     edx, 0
    .szamol:
        mov     cl, [esi + edx]
        cmp     cl, byte 0
        je      .vege

        inc     eax
        inc     edx
        jmp     .szamol
    .vege:
    pop     edx
    pop     ecx
    ret



StrCat:
    push    eax
    push    ecx
    push    edx
    push    esi 
    mov     esi, edi
    call    StrLen
    pop     esi
    mov     edx, eax
    mov     eax, 0
    mov     ecx, 0
    .osszefuz:
        mov     al, [esi + ecx]
        cmp     al, byte 0
        je      .vege
        mov     [edi + edx], al
        inc     edx
        inc     ecx
        jmp     .osszefuz
    .vege:
    mov     [edi + edx], byte 0
    pop     edx
    pop     ecx
    pop     eax
    ret



kisbetu_e:
    mov     ebx, 1
    cmp     eax, 'a'
    jl      .nem
    cmp     eax, 'z'
    jg      .nem
    jmp     .ja
    .nem:
        mov     ebx, 0
        ret
    .ja:
    ret
StrUpper:
    push    eax
    push    ebx
    push    edx
    mov     eax, 0
    mov     ebx, 0
    mov     edx, 0
    .vegigmegy:
        mov     al, [esi + edx]
        cmp     al, byte 0
        je      .vege
        call    kisbetu_e
        cmp     ebx, 0
        je      .nem
        sub     eax, 32
        mov     [esi + edx], al
        inc     edx
        mov     eax, 0
        jmp     .vegigmegy
        .nem:
            inc     edx
            mov     eax, 0
            jmp     .vegigmegy
    .vege:
    pop     edx
    pop     ebx
    pop     eax
    ret



nagybetu_e:
    mov     ebx, 1
    cmp     eax, 'A'
    jl      .nem
    cmp     eax, 'Z'
    jg      .nem
    jmp     .ja
    .nem:
        mov     ebx, 0
        ret
    .ja:
    ret
StrLower:
    push    eax
    push    ebx
    push    edx
    mov     eax, 0
    mov     edx, 0
    .vegigmegy:
        mov     al, [esi + edx]
        cmp     al, byte 0
        je      .vege
        call    nagybetu_e
        cmp     ebx, 0
        je      .nem
        add     eax, 32
        mov     [esi + edx], al
        inc     edx
        mov     eax, 0
        jmp     .vegigmegy
        .nem:
            inc     edx
            mov     eax, 0
            jmp     .vegigmegy
    .vege:
    pop     edx
    pop     ebx
    pop     eax
    ret



feherkarakter_e:
    mov     ebx, 0
    cmp     al, 32
    je      .ja
    cmp     al, 9
    je      .ja
    cmp     al, 13
    je      .ja
    cmp     al, 10
    je      .ja
    jmp     .nem
    .ja:
        mov     ebx, 1
        ret
    .nem:
    ret
StrCompact:
    push    eax
    push    ebx
    push    ecx
    push    edx
    mov     eax, 0
    mov     ecx, 0
    mov     edx, 0
    .berak:
        mov     al, [esi + ecx]
        cmp     al, byte 0
        je      .vege
        call    feherkarakter_e
        cmp     ebx, 1
        je      .ja
        mov     [edi + edx], al
        inc     edx
        inc     ecx
        jmp     .berak
        .ja:
            inc     ecx
            mov     eax, 0
            jmp     .berak
    .vege:
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    ret