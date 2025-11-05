.model small
.stack 100h

.data
title1  db 'The 9mul9 table:',0Dh,0Ah,'$'
nl     db 0Dh,0Ah,'$'
sep2   db '  $'                 ; 两个空格分隔

.code
; ----------------------------------------------------------
; 打印 $ 结尾字符串（DX = 地址）
prt$ proc
    push ax
    mov  ah,9
    int  21h
    pop  ax
    ret
prt$ endp

; 换行
newline proc
    push dx
    lea  dx, nl
    call prt$
    pop  dx
    ret
newline endp

; ----------------------------------------------------------
; 打印 AX(无符号16位) 的十进制
; 会用到 AX,BX,CX,DX，例程内自保存
print_u16 proc
    push ax
    push bx
    push cx
    push dx
    mov  cx,0
    cmp  ax,0
    jne  pu_div
    mov  dl,'0'
    mov  ah,2
    int  21h
    jmp  pu_done
pu_div:
    mov  bx,10
pu_div_loop:
    xor  dx,dx            ; DX:AX ÷ 10
    div  bx               ; 商→AX，余数→DX(0..9)
    push dx               ; 余数入栈
    inc  cx
    test ax,ax
    jnz  pu_div_loop
pu_out:
    pop  dx
    add  dl,'0'
    mov  ah,2
    int  21h
    loop pu_out
pu_done:
    pop  dx
    pop  cx
    pop  bx
    pop  ax
    ret
print_u16 endp

; ----------------------------------------------------------
; 打印一个乘法项：“a×b=积  ”（结尾带两个空格）
; 约定：AL = a(1..9), BL = b(1..9)
print_term proc
    push ax
    push bx
    push dx

    ; 打印 a
    xor  ah,ah
    call  print_u16

    ; 打印 'x'
    mov   dl, 'x'
    mov   ah, 2
    int   21h

    ; 打印 b
    xor  ah,ah
    mov  al, bl
    call  print_u16

    ; 打印 '='
    mov   dl, '='
    mov   ah, 2
    int   21h

    ; 正确实现（不依赖上面的示意）：
    pop   dx              ; 取回 DX（保存的旧值）
    pop   bx              ; 取回 b
    pop   ax              ; 取回 a

    ; 现在 AL=a, BL=b
    mul   bl              ; AL*BL -> AX
    call  print_u16

    ; 打印两个空格
    push dx
    lea  dx, sep2
    call prt$
    pop  dx

    ret
print_term endp

; ----------------------------------------------------------
; 主程序：双重循环打印 9×9 表
main proc
    mov ax,@data
    mov ds,ax

    ; 标题
    lea dx, title1
    call prt$

    ; 外层：row = 9..1  （用 DL）
    mov dl, 9
row_loop:
    ; 内层：col = 1..row （用 BL）
    mov bl, 1
col_loop:
    ; 调用过程打印 “row x col = 积”
    mov al, dl           ; AL=row
    ; BL 已经是 col
    call print_term

    inc bl
    cmp bl, dl
    jbe col_loop         ; col <= row 继续

    ; 换行
    call newline

    dec dl
    jnz row_loop

    ; 退出到 DOS
    mov ax,4C00h
    int 21h
main endp
end main
