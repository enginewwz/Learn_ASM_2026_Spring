# convert uint binary to dec ascii string and print it
# mips o32
.section .text
.globl cbtd
.type cbtd, @function
cbtd:
    # a0: uint binary
    addiu $sp, $sp, -16     # allocate stack space
    # leaf function, no need to save $ra or $s registers

    li $t0, 10
    move $t1, $a0

    addiu $t2, $sp, 11
    li $t4, '\n'
    sb $t4, 0($t2)
    addiu $t2, $t2, -1
    li $t3, 1
    beq $t1, $0, zero_case
    nop
loop:
    beq $t1, $0, print
    nop
    
    divu $t1, $t0

    mfhi $t4
    addiu $t4, $t4, 48
    sb $t4, 0($t2)

    mflo $t1
    addiu $t2, $t2, -1
    addiu $t3, $t3, 1

    j loop
    nop
zero_case:
    li $t4, '0'
    sb $t4, 0($t2)
    addiu $t2, $t2, -1
    addiu $t3, $t3, 1
print:
    addiu $t2, $t2, 1       # move to start of string
    li $v0, 4004
    li $a0, 1
    move $a1, $t2
    move $a2, $t3
    syscall

    addiu $sp, $sp, 16     # restore stack
    jr $ra
    nop 
