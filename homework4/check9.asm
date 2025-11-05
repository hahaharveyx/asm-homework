.model small
.stack 100h

.data
title1   db 'Checking 9x9 table...',0Dh,0Ah,'$'
okmsg   db 'accomplish!',0Dh,0Ah,'$'
nl      db 0Dh,0Ah,'$'
tmp     db ?

; 打印格式用到的常量串
s_row   db 'row ', '$'
s_col   db ' col ', '$'
s_got   db ' got ', '$'
s_exp   db ' expect ', '$'

; 9x9 表（按行存储），其中若干处故意写错
table  db  7,2,3,4,5,6,7,8,9        ; 行1（应为 1,2,3,4,5,6,7,8,9）←开头故意错成7
       db  2,4,7,8,10,12,14,16,18   ; 行2（第三个应为6，误写7）
       db  3,6,9,12,15,18,21,24,27
       db  4,8,12,16,7,24,28,32,36  ; 行4（第五个应为20，误写7）
       db  5,10,15,20,25,30,35,40,45
       db  6,12,18,24,30,7,42,48,54 ; 行6（第6个应为36，误写7）
       db  7,14,21,28,35,42,49,56,63
       db  8,16,24,32,40,48,56,7,72  ; 行8（第8个应为64，误写7）
       db  9,18,27,36,45,54,63,72,81


.code
; -------------------------------------------------
; 打印 $ 结尾字符串（DX=地址）
prt$ proc
    push ax
    mov  ah, 9
    int  21h
    pop  ax
    ret
prt$ endp

; 换行
newline proc
    push dx
    mov  dx, OFFSET nl
    call prt$
    pop  dx
    ret
newline endp

; 打印 AX(无符号16位) 的十进制
print_u16 proc
    push ax
    push bx
    push cx
    push dx
    mov  cx, 0
    cmp  ax, 0
    jne  pu_div
    mov  dl, '0'
    mov  ah, 2
    int  21h
    jmp  pu_done
pu_div:
    mov  bx, 10
pu_div_loop:
    xor  dx, dx
    div  bx           ; AX=AX/10, DX=余数
    push dx
    inc  cx
    test ax, ax
    jnz  pu_div_loop
pu_out:
    pop  dx
    add  dl, '0'
    mov  ah, 2
    int  21h
    loop pu_out
pu_done:
    pop  dx
    pop  cx
    pop  bx
    pop  ax
    ret
print_u16 endp

; -------------------------------------------------
; 打印一条错误信息：
;   "row R col C got G expect E" + 换行
; 入参：DL=行号(1..9), BL=列号(1..9),  [SI]=表中值, AL=期望值
print_mismatch proc
    push ax
    push bx
    push dx

    ; 先把参数备份到安全处（因为后面要用 DX 做字符串地址）
    mov  ch, dl      ; 保存行号 row
    mov  cl, bl      ; 保存列号 col
    mov  tmp, al      ; 保存期望值 expect

    ; "row "
    mov  dx, OFFSET s_row
    call prt$
    xor  ax, ax
    mov  al, ch      ; 用保存的 row
    call print_u16

    ; " col "
    mov  dx, OFFSET s_col
    call prt$
    xor  ax, ax
    mov  al, cl      ; 用保存的 col
    call print_u16

    ; " got "
    mov  dx, OFFSET s_got
    call prt$
    mov  al, [si]    ; 表中实际值
    xor  ah, ah
    call print_u16

    ; " expect "
    mov  dx, OFFSET s_exp
    call prt$
    xor  ax, ax
    mov  al, tmp      ; 用保存的 expect
    call print_u16

    call newline

    pop  dx
    pop  bx
    pop  ax
    ret
print_mismatch endp


; -------------------------------------------------
; 主程序：校验 table[9][9]
main proc
    mov ax, @data
    mov ds, ax

    ; 标题
    mov dx, OFFSET title1
    call prt$

    mov si, OFFSET table  ; SI 指向当前表项
    mov dl, 1             ; 行号 1..9
row_loop:
    mov bl, 1             ; 列号 1..9
col_loop:
    ; 期望 = 行号 * 列号  （8位乘法：AL*BL → AX）
    mov  al, dl
    mul  bl               ; AX=dl*bl (<=81)，低字节AL即期望
    ; 比较期望与表中值
    cmp  al, [si]
    je   ok_item

    ; 打印一条错误信息
    call print_mismatch   ; DL=row, BL=col, [SI]=got, AL=expect

ok_item:
    inc  si               ; 下一表项
    inc  bl               ; 列+1
    cmp  bl, 10
    jne  col_loop

    inc  dl               ; 行+1
    cmp  dl, 10
    jne  row_loop

    mov  dx, OFFSET okmsg
    call prt$
    jmp  finish


finish:
    mov ax, 4C00h
    int 21h
main endp
end main
