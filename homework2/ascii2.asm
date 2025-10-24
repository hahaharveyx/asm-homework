.model small
.stack 100h

.data
newline db 0Dh,0Ah,'$'
perline dw 13
pairBuf db ' $'            ;  两字节：空格+占位，后面追加 '$'
         db '$'            ;  形成 "  $"，pairBuf+1 会被写入字母

.code
main proc
    mov ax,@data
    mov ds,ax

    mov al,'a'
    mov bx,2          
outer2:
    mov cx,perline        
inner2:
    mov [pairBuf+1],al    
    lea dx, pairBuf        
    mov ah, 9              
    int 21h

    inc al
    dec cx
    jnz inner2        ; 内层没到0 -> 继续

    lea dx,newline
    mov ah,9
    int 21h

    dec bx
    jnz outer2        ; 还有行 -> 继续

    mov ax,4C00h
    int 21h
main endp
end main
