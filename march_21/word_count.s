# word_count.s
# divide the string into words and count the number of each word
# input: a string of words separated by spaces and symbols
# output: the most common word
# at&t, x86-64 assembly

.section .bss
    buffer:
        .skip 1000
    # 1000 ascii symbols buffer

    wordbuf:
        .skip 1000
    # 100 words * 10 alphabet per word buffer

.section .data
    wordcount:
        .rept 100
        .int 0
        .endr
    # int is 4 bytes

.section .text global _start
_start:
    # read input string
    mov $0, %rax
    mov $0, %rdi
    mov $buffer, %rsi
    mov $1000, %rdx
    syscall

    cmp $0, %rax
    jle exit

    # null terminate the string
    movb $0, (%rsi, %rax)
    
    # initial read cursor, word buffer cursor, and word count cursor
    mov $buffer, %r8
    mov $wordbuf, %r9
    mov $wordcount, %r10

    # initial word index
    mov $0, %r11

    # loop 1: while not end of string, extract words and count
