;Nev: Nagy Botond-Vilmos
;Csoport: 513/2
;Feladat: L4 - Modulok

%include 'mio.inc'
%include 'iostr.inc'

global ReadInt, ReadBin, ReadHex, WriteInt, WriteBin, WriteHex, ReadInt64, ReadBin64, ReadHex64, WriteInt64, WriteBin64, WriteHex64

section .text
ReadInt:
    push    ebx
    push    ecx
    push    edx
    push    esi

    mov     ecx, 256
    mov     esi, seged
    call    ReadStr

    mov     eax, 0
    mov     ebx, 0
    mov     ecx, 10
    mov     edx, 0
    .kovetkezo:
        mov     al, [esi + edx]

        cmp     al, 0
        je      .beolvasas_vege

        cmp     al, '-'
        je      .elojel

        cmp     al, '0'
        jl      .hiba
        cmp     al, '9'
        jg      .hiba

        sub     eax, '0'
        clc
        imul    ebx, ecx
        jc      .hiba
        add     ebx, eax
        jc      .hiba

        inc     edx

        jmp     .kovetkezo
    .beolvasas_vege:
    mov     al, [esi]
    cmp     al, '-'
    jne     .vege
    mov     ecx, -1
    imul    ebx, ecx
    jmp     .vege
    .elojel:
        cmp     edx, 0
        jg      .hiba
        inc     edx
        jmp     .kovetkezo
    .hiba:
        stc
        jmp     .vege
    .vege:
        mov     eax, ebx
        pop     esi
        pop     edx
        pop     ecx
        pop     ebx
        ret
WriteInt:
    push    ebx
    push    ecx
    push    edx
    push    eax
    push    dword 'v'           ;a 'v' karakterik szedjuk majd ki a szamokat a verembol
    mov     eax, [esp + 4]
    cmp     eax, 0              ;ha negativ, akkor kiirunk egy '-'-t
    jl      .negativ            ;ha pozitiv, akkor megy tovabb
    mov     eax, [esp + 4]
    mov     ebx, 10             ;ezzel osztunk
    .felbontas:
        mov     edx, 0
        cdq
        idiv    ebx
        push    edx             ;berakja a szam szamjegyeit a verembe
        cmp     eax, 0          ;amig a szam nem 0
        je      .kiiras
        cmp     eax, 0
        jne     .felbontas
    .kiiras:
        pop     eax             ;kiszedi a szamjegyeket a verembol a 'v' karakterig
        cmp     eax, 'v'
        je      .vege
        add     eax, '0'
        call    mio_writechar
        jmp     .kiiras
    .negativ:
        push    eax
        mov     eax, '-'        ;kiirja a '-' elojelet
        call    mio_writechar
        pop     eax
        neg     eax
        mov     ebx, 10
        jmp     .felbontas
    .vege:
    pop     eax
    pop     edx
    pop     ecx
    pop     ebx
    ret

ReadBin:
    push    ebx
    push    ecx
    push    edx
    push    esi

    mov     ecx, 256
    mov     esi, seged
    call    ReadStr

    mov     eax, 0
    mov     ebx, 0
    mov     edx, 0

    .felbont:
        mov     al, [esi + edx]

        cmp     al, byte 0
        je      .vege

        cmp     al, '0'
        jl      .hiba
        cmp     al, '1'
        jg      .hiba

        sub     eax, '0'
        clc
        shl     ebx, 1
        jc      .hiba
        add     ebx, eax
        jc      .hiba

        inc     edx

        jmp     .felbont
    .hiba:
        stc
        jmp     .vege

    .vege:
    mov     eax, ebx
    pop     esi
    pop     edx
    pop     ecx
    pop     ebx
    ret

WriteBin:
    push    eax
    push    ebx
    push    ecx
    mov     ebx, eax
    mov     ecx, 0
    .felbont:
        clc
        mov     eax, 0
        shl     ebx, 1
        adc     eax, '0'
        call    mio_writechar
        inc     ecx
        cmp     ecx, 32
        je      .vege
        jmp     .felbont
    .vege:
    pop     ecx
    pop     ebx
    pop     eax
    ret

