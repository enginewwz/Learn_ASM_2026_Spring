.section .text
.global find_first_one
.type find_first_one, @function

# int find_first_one(unsigned int x)
# Return the index (0-31) of the first 1 bit when scanning from MSB to LSB.
# Return -1 if x has no set bit.
find_first_one:
    mov %edi, %eax
    xor %ecx, %ecx

1:
    cmp $32, %ecx
    je not_found
    shl $1, %eax
    jc found
    inc %ecx
    jmp 1b

found:
    mov %ecx, %eax
    ret

not_found:
    mov $-1, %eax
    ret

.size find_first_one, .-find_first_one
