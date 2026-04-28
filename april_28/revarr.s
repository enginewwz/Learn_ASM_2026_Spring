# reverse an array
# mips o32
.section .text
.globl revarr
.type revarr, @function
revarr:
    # a0: array address
    # a1: lenth
    # leaf function
    move $t0, $a0
    blez $a1, exit
    nop

    addiu $t1, $a1, -1
    sll $t1, $t1, 2
    addu $t1, $t1, $t0
loop:
    sltu $t4, $t0, $t1
    beq $t4, $0, exit
    nop
    
    lw $t2, 0($t0)
    lw $t3, 0($t1)
    sw $t2, 0($t1)
    sw $t3, 0($t0)

    addiu $t0, $t0, 4
    addiu $t1, $t1, -4
    
    j loop
    nop
exit:
    jr $ra
    nop    
