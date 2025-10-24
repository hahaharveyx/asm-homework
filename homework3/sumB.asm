; ---------- B：用户输入N并求和 ----------
.model small
.stack 100h

.data
prompt db 'Enter N (1-100): $'
buf     db 5,0,0,0,0,0   ; DOS行输入缓冲区
nl      db 0Dh,0Ah,'$'
msg     db 'Sum = $'

.code
main proc
    mov ax,@data
    mov ds,ax

    lea dx,prompt
    mov ah,9
    int 21h

    lea dx,buf
    mov ah,0Ah
    int 21h             ; 读取用户输入

    lea dx, nl
    mov ah, 9
    int 21h

    lea si,buf+2        ; SI指向第一个输入字符
    xor ax,ax           ; AX = 0，用来保存转换结果
convert:
    mov bl,[si]         ; 取当前字符，比如 '2'
    cmp bl,0Dh          ; 判断是否回车（输入结束）
    je done
    sub bl,'0'          ; 从ASCII转为数值：'2'→2
    mov bh,0
    mov cx,ax           ; CX保存当前结果
    mov ax,10
    mul cx
    add ax,bx
    inc si
    jmp convert
done:
    mov bx,ax           ; BX = N

    xor ax,ax
    mov cx,bx
    mov dx,1
sum_loop:
    add ax,dx
    inc dx
    loop sum_loop

    push ax

    lea dx,msg
    mov ah,9
    int 21h

    pop ax

    call print_ax
    lea dx,nl
    mov ah,9
    int 21h

    mov ax,4C00h
    int 21h
main endp

print_ax proc
    push ax 
    push bx 
    push cx 
    push dx
    mov cx,0
    cmp ax,0
    jne pa_loop
    mov dl,'0'
    mov ah,2
    int 21h
    jmp pa_end
pa_loop:
    xor dx,dx
    mov bx,10
    div bx
    push dx
    inc cx
    cmp ax,0
    jne pa_loop
pa_out:
    pop dx
    add dl,'0'
    mov ah,2
    int 21h
    loop pa_out
pa_end:
    pop dx
    pop cx 
    pop bx 
    pop ax
    ret
print_ax endp
end main