ReadHex:
    push    ebx
    push    edx
    push    esi

    mov     ecx, 256
    mov     esi, seged
    call    ReadStr

    mov     eax, 0
    mov     ebx, 0
    mov     edx, 0
    .kovetkezo:
        mov     al, [esi + edx]
        cmp     al, byte 0
        je      .beolvasas_vege
        cmp     al, '9'
        jle     .szam
        cmp     al, 'F'
        jle     .BETU
        cmp     al, 'f'
        jle     .betu
        jmp     .hiba
        .szam:
            cmp     al, '0'
            jl      .hiba
            sub     eax, '0'
            jmp     .felepit
        .BETU:
            cmp     al, 'A'
            jl      .hiba
            sub     eax, 'A'
            add     eax, 10
            jmp     .felepit
        .betu:
            cmp     al, 'a'
            jl      .hiba
            sub     eax, 'a'
            add     eax, 10
            jmp     .felepit
        .felepit:
            clc
            shl     ebx, 4
            jc      .hiba
            add     ebx, eax
            jc      .hiba
            inc     edx
            jmp     .kovetkezo
    .beolvasas_vege:
    mov     eax, ebx
    jmp     .vege
    .hiba:
        stc
        jmp     .vege
    .vege:
    pop     esi
    pop     edx
    pop     ebx
    ret

WriteHex:
    push    eax
    push    ebx
    push    ecx
    push    edx
    mov     ecx, 8
    mov     ebx, eax
    .felbontas:
        mov     eax, ebx
        rol     eax, 4
        mov     ebx, eax
        and     eax, 0xF
        cmp     eax, 9
        jle     .szam
        cmp     eax, 15
        jle     .betu
        .szam:
            add     eax, '0'
            jmp     .kiiras
        .betu:
            sub     eax, 10
            add     eax, 'A'
            jmp     .kiiras
        .kiiras:
        call    mio_writechar
        dec     ecx
        cmp     ecx, 0
        je      .vege
        jmp     .felbontas
    .vege:
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    ret

ReadBin64:
    push    ebx
    push    ecx
    push    esi
    push    edi

    mov     ecx, 256
    mov     esi, seged
    call    ReadStr

    mov     eax, 0
    mov     ebx, 0
    mov     ecx, 0
    mov     edx, 0

    .felbont:
        mov     al, [esi + ecx]

        cmp     al, byte 0
        je      .vege

        cmp     ecx, 64
        jg      .hiba
        
        cmp     al, '0'
        jl      .hiba
        cmp     al, '1'
        jg      .hiba

        sub     eax, '0'
        clc
        shl     edx, 1
        jc      .hiba
        shl     ebx, 1
        adc     edx, 0
        add     ebx, eax

        inc     ecx

        jmp     .felbont
    .hiba:
        stc
        jmp     .vege
    .vege:
    mov     eax, ebx
    pop     edi
    pop     esi
    pop     ecx
    pop     ebx
    ret

WriteBin64:
    push    eax
    push    edx
    mov     eax, edx
    call    WriteBin
    mov     eax, [esp + 4]
    call    WriteBin
    pop     edx
    pop     eax
    ret

ReadHex64:
    push    ebx
    push    ecx
    push    esi
    push    edi

    mov     ecx, 256
    mov     esi, seged
    call    ReadStr

    mov     eax, 0
    mov     ebx, 0
    mov     ecx, 0
    mov     edx, 0
    .kovetkezo:
        mov     al, [esi + ecx]
        cmp     al, byte 0
        je      .beolvasas_vege
        cmp     ecx, 16
        jge     .hiba
        cmp     al, '9'
        jle     .szam
        cmp     al, 'F'
        jle     .BETU
        cmp     al, 'f'
        jle     .betu
        jmp     .hiba
        .szam:
            cmp     al, '0'
            jl      .hiba
            sub     eax, '0'
            jmp     .felepit
        .BETU:
            cmp     al, 'A'
            jl      .hiba
            sub     eax, 'A'
            add     eax, 10
            jmp     .felepit
        .betu:
            cmp     al, 'a'
            jl      .hiba
            sub     eax, 'a'
            add     eax, 10
            jmp     .felepit
        .felepit:
            mov     edi, 0xF0000000
            and     edi, ebx            ;ebx elso 4 bitje

            shl     ebx, 4              ;hozzaadjuk a mostani karaktert
            add     ebx, eax

            rol     edi, 4              ;elorehozzuk a biteket
            clc
            shl     edx, 4
            jc      .hiba
            add     edx, edi            ;hozzaadjuk az edxhez

            inc     ecx
            jmp     .kovetkezo
    .beolvasas_vege:
    mov     eax, ebx
    jmp     .vege
    .hiba:
        stc
        jmp     .vege
    .vege:
    pop     edi
    pop     esi
    pop     ecx
    pop     ebx
    ret

