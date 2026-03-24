# upper the lower case letters in the given string
# x86-64, AT&T
.section .data
    iostring:
        .asciz "ab1g2hA0H56po9wK78nB"
.section .text
.global _start
_start:
    # pointer of the letters
    mov $iostring, %eax
    xor %bl, %bl
    xor %edx, %edx

    # loop: while bl != \0
1:
    movb (%eax), %bl
    inc %edx
    test %bl, %bl
    jz print_result

    # find letters between a-z
    lea -97(%ebx), %ebx
    cmpb $26, %bl
    ja 2f

    lea 65(%ebx), %ebx
    movb %bl, (%eax)

2:
    inc %eax
    xor %ebx, %ebx
    jmp 1b

print_result:
    movb $'\n', (%eax)

    mov $4, %eax
    mov $1, %ebx
    mov $iostring, %ecx
    int $0x80

# exit
    mov $1, %eax
    mov $0, %ebx
    int $0x80
