# prime_addr.s
# sum up prime between 1 ~ 1000
.section .data
        primechecker:
                .rept 1000
                .byte 0 # 0 means prime, 1 means not prime
                .endr
        buf: .asciz "     "
.section .text
.global _start
_start:
        # initial primechecker
        mov $2, %rax
        # initial primechecher end address
        mov $primechecker, %rdi
        add $1000, %rdi

        # initial loop counter
        mov $999, %rcx
        # initial sum
        mov $0, %rdx
1:
        # mark all multiples as not prime
        mov $primechecker, %rbx
        sub $1, %rbx
        add %rax, %rbx
        cmpb $0, (%rbx)
        jne 3f
        # do not jump if is prime then add it to sum
        add %rax, %rdx
2:
        add %rax, %rbx
        cmp %rdi, %rbx
        jge 3f
        # mark as not prime
        movb $1, (%rbx)
        jmp 2b
3:
        # loop counter - 1
        add $1, %rax
        loop 1b

        mov %rdx, %rax
        mov $10, %rbx
        mov $buf, %rdi
        add $4, %rdi
4:
        xor %rdx, %rdx
        div %rbx
        add $0x30, %dl
        movb %dl, (%rdi)
        dec %rdi
        cmpq $0, %rax
        jne 4b

        mov $1, %rax
        mov $1, %rdi
        mov $buf, %rsi
        mov $6, %rdx
        syscall

        # syscall: exit(0)
        mov $60, %rax
        mov $0, %rdi
        syscall

