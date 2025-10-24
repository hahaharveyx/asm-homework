; ---------- A1??1+2+...+100????????AX ----------
.model small
.stack 100h

.data
msg db 'Sum = $'     ; ?????
nl  db 0Dh,0Ah,'$'   ; ???

.code
main proc
    mov ax,@data
    mov ds,ax         ; ?????????DS

    mov cx,100        ; CX???????1??100
    xor bx,bx         ; BX????????
    mov ax,1          ; AX???????

sum_loop:
    add bx,ax         ; AX = AX + BX
    inc ax            ; BX = BX + 1
    loop sum_loop     ; CX = CX - 1??0????


    ; BX????????5050
    lea dx,msg
    mov ah,9
    int 21h


    ; ??BX???????
    call print_bx
    lea dx,nl
    mov ah,9
    int 21h

    mov ax,4C00h
    int 21h
main endp

; -------- ??BX??????? --------
print_bx proc
    push ax 
    push bx 
    push cx 
    push dx
    mov cx,0
    cmp bx,0
    jne pa_loop
    mov dl,'0'
    mov ah,2
    int 21h
    jmp pa_end
pa_loop:
    xor dx,dx
    mov ax,bx
    mov bx,10
    div bx
    push dx
    inc cx
    mov bx,ax
    cmp bx,0
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
print_bx endp
end main
