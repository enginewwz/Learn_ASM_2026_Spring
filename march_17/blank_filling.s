.section .data
        stringvar:
                .ascii "0123456789abcdef"
        .section .text
.globl _start
_start:
        mov $stringvar, %eax
        
        # initial loopflg
        mov $8, %ecx
1:
        movw (%eax), %bx
        movb %bh, (%eax)
        movb %bl, 1(%eax)
        add $2, %eax
        loop 1b

        # output
        movl $4, %eax
        movl $1, %ebx
        movl $stringvar, %ecx
        movl $16, %edx
        int $0x80

        # exit
        movl $1, %eax
        movl $0, %ebx
        int $0x80
