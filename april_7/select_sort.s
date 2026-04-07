# select sort
.section .data
    array: .int 5, 2, 9, 1, 5, 6, 3, 4, 8, 7, 10
    size: .int 11
.section .bss
    output:
        .skip 100
.section .text
.global _start
_start:
    and $-16, %rsp
    mov %rsp, %rbp

    sub $16, %rsp

    mov $array, %rdi    # array
    mov size, %rsi     # size

    mov %rdi, 8(%rsp)
    mov %rsi, (%rsp)

    call select_sort

    mov 8(%rsp), %rdi
    mov (%rsp), %rdx
    lea (%rdi, %rdx, 4), %rsi
    mov $output, %r8

    call print_array

    mov $60, %rax
    xor %rdi, %rdi
    syscall



.global select_sort
.type select_sort, @function
select_sort:

    lea (%rdi, %rsi, 4), %r9    # endcursor

1:
    test %rsi, %rsi
    je exit_sort

    mov %rdi, %rdx              # cursor
    mov %rdi, %rcx              # max num cursor
    movl (%rcx), %r8d           # max num

2:
    add $4, %rdx
    cmp %r9, %rdx
    ja 3f

    cmp %r8d, (%rdx)
    cmova %rdx, %rcx
    cmova (%rdx), %r8d
    jmp 2b

3:
    # swap (%rdx) with (%r9)
    mov (%r9), %r10d
    mov %r10d, (%rcx)
    mov %r8d, (%r9)

    dec %rsi
    sub $4, %r9
    jmp 1b

exit_sort:
    ret


.global print_array
.type print_array, @function
print_array:

    # rdi: array start pos
    # rsi: array end pos
    # rcx: number of elements
    # r8: output buffer pointer

    mov %rdx, %rcx
    mov $10, %r9d
    mov %r8, %r11
1:
    dec %rcx
    cmp $0, %rcx
    jl 4f

    mov (%rdi), %eax
    xor %r10, %r10
2:
    xor %rdx, %rdx
    div %r9
    add $48, %rdx
    mov %dl, -4(%rsp, %r10, 1)
    inc %r10
    cmp $0, %rax
    jne 2b
3:
    dec %r10
    mov -4(%rsp, %r10, 1), %al
    mov %al, (%r8)
    inc %r8
    test %r10, %r10
    jnz 3b
    movb $' ', (%r8)
    inc %r8
    add $4, %rdi
    jmp 1b
4:
    movb $'\n', (%r8)
    inc %r8

    mov $1, %rax
    mov $1, %rdi
    mov %r11, %rsi
    mov %r8, %rdx
    sub %r11, %rdx
    syscall

    ret
