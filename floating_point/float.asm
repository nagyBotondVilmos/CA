;Nev: Nagy Botond-Vilmos
;Csoport: 513/2
;Feladat: L5 - SSE 1
;E(a,b,c,d) = max(a - d / 5, b + a) + sqrt(c + 3 * d / 4) - d^3

%include 'mio.inc'

global main

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

ReadFloat:
    push        eax
    push        ecx
    push        edx
    push        esi
    mov         ecx, 256
    mov         esi, seged
    call        ReadStr
    .egesz_resz:
    mov         eax, 0
    mov         ecx, 0
    mov         edx, 0
    xorps       xmm0, xmm0                  ;teljes xmm0
    xorps       xmm1, xmm1                  ;egesz resz
    xorps       xmm2, xmm2                  ;tort resz
    xorps       xmm3, xmm3                  ;seged
    movss       xmm4, [tiz]                 ;szorzo
    xorps       xmm5, xmm5
    .e_kovetkezo:
        mov         al, [esi + edx]

        cmp         al, '.'
        je          .tort_resz
        cmp         al, byte 0
        je          .szam_vege

        cmp         al, '-'
        je          .elojel
        cmp         al, '+'
        je          .elojel

        cmp         al, '0'
        jl          .hiba
        cmp         al, '9'
        jg          .hiba

        sub         eax, '0'                ;'9' -> 9
        cvtsi2ss    xmm3, eax               ;9 -> 9.0
        clc
        mulss       xmm1, xmm4              ;[xmm0] *= 10.0
        jc          .hiba
        addss       xmm1, xmm3              ;[xmm0] += 9.0
        jc          .hiba

        inc         edx
        jmp         .e_kovetkezo
        .elojel:
            cmp     edx, 0
            jg      .hiba
            inc     edx
            jmp     .e_kovetkezo
    .egeszresz_vege:
    .tort_resz:
    mov         eax, 0
    mov         ecx, 0
    inc         edx                         ;[esi + edx] = '.' -> [esi + edx + 1] = '(szamjegy)'
    xorps       xmm2, xmm2
    xorps       xmm3, xmm3
    movss       xmm4, [tiz]                 ;szorzo = 10.0
    movss       xmm5, [egy]                 ;oszto = 10.0
    .t_kovetkezo:
        mov         al, [esi + edx]

        cmp         al, byte 0
        je          .tortresz_vege

        cmp         al, '0'
        jl          .hiba
        cmp         al, '9'
        jg          .hiba

        sub         eax, '0'                ;'9' -> 9
        cvtsi2ss    xmm3, eax               ;9 -> 9.0
        clc
        mulss       xmm2, xmm4              ;tort *= 10.0
        jc          .hiba
        addss       xmm2, xmm3              ;tort += 9.0
        jc          .hiba

        mulss       xmm5, xmm4

        inc         edx
        jmp         .t_kovetkezo
    .tortresz_vege:
    divss       xmm2, xmm5                  ;tort = 0.6 -> 6.0 / 10.0 -> 0.6
    .szam_vege:
    addss       xmm0, xmm1                  ;xmm0 += [xmm0]
    addss       xmm0, xmm2                  ;xmm0 += (xmm0)
    mov         al, [esi]
    cmp         al, '-'
    jne         .vege
    xorps       xmm3, xmm3                  ;xmm3 = 0.0
    subss       xmm3, xmm0                  ;xmm3 -= 93.6 (=0.0-93.6=-93.6)
    movss       xmm0, xmm3                  ;xmm0 = xmm3 (=-93.6)
    jmp     .vege
    .hiba:
        stc
        jmp     .vege
    .vege:
        xorps       xmm1, xmm1
        xorps       xmm2, xmm2
        xorps       xmm3, xmm3
        xorps       xmm4, xmm4
        xorps       xmm5, xmm5
        pop     esi
        pop     edx
        pop     ecx
        pop     eax
        ret

WriteFloat:
    push        eax
    push        ebx
    push        ecx
    push        edx
    push        esi
    mov         eax, 0
    mov         ebx, 0
    mov         ecx, 0
    mov         edx, 0
    xorps       xmm1, xmm1
    movss       xmm1, xmm0
    xorps       xmm2, xmm2
    xorps       xmm3, xmm3
    comiss      xmm1, xmm3
    jae         .kiir_egesz
    subss       xmm3, xmm1
    movss       xmm1, xmm3
    mov         eax, '-'
    call        mio_writechar
    mov         eax, 0
    .kiir_egesz:
        cvttss2si       eax, xmm1
        cvtsi2ss        xmm3, eax           ;egesz resz
        call            WriteInt
        mov             eax, '.'
        call            mio_writechar
    mov         ecx, 6
    subss       xmm1, xmm3                  ;xmm1 = szam - [szam]
    movss       xmm2, [tiz]
    .kiir_tort:
        cmp             ecx, 0
        je              .vege
        mulss           xmm1, xmm2
        cvttss2si       eax, xmm1
        cvtsi2ss        xmm3, eax
        add             eax, '0'
        call            mio_writechar
        subss           xmm1, xmm3
        dec             ecx
        jmp             .kiir_tort
    .hiba:
        stc
        jmp     .vege
    .vege:
        xorps       xmm1, xmm1
        xorps       xmm2, xmm2
        xorps       xmm3, xmm3
        pop     esi
        pop     edx
        pop     ecx
        pop     ebx
        pop     eax
        ret

ReadExp:
    push        eax
    push        ebx
    push        ecx
    push        edx
    push        esi
    push        edi
    push        ebp
    mov         ecx, 256
    mov         esi, seged
    call        ReadStr
    .egesz_resz:
    mov         eax, 0
    mov         ebx, 0
    mov         ecx, 0
    mov         edx, 0
    mov         edi, 0
    mov         ebp, 0
    xorps       xmm0, xmm0                  ;teljes xmm0
    xorps       xmm1, xmm1                  ;egesz resz
    xorps       xmm2, xmm2                  ;tort resz
    xorps       xmm3, xmm3                  ;seged
    movss       xmm4, [tiz]                 ;szorzo
    xorps       xmm5, xmm5
    .e_kovetkezo:                           ;egesz resz
        mov         al, [esi + edx]

        cmp         al, '.'
        je          .tort_resz
        cmp         al, 0
        je          .mantissza_felepit

        cmp         al, '-'
        je          .elojel
        cmp         al, '+'
        je          .elojel

        cmp         al, '0'
        jl          .hiba
        cmp         al, '9'
        jg          .hiba

        sub         eax, '0'                ;'9' -> 9
        cvtsi2ss    xmm3, eax               ;9 -> 9.0
        clc
        mulss       xmm1, xmm4              ;[xmm0] *= 10.0
        jc          .hiba
        addss       xmm1, xmm3              ;[xmm0] += 9.0
        jc          .hiba

        inc         edx
        jmp         .e_kovetkezo
        .elojel:
            cmp     edx, 0
            jg      .hiba
            inc     edx
            jmp     .e_kovetkezo
    .egeszresz_vege:
    .tort_resz:                             ;tort resz
    mov         eax, 0
    mov         ebx, 0
    mov         ecx, 0
    inc         edx                         ;[esi + edx] = '.' -> [esi + edx + 1] = '(szamjegy)'
    xorps       xmm2, xmm2
    xorps       xmm3, xmm3
    movss       xmm4, [tiz]                 ;szorzo = 10.0
    movss       xmm5, [egy]                 ;oszto = 10.0
    .t_kovetkezo:
        mov         al, [esi + edx]

        cmp         al, 'e'
        je          .tortresz_vege
        cmp         al, 'E'
        je          .tortresz_vege

        cmp         al, '-'
        je          .elojel_t
        cmp         al, '+'
        je          .elojel_t

        cmp         al, '0'
        jl          .hiba
        cmp         al, '9'
        jg          .hiba

        sub         eax, '0'                ;'9' -> 9
        cvtsi2ss    xmm3, eax               ;9 -> 9.0
        clc
        mulss       xmm2, xmm4              ;tort *= 10.0
        jc          .hiba
        addss       xmm2, xmm3              ;tort += 9.0
        jc          .hiba

        mulss       xmm5, xmm4

        inc         edx
        inc         ebx
        jmp         .t_kovetkezo
        .elojel_t:
            cmp     ebx, 0
            jg      .hiba
            inc     ebx
            inc     edx
            jmp     .t_kovetkezo
    .tortresz_vege:
    divss       xmm2, xmm5                  ;tort = 0.6 -> 6.0 / 10.0 -> 0.6
    .mantissza_felepit:
    addss       xmm0, xmm1                  ;xmm0 += [xmm0]
    addss       xmm0, xmm2                  ;xmm0 += (xmm0)
    mov         al, [esi]
    cmp         al, '-'
    jne         .mantissza_vege
    xorps       xmm3, xmm3                  ;xmm3 = 0.0
    subss       xmm3, xmm0                  ;xmm3 -= 93.6 (=0.0-93.6=-93.6)
    movss       xmm0, xmm3                  ;xmm0 = xmm3 (=-93.6)
    .mantissza_vege:

    inc         edx

    .exponens_be:                           ;beolvassuk az e utan az exponenst
    mov     eax, 0
    mov     ebx, 0
    mov     ecx, 10
    mov     edi, 0
    mov     ebp, edx
    .kovetkezo_exp:
        mov     al, [esi + edx]

        cmp     al, '0'
        je      .exponens_be_vege
        cmp     al, byte 0
        je      .exponens_be_vege

        cmp     al, '-'
        je      .elojel_exp

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
        inc     edi

        jmp     .kovetkezo_exp
        .elojel_exp:
            cmp         edi, 0
            jg          .hiba
            inc         edx
            inc         edi
            jmp         .kovetkezo_exp
    .exponens_be_vege:
    mov     al, [esi + ebp]
    cmp     al, '-'
    jne     .exponens_vege
    mov     ecx, -1
    imul    ebx, ecx
    .exponens_vege:
    mov     eax, ebx                    ;eax = exponens
    .beszoroz_exponenssel:
    movss       xmm4, [tiz]
    cmp         eax, 0                  ;az elojeltol fuggoen szorzunk vagy osztunk 10-el n-szer (n = exponens)
    jge         .pozitiv
    jl          .negativ
    .pozitiv:
        mov         ecx, eax
        .poz_szor:
            cmp         ecx, 0
            je          .poz_szor_vege
            mulss       xmm0, xmm4
            dec         ecx
            jmp         .poz_szor
        .poz_szor_vege:
        jmp         .vege
    .negativ:
        neg         eax
        mov         ecx, eax
        .neg_oszt:
            cmp         ecx, 0
            je          .neg_oszt_vege
            divss       xmm0, xmm4
            dec         ecx
            jmp         .neg_oszt
        .neg_oszt_vege:
        jmp         .vege
    .hiba:
        stc
        jmp         .vege
    .vege:
        xorps       xmm1, xmm1
        xorps       xmm2, xmm2
        xorps       xmm3, xmm3
        xorps       xmm4, xmm4
        xorps       xmm5, xmm5
        pop         ebp
        pop         edi
        pop         esi
        pop         edx
        pop         ecx
        pop         ebx
        pop         eax
        ret

