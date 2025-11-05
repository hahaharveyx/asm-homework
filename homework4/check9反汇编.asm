; ===========================================
; 函数：_report_mismatch
; 功能：打印一条错误信息
; 对应C：printf("row %d col %d got %d expect %d\n", row, col, got, expect);
; ===========================================
_report_mismatch PROC
	push	ebp
	mov	ebp, esp
	sub	esp, 192
	push	ebx
	push	esi
	push	edi

	; ---- printf("row %d col %d got %d expect %d\n", row, col, got, expect); ----
	mov	eax, DWORD PTR _expect$[ebp]
	push	eax                          ; 参数4 expect
	mov	ecx, DWORD PTR _got$[ebp]
	push	ecx                          ; 参数3 got
	mov	edx, DWORD PTR _col$[ebp]
	push	edx                          ; 参数2 col
	mov	eax, DWORD PTR _row$[ebp]
	push	eax                          ; 参数1 row
	push	OFFSET ??_C@_0CA@ONFMHANO@row?5?$CFd?5col?5?$CFd?5got?5?$CFd?5expect?5?$CFd?6@
	call	_printf                      ; 调用printf输出格式字符串
	add	esp, 20

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
_report_mismatch ENDP

; ===========================================
; 函数：_check_table
; 功能：检查9x9乘法表是否正确
; 对应C：for(r=1..9) for(c=1..9) 比对 table[r-1][c-1] 与 r*c
; ===========================================
_check_table PROC
	push	ebp
	mov	ebp, esp
	sub	esp, 240
	push	ebx
	push	esi
	push	edi

	; ---- 外层循环 for (r = 1; r <= 9; ++r) ----
	mov	DWORD PTR _r$4[ebp], 1
	jmp	SHORT $LN4@check_tabl
$LN2@check_tabl:
	mov	eax, DWORD PTR _r$4[ebp]
	add	eax, 1
	mov	DWORD PTR _r$4[ebp], eax
$LN4@check_tabl:
	cmp	DWORD PTR _r$4[ebp], 9
	jg	SHORT $LN3@check_tabl

	; ---- 内层循环 for (c = 1; c <= 9; ++c) ----
	mov	DWORD PTR _c$3[ebp], 1
	jmp	SHORT $LN7@check_tabl
$LN5@check_tabl:
	mov	eax, DWORD PTR _c$3[ebp]
	add	eax, 1
	mov	DWORD PTR _c$3[ebp], eax
$LN7@check_tabl:
	cmp	DWORD PTR _c$3[ebp], 9
	jg	SHORT $LN6@check_tabl

	; ---- got = table[r-1][c-1]; ----
	mov	eax, DWORD PTR _r$4[ebp]
	sub	eax, 1
	imul	ecx, eax, 9
	mov	edx, DWORD PTR _c$3[ebp]
	movzx	eax, BYTE PTR _table[ecx+edx-1]
	mov	DWORD PTR _got$2[ebp], eax

	; ---- expect = r * c; ----
	mov	eax, DWORD PTR _r$4[ebp]
	imul	eax, DWORD PTR _c$3[ebp]
	mov	DWORD PTR _expect$1[ebp], eax

	; ---- if (got != expect) report_mismatch(r,c,got,expect); ----
	mov	eax, DWORD PTR _got$2[ebp]
	cmp	eax, DWORD PTR _expect$1[ebp]
	je	SHORT $LN8@check_tabl
	mov	eax, DWORD PTR _expect$1[ebp]
	push	eax
	mov	ecx, DWORD PTR _got$2[ebp]
	push	ecx
	mov	edx, DWORD PTR _c$3[ebp]
	push	edx
	mov	eax, DWORD PTR _r$4[ebp]
	push	eax
	call	_report_mismatch
	add	esp, 16
$LN8@check_tabl:

	jmp	SHORT $LN5@check_tabl
$LN6@check_tabl:
	jmp	SHORT $LN2@check_tabl
$LN3@check_tabl:

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
_check_table ENDP

; ===========================================
; 函数：_main
; 功能：主函数，打印提示、调用check_table、输出accomplish
; 对应C：
;     puts("Checking 9x9 table...");
;     check_table();
;     printf("Accomplish!\n");
; ===========================================
_main PROC
	push	ebp
	mov	ebp, esp
	sub	esp, 192
	push	ebx
	push	esi
	push	edi

	; ---- puts("Checking 9x9 table..."); ----
	push	OFFSET ??_C@_0BG@GPJCDIND@Checking?59x9?5table?4?4?4@
	call	DWORD PTR __imp__puts
	add	esp, 4

	; ---- check_table(); ----
	call	_check_table

	; ---- printf("Accomplish!\n"); ----
	push	OFFSET ??_C@_0N@MHJHOOKB@Accomplish?$CB?6@
	call	_printf
	add	esp, 4

	; ---- return 0; ----
	xor	eax, eax

	pop	edi
	pop	esi
	pop	ebx
	mov	esp, ebp
	pop	ebp
	ret	0
_main ENDP
