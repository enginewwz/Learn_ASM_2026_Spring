# basicPrint.S
.section .data
    output: .ascii "University of CAS\n"

.section .text
.globl _start
_start:
/* output */
    movq $1, %rax
    movq $1, %rdi
    movq $output, %rsi
    movq $18, %rdx
    syscall

/* exit */
    movq $60, %rax
    movq $0, %rdi
    syscall