WriteHex64:
    push    eax
    push    edx
    mov     eax, edx
    call    WriteHex
    mov     eax, [esp + 4]
    call    WriteHex
    pop     edx
    pop     eax
    ret
szamma_alakit:
    sub     ebx, '0'
    ret
e_a_x_szor_10:
    push    ecx
    mov     ecx, 10
    mul     ecx
    pop     ecx
    ret
e_b_p_szor_10:
    imul    ebp, 10
    ret
neg_szam:
    not     eax
    not     edx
    add     eax, 1
    adc     edx, 0
    ret
ReadInt64:
    push    ebx
    push    ecx
    push    esi
    push    ebp
    
    mov     ecx, 256
    mov     esi, seged
    call    ReadStr

    mov     eax, 0
    mov     edx, 0
    mov     ebx, 0
    mov     ecx, 0
    mov     edi, 0
    mov     ebp, 0
    .kovetkezo:
        mov     bl, [esi + edi]

        cmp     bl, 0
        je      .beolvasas_vege

        cmp     bl, '-'
        je      .elojel

        cmp     bl, '0'
        jl      .hiba
        cmp     bl, '9'
        jg      .hiba

        call    szamma_alakit

        call    e_b_p_szor_10
        jo      .hiba

        call    e_a_x_szor_10
        clc 
        add     ebp, edx
        jc      .hiba
        clc
        add     eax, ebx
        adc     ebp, 0
        jc      .hiba

        inc     edi

        jmp     .kovetkezo
    .beolvasas_vege:
    mov     edx, ebp
    mov     bl, [esi]
    cmp     ebx, '-'
    jne     .vege                   ;ha pozitiv
    call    neg_szam                ;ha negativ, akkor negalom
    jmp     .vege   
    .elojel:
        cmp     edi, 0
        jg      .hiba
        inc     edi
        jmp     .kovetkezo
    .hiba:
        stc
        jmp     .vege
    .vege:
        pop     ebp
        pop     esi
        pop     ecx
        pop     ebx
        ret

ki_minusz:
    push    eax
    mov     eax, '-'
    call    mio_writechar
    pop     eax
    ret
ki_szam:
    push    eax
    add     eax, '0'
    call    mio_writechar
    pop     eax
    ret
e_a_x_per_10:
    push    ecx
    mov     ecx, 10
    div     ecx
    pop     ecx
    ret
WriteInt64:
    push    eax
    push    ebx
    push    ecx
    push    edx
    push    dword 'v'           ;a 'v' karakterik szedjuk majd ki a szamokat a verembol
    cmp     edx, 0              ;ha negativ, akkor kiirunk egy '-'-t
    jl      .negativ            ;ha pozitiv, akkor megy tovabb
    mov     ebx, 10             ;ezzel osztunk
    .felbontas:
        ;pl.:       edx = 1 2 3 4 ; eax = 5 6 7 8
        mov     ecx, eax
        mov     eax, edx

        mov     edx, 0

        call    e_a_x_per_10    ;edx = eax % 10 (utolso szamjegy az edx-bol)

        mov     ebx, eax        ;elmentjuk az edx maradekat

        mov     eax, ecx        ;visszarakjuk az eax eredeti erteket
        ;edx = 4 ; eax = 5 6 7 8

        call    e_a_x_per_10
        ;edx = 8 ; eax = 4 5 6 7

        push    edx             ;berakjuk a verembe az utolso szamjegyet

        mov     edx, ebx        ;edx = ebx = 1 2 3 ; eax = 4 5 6 7


        cmp     edx, 0          ;amig a szam nem 0
        je      .lehet_0
        cmp     eax, 0
        jne     .felbontas
        .lehet_0:
            cmp     eax, 0
            je      .kiiras
            jmp     .felbontas
    .kiiras:
        pop     eax             ;kiszedi a szamjegyeket a verembol a 'v' karakterig
        cmp     eax, 'v'
        je      .vege
        call    ki_szam
        jmp     .kiiras
    .negativ:
        call    ki_minusz
        call    neg_szam
        mov     ebx, 10
        jmp     .felbontas
    .vege:
    pop     edx
    pop     ecx
    pop     ebx
    pop     eax
    ret

section .bss
    seged           resd    256