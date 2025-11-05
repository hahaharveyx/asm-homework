; -------------------- print_term(a,b) --------------------
_print_term PROC
    push    ebp
    mov     ebp, esp
    sub     esp, 16                 ; 分配局部变量（含 prod）
    ; prod = a * b
    mov     eax, DWORD PTR _a$[ebp] ; 取参数 a
    imul    eax, DWORD PTR _b$[ebp] ; eax = a * b
    mov     DWORD PTR _prod$[ebp], eax ; 保存乘积 prod

    ; printf("%dx%d=%-2d  ", a, b, prod);
    mov     eax, DWORD PTR _prod$[ebp]
    push    eax                     ; 第3参：prod
    mov     ecx, DWORD PTR _b$[ebp]
    push    ecx                     ; 第2参：b
    mov     edx, DWORD PTR _a$[ebp]
    push    edx                     ; 第1参：a
    push    OFFSET ??_C@...@?$0?5d?0x?$0?5d?$DN?$0?5d?0?0?$AA@ ; "%dx%d=%-2d  "
    call    _printf
    add     esp, 16                 ; 清理参数栈

    mov     esp, ebp
    pop     ebp
    ret     0
_print_term ENDP

; -------------------- print_row(row) --------------------
_print_row PROC
    push    ebp
    mov     ebp, esp
    sub     esp, 8
    mov     DWORD PTR _col$1[ebp], 1 ; col = 1
$LN_for_test:
    mov     eax, DWORD PTR _col$1[ebp]
    cmp     eax, DWORD PTR _row$[ebp] ; col <= row ?  ; 判断 col <= row
    jg      SHORT $LN_for_end

    ; print_term(row, col);
    mov     ecx, DWORD PTR _col$1[ebp]
    push    ecx
    mov     edx, DWORD PTR _row$[ebp]
    push    edx
    call    _print_term
    add     esp, 8

    inc     DWORD PTR _col$1[ebp]     ; col++
    jmp     SHORT $LN_for_test
$LN_for_end:
    push    10                        ; '\n'
    call    _putchar                  ; 换行
    add     esp, 4

    mov     esp, ebp
    pop     ebp
    ret     0
_print_row ENDP

; -------------------- main --------------------
_main PROC
    push    ebp
    mov     ebp, esp
    sub     esp, 32

    push    OFFSET ??_C@...@The?59mul9?5table?3?$AA@ ; "The 9mul9 table:"
    call    _puts
    add     esp, 4

    mov     DWORD PTR _row$1[ebp], 9  ; row = 9
$LN_outer_test:
    cmp     DWORD PTR _row$1[ebp], 1  ; row >= 1 ?
    jl      SHORT $LN_outer_end

    ; print_row(row);
    mov     eax, DWORD PTR _row$1[ebp]
    push    eax
    call    _print_row
    add     esp, 4

    dec     DWORD PTR _row$1[ebp]     ; row--
    jmp     SHORT $LN_outer_test

$LN_outer_end:
    xor     eax, eax                  ; return 0
    mov     esp, ebp
    pop     ebp
    ret     0
_main ENDP
