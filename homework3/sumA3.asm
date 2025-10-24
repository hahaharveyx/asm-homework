; ---------- A3：结果存到栈中 ----------
.model small
.stack 100h

.data
msg db 'Sum = $'
nl  db 0Dh,0Ah,'$'

.code
main proc
    mov ax,@data
    mov ds,ax

    mov cx,100
    xor ax,ax
    mov bx,1

sum_loop:
    add ax,bx
    inc bx
    loop sum_loop

    push ax            ; 把结果压入栈中

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
