# convert 32-bit int to Hex string and print it

.section .text

.global cltw
.type cltw, @function

cltw:
    push %rbp
    mov %rsp, %rbp
    sub $16, %rsp

    test %edi, %edi
    jns not_signed

    inc %rcx
    movb $'-', (%rsp)
    movb $'0', 1(%rsp)
    movb $'x', 2(%rsp)
    
    mov $3, %r8
    neg %edi

    jmp 0f

not_signed:
    movb $'0', (%rsp)
    movb $'x', 1(%rsp)
    mov $2, %r8
0:
    lea (%rsp, %r8) ,%r9
    mov $1, %r10    # front zero flag
1:
    xor %edx, %edx
    test %edi, %edi
    jz print_data
    shld $4, %edi, %edx
    shl $4, %edi

    test %r10, %r10
    jz 4f

    test %edx, %edx
    jz 1b
    dec %r10
4:
    addb $'0', %dl
    cmpb $'9', %dl
    jbe 2f

    addb $39, %dl
2:
    mov %dl, (%r9)
3:
    inc %r8
    inc %r9
    jmp 1b

print_data:
    test %r10, %r10
    jz 5f

    inc %r8
    movb $'0', (%r9)
    inc %r9
5:
    movb $'\n', (%r9)
    inc %r8
    mov $1, %rax
    mov $1, %rdi
    mov %rsp, %rsi
    mov %r8, %rdx
    syscall

    leave
    ret

.section .note.GNU-stack,"",@progbits

    


