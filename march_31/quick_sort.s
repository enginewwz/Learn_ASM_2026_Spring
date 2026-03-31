# quicksort with int array
.section .data
    testdata:
        .int 5, 2, 9, 1, 5, 6, 3, 4, 8, 7, 0
.section .bss
    rightarray:
        .skip 64 # maxline 16
    output:
        .skip 64
.section .text
.global _start
_start:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp
    # 16bits aligen rsp

    sub $32, %rsp
    movq $testdata, 24(%rsp) # string addr
    movq $11, 16(%rsp)       # n

    mov 24(%rsp), %rdi
    mov 16(%rsp), %rdx
    lea (%rdi, %rdx, 4), %rsi

    call quicksort

    mov 24(%rsp), %rdi
    mov 16(%rsp), %rdx
    lea (%rdi, %rdx, 4), %rsi
    mov $output, %r8

    call print_array

    mov $60, %rax
    xor %rdi, %rdi
    syscall



quicksort:

    # rdi: string start pos
    # rsi: string end pos
    # rdx: number of elements

    cmp $1, %rdx
    jg begin_sort
    ret

begin_sort:
    push %rbp
    mov %rsp, %rbp
    sub $64, %rsp

    mov %rdi, 56(%rsp)
    mov %rsi, 48(%rsp)
    mov %rdx, 40(%rsp)
    mov %rdx, %rdi

    call get_random_mod

    mov 56(%rsp), %r8
    lea (%r8, %rax, 4), %r9
    mov (%r9), %r10d
    mov 48(%rsp), %rax
    
    mov 56(%rsp), %rdi
    mov $rightarray, %rsi

    mov $0, %rcx
    mov $0, %rdx

1:
    # r8: pointer
    mov (%r8), %r11d
    cmp %r8, %rax
    jle end

    cmp %r8, %r9
    je 3f

    cmp %r11d, %r10d
    jle 2f

    mov %r11d, (%rdi)
    inc %rcx
    add $4, %rdi
    add $4, %r8
    jmp 1b
2:
    mov %r11d, (%rsi)
    inc %rdx
    add $4, %rsi
    add $4, %r8
    jmp 1b
3:
    add $4, %r8
    jmp 1b

end:
    mov %rdi, 32(%rsp)
    mov %rcx, 24(%rsp)

    mov %r10d, (%rdi)
    add $4, %rdi

    mov %rdi, 16(%rsp)
    mov %rdx, 8(%rsp)

    mov $rightarray, %rsi
    cmp $0, %rdx
    jle 5f
4:
    mov (%rsi), %r10d
    mov %r10d, (%rdi)
    add $4, %rdi
    add $4, %rsi
    dec %rdx
    jnz 4b
5:
    mov 56(%rsp), %rdi
    mov 32(%rsp), %rsi
    mov 24(%rsp), %rdx
    call quicksort

    mov 16(%rsp), %rdi
    mov 48(%rsp), %rsi
    mov 8(%rsp), %rdx
    call quicksort

    mov 40(%rsp), %rax

    leave
    ret
    
get_random_mod:
retry:
    rdrand %rax
    jnc retry

    xor %rdx, %rdx
    div %rdi
    mov %rdx, %rax

    ret

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
    
