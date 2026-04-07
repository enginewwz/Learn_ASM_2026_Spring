.section .text

.global fib
.type fib, @function

fib:
    cmp $0, %edi
    jg fib_positive
    mov $0, %eax
    ret

fib_positive: 
    cmp $1, %edi
    jg fib_recursive
    mov $1, %eax
    ret

fib_recursive:
    push %rbp
    mov %rsp, %rbp
    sub $2, %edi
    push %rdi
    sub $8, %rsp

    inc %edi
    call fib

    mov %rax, (%rsp)
    mov 8(%rsp), %edi
    call fib

    add (%rsp), %eax
    leave
    ret

.section .note.GNU-stack,"",@progbits
