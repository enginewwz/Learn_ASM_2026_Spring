# sumup_odd.s
# add up all odd numbers from 1 to 200
.section .data
    sum:
        .int 0

.section .text
.global _start
_start:
    # inital loop flag
    mov $100, %rcx
    # inital odd counter
    mov $1, %eax
    mov $0, %ebx

1:
    add %eax, %ebx
    add $2, %eax
    loop 1b

    mov %ebx, sum

    # exit
    mov $60, %rax
    mov $0, %rdi
    syscall

