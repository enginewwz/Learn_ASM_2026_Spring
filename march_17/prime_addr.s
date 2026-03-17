# prime_addr.s
# sum up prime between 1 ~ 1000
.section .data
        primechecker:
                .rept 1000
                .byte 0 # 0 means prime, 1 means not prime
                .endr
.section .text
.global _start
_start:
        # initial primechecker
        movl $2, %eax
        # initial loop counter
        movl $998, %ecx
        # initial sum
        movl $0, %edx
1:
        # mark all multiples as not prime
        mov $primechecker, %ebx
        sub $1, %ebx
        add %eax, %ebx
        cmp $0, (%ebx)
        jne 3f
        # do not jump if is prime then add it to sum
        add %eax, %edx
2:
        add %eax, %ebx
        cmp $1000, %ebx
        jge 3f
        # mark as not prime
        movb $1, (%ebx)
        jmp 2b
3:
        # loop counter - 1
        add $1, %eax
        loop 1b

        # syscall: write(1, %edx, 4)
        mov $1, %eax
        mov $1, %ebx
        mov %edx, %ecx
        mov $4, %edx
        syscall

        # syscall: exit(0)
        mov $60, %eax
        mov $0, %ebx
        syscall

