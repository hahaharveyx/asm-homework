#include <dos.h>
#include <stdio.h>

void interrupt far (*old_int4)(void);   /* 保存原来的 4 号中断向量 */

/* 新的 4 号中断服务程序：溢出时由 INTO 调用 */
void interrupt far new_int4(void)
{
    puts("\n*** Overflow error (INT 4) ***");

    /* 恢复原来的 INT 4，避免影响其他程序 */
    setvect(4, old_int4);

    _AX = 0x4C00;
    geninterrupt(0x21);       /* int 21h / AH=4Ch，退出到DOS */
}

/* 主程序：读取两个 -128..127 的数做 8 位有符号加法 */
int main(void)
{
    signed char a, b, res;

    old_int4 = getvect(4);         /* 保存原来的 4 号中断向量 */
    setvect(4, new_int4);          /* 安装我们的中断服务程序 */

    printf("Input two signed 8-bit numbers (-128..127): ");
    scanf("%hhd %hhd", &a, &b);

    asm {
        mov al, a          ; AL = a
        add al, b          ; AL = a + b，有符号溢出会置 OF=1
        into               ; 如果 OF=1，则触发4号中断，执行 new_int4
        mov res, al        ; 只有没溢出时才会执行到这里
    }

    printf("result = %d\n", res);

    setvect(4, old_int4);          /* 正常结束时也恢复原来的中断向量 */

    return 0;
}