WriteExp:
    push        eax
    push        ecx
    xorps       xmm1, xmm1
    xorps       xmm2, xmm2
    xorps       xmm3, xmm3
    xorps       xmm4, xmm4
    movss       xmm4, xmm0          ;mentes
    movss       xmm1, xmm0          ;xmm1 = szam
    xorps       xmm2, xmm2          ;seged = 0
    movss       xmm3, [tiz]         ;oszto
    mov         ecx, 0              ;db
    comiss      xmm1, xmm2
    jae         .pozitiv
    .negativ:
        subss       xmm2, xmm1
        movss       xmm1, xmm2
        xorps       xmm2, xmm2
        mov         eax, '-'
        call        mio_writechar
        mov         eax, 0
    .pozitiv:
    .irany_meghatarozasa:
    movss       xmm2, [egy]
    comiss      xmm1, xmm2          ;szam < 1.0
    jb          .szorzas
    movss       xmm2, [tiz]
    comiss      xmm1, xmm2          ;szam >= 10.0
    jae         .osztas
    jmp         .kesz               ;1.0 <= szam < 10.0
    .szorzas:
        xorps       xmm2, xmm2
        comiss      xmm1, xmm2      ;ha a szam = 0
        je          .kesz
        movss       xmm2, [egy]
        .szor:
            comiss      xmm1, xmm2
            jae         .szor_vege
            mulss       xmm1, xmm3
            inc         ecx
            jmp         .szor
        .szor_vege:
        neg         ecx
        jmp         .kesz
    .osztas:
        movss       xmm2, [tiz]
        .oszt:
            comiss      xmm1, xmm2
            jb          .oszt_vege
            divss       xmm1, xmm3
            inc         ecx
            jmp         .oszt
        .oszt_vege:
        jmp         .kesz
    .kesz:
    movss       xmm0, xmm1
    call        WriteFloat          ;kiirjuk a szamot
    mov         eax, 'e'
    call        mio_writechar
    mov         eax, ecx
    call        WriteInt
    .vege:
        movss       xmm0, xmm4
        xorps       xmm1, xmm1
        xorps       xmm2, xmm2
        xorps       xmm3, xmm3
        xorps       xmm4, xmm4
        pop         ecx
        pop         eax
        ret

main2:
    ; read a number in float format and write it
    call        ReadFloat
    call        mio_writeln
    call        WriteFloat
    call        mio_writeln
    call        WriteExp

    ret

main:
    mov         ecx, 256

    mov         esi, a_be
    call        WriteStr
    call        ReadFloat
    jc          .hiba
    clc
    movss       [AA], xmm0

    call        mio_writeln

    mov         esi, b_be
    call        WriteStr
    call        ReadExp
    jc          .hiba
    clc
    movss       [BB], xmm0

    call        mio_writeln

    mov         esi, c_be
    call        WriteStr
    call        ReadFloat
    jc          .hiba
    clc
    movss       [CC], xmm0

    call        mio_writeln

    mov         esi, d_be
    call        WriteStr
    call        ReadExp
    jc          .hiba
    clc
    movss       [D], xmm0

    call        mio_writeln

    ;elso resz
    ;a - d / 5 = xmm0
    movss       xmm0, [AA]
    movss       xmm1, [D]
    divss       xmm1, [ot]
    subss       xmm0, xmm1
    ;b + a = xmm1
    movss       xmm1, [BB]
    addss       xmm1, [AA]
    ;max(a - d / 5, b + a) = xmm0
    maxss       xmm0, xmm1

    ;masodik resz
    ;sqrt(c + 3 * d / 4) = xmm1
    movss       xmm1, [D]
    mulss       xmm1, [harom]
    divss       xmm1, [negy]
    addss       xmm1, [CC]
    sqrtss      xmm1, xmm1

    ;harmadik resz
    ;d^3 = xmm2
    movss       xmm2, [D]
    mulss       xmm2, [D]
    mulss       xmm2, [D]

    ;E(a,b,c,d) = max(a - d / 5, b + a) + sqrt(c + 3 * d / 4) - d^3
    addss       xmm0, xmm1
    subss       xmm0, xmm2

    mov         esi, kifejezes
    call        WriteStr
    call        mio_writeln

    mov         esi, er_ki
    call        WriteStr
    call        mio_writeln

    mov         esi, er_reg
    call        WriteStr
    call        WriteFloat
    call        mio_writeln

    mov         esi, er_exp
    call        WriteStr
    call        WriteExp

    jmp         .vege

    .hiba:
        call    mio_writeln
        mov     esi, hiba
        call    WriteStr
        jmp     .vege

    .vege:
    ret

section .data
    AA              dd          0.0
    BB              dd          0.0
    CC              dd          0.0
    D               dd          0.0
    harom           dd          3.0
    negy            dd          4.0
    ot              dd          5.0
    a_be            dd          "Irja be az a szamot hagyomanyos lebego pontos formaban: ", 0
    b_be            dd          "Irja be a b szamot exponencialis formaban: ", 0
    c_be            dd          "Irja be a c szamot hagyomanyos lebego pontos formaban: ", 0
    d_be            dd          "Irja be a d szamot exponencialis formaban: ", 0
    kifejezes       dd          "E(a,b,c,d) = max(a - d / 5, b + a) + sqrt(c + 3 * d / 4) - d^3", 0
    er_ki           dd          "A fenti kifejezes erteke", 0
    er_reg          dd          "- hagyomanyos lebegopontos alakban: ", 0
    er_exp          dd          "- exponencialis alakban: ", 0
    egy             dd          1.0
    tiz             dd          10.0
    hiba            dd          "Hiba: ervenytelen bemenet!", 0
section .bss
    seged           resb        256
    seged2          resb        256