# insert sort char

.section .data
    testdata:
        .byte 'A', '0', 'z', 'P', '8', 'r', 'Z', '2', 'f', 'H'
.section .text
.global _start
_start:
    push %rbp
    mov %rsp, %rbp
    and $-16, %rsp
    # 16bits aligen rsp

    sub $32, %rsp
    movq $testdata, 24(%rsp) # string addr
    movq $10, 16(%rsp)       # n

    mov 24(%rsp), %rdi
    mov 16(%rsp), %rsi
    
    call insert_sort

    mov $1, %rdi
    mov 24(%rsp), %rsi
    mov 16(%rsp), %rdx

    call as_puts

    mov $0, %rdi
    call as_exit


# func 1
.global insert_sort
.type insert_sort, @function
insert_sort:

    # string start pos at %rdi
    # end pos at %rcx

    lea (%rdi, %rsi, 1), %rcx

    # outer loop pointer at %rax

    mov %rdi, %rax
1:
    inc %rax
    cmp %rax, %rcx
    je sort_exit

    # inner loop pointer at %rdx

    mov %rax, %rdx
    dec %rdx

    mov (%rax), %r8b
2:
    cmp %rdi, %rdx
    jl 4f

    mov (%rdx), %r9b
    cmp %r8b, %r9b
    jle 3f
    movb %r9b, 1(%rdx)
    dec %rdx
    jmp 2b
3:
    movb %r8b, 1(%rdx)
    jmp 1b
4:
    movb %r8b, 1(%rdx)
    jmp 1b

sort_exit:
    ret


# func 2
.global as_puts
.type as_puts, @function
as_puts:
    mov $1, %rax
    syscall
    ret

.global as_exit
.type as_exit, @function
as_exit:
    mov $60, %rax
    syscall

