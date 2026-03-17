# sumup_odd.s
# add up all odd numbers from 1 to 200
.section .data
    bytevar:
        .rept 100
        .byte 0
        .endr
        .byte 13, 10

.section .text
.global _start
_start:
    # inital loop flag
    mov $100, %rcx
    # inital bytevar pointer
    mov $bytevar, %rax

1:
    leal -201(, %rcx, 2), %rbx
    # 2 * 100 - 201 = -1
    neg %rbx
    mov %rbx, (%rax)
    inc %rax
    loop 1b

    # output
    mov $1, %rax
    mov $1, %rdi
    mov $bytevar, %rsi
    mov 102, %rdx
    syscall

    # exit
    mov $60, %rax
    mov $1, %rdi
    syscall

