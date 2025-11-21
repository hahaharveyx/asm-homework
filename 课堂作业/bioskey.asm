.model small
.stack 100h

.data
msg db 'Press keys, quit when you press any SHIFT key...',0Dh,0Ah,'$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; 用 BIOS（int 10h）输出提示
    mov si, OFFSET msg
print_msg:
    mov al, [si]
    cmp al, '$'
    je  main_loop
    mov ah, 0Eh          ; TTY 输出
    mov bh, 0
    mov bl, 7
    int 10h
    inc si
    jmp print_msg

; ================== 主循环 ==================
main_loop:

    ; 1) 先检查 Shift 状态（不依赖任何按键）
    mov ah, 02h          ; int 16h 功能 02h：读 Shift 状态
    int 16h
    ; AL 各位含义：
    ; bit0 = 右 Shift
    ; bit1 = 左 Shift
    ; bit2 = Ctrl
    ; bit3 = Alt
    ; bit4 = ScrollLock
    ; bit5 = NumLock
    ; bit6 = CapsLock
    ; bit7 = Insert 状态
    test al, 00000011b   ; 任意一位为 1 就有 Shift 按下
    jnz  quit_program    ; 立即退出

    ; 2) 再看键盘缓冲区里有没有按键（非阻塞）
    mov ah, 01h          ; int 16h 功能 01h：检查键盘缓冲区
    int 16h
    jz  main_loop        ; ZF=1 → 没有按键，回去继续检查 Shift

    ; 3) 缓冲区有键，读出来并显示
    mov ah, 00h          ; int 16h 功能 00h：读键（已知有，所以不会阻塞）
    int 16h              ; 返回：AL=ASCII, AH=扫描码

    cmp al, 0
    je  main_loop        ; 非打印键（F1 等），忽略

    mov ah, 0Eh          ; BIOS TTY 打印 AL
    mov bh, 0
    mov bl, 7
    int 10h

    jmp main_loop

; ================== 结束 ==================
quit_program:
    mov ax, 4C00h
    int 21h            

main endp
end main
