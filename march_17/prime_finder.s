# prime_finder.s
# find prime between 1 ~ 1000
.section .data
        bytevar:
                .rept 32
                .byte 0
                .endr
                .byte 13, 10
.section .text
.global _start
_start:
        # initial prime counter
        mov $2, %rax
        # initial prime pointer
        mov $bytevar, %rbx
        # initial prime checker
        mov $bytevar, %rdx

        # initial loop counter
        mov $998, %rcx
        
1:
        
