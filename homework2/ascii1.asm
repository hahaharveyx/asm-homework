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
    mov cx,2          ; 外层循环：共两行（26/13=2）
outer:
    push cx           ; 保存外层 CX（因为下面要用 CX 做内层）
    mov cx,perline         
inner:
    mov [pairBuf+1],al    ; 把当前字母写到缓冲区第二个字节
    lea dx, pairBuf        
    mov ah, 9              
    int 21h

    inc al
    loop inner        ; CX--，非零则回 inner

    lea dx,newline         
    mov ah,9
    int 21h

    pop cx            ; 恢复外层 CX
    loop outer        

    mov ax,4C00h
    int 21h
main endp
end main
