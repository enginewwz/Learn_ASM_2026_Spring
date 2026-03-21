# word_count.s
# divide the string into words and count the number of each word
# input: a string of words separated by spaces and symbols
# warning: need to be no more than 1000 bytes totally, no more than 10 alphabets per word, and no more than 100 different words
# output: the most common word
# at&t, x86-64 assembly

.section .bss
    buffer:
        .skip 1000
    # 1000 ascii symbols buffer

    wordbuf:
        .skip 1000
    # 100 words * 10 alphabet per word buffer

    wordcount:
        .skip 100
    # 1 byte for each word count

.section .data
    cmpbuf:
        .rept 10
        .ascii " "
        .endr
    # one buffer for comparison, initialized with space 

.section .text
.global _start
_start:
    # read input string
    mov $0, %rax
    mov $0, %rdi
    mov $buffer, %rsi
    mov $999, %rdx
    syscall

    cmpq $0, %rax
    jle exit

    # null terminate the string
    movb $0, (%rsi, %rax)

    # initial read cursor, word buffer cursor, word count cursor, comparison buffer cursor
    mov $buffer, %r8
    mov $wordbuf, %r9
    mov $wordcount, %r10
    mov $cmpbuf, %r13

    # initial current top of word buffer
    mov $wordbuf, %r11

    # initial inword alphabet counter
    mov $0, %r12

    # end-of-input flag for word_end_common: 0=normal delimiter, 1=EOF
    mov $0, %r15

    # loop 1: while not end of string, extract words and count
buffer_loop:
    movb (%r8), %al
    # jump out when spotting \0
    cmpb $0, %al
    jne check_char
    cmp $0, %r12
    jne word_end_eof
    jmp print_result

check_char:
    
    # check if alphabet or not
    cmpb $'A', %al
    jl word_end
    cmpb $'z', %al
    jg word_end
    cmpb $'Z', %al
    jle accept_char
    cmpb $'a', %al
    jge accept_char
    jmp word_end

accept_char:
    # more than 10 alphabet in a word, spot it as error
    cmp $10, %r12
    je exit
    # read the character into word buffer
    movb %al, (%r13)
    inc %r13
    inc %r12
    inc %r8
    jmp buffer_loop

word_end:
    # delimiter consumed, move to next input char
    inc %r8
    jmp word_end_common

word_end_eof:
    mov $1, %r15

word_end_common:
    # ifno word read, just skip
    cmp $0, %r12
    je buffer_loop

    # reset dictionary scan cursors for this word lookup
    mov $wordbuf, %r9
    mov $wordcount, %r10

    # compare every alphabet in word buffer with comparison buffer, if same, add 1 to same word count
compare_find_word_loop:
    cmp %r9, %r11
    je new_word
    jmp compare_word

    # new word found, add it to the wordbuf and set count to 1
new_word:
    # guard dictionary capacity: at most 100 words * 10 bytes
    cmp $wordbuf+1000, %r11
    jae exit

    mov $cmpbuf, %r13
    mov $0, %r12

    # copy the word to wordbuf
1:
    cmp $10, %r12
    je 2f
    movb (%r13), %al
    movb %al, (%r9)
    inc %r13
    inc %r9
    inc %r12
    jmp 1b

2:    
    # new word found and copied, set count to 1 and reset word count cursor
    movb $1, (%r10)
    mov $wordcount, %r10

    # clear the cmpbuf
    mov $cmpbuf, %r13
    mov $0, %r12
3:
    cmp $10, %r12
    je 4f
    movb $' ', (%r13)
    inc %r13
    inc %r12
    jmp 3b

4:
    # increase the top of word buffer cursor, reset inword alphabet counter, reset comparison buffer cursor, and jump back to read next word
    add $10, %r11
    mov $0, %r12
    mov $cmpbuf, %r13
    mov $wordbuf, %r9
    cmp $0, %r15
    jne print_result
    jmp buffer_loop

compare_word:
    # compare the word in wordbuf with the word in cmpbuf
    mov $0, %r12
    mov $cmpbuf, %r13

5:
    cmp $10, %r12
    je 6f
    movb (%r13), %al
    cmpb %al, (%r9)
    jne 7f
    inc %r13
    inc %r9
    inc %r12
    jmp 5b

6:
    # same word found, add 1 to the same word count
    movb (%r10), %al
    inc %al
    movb %al, (%r10)

    # clear the cmpbuf
    mov $cmpbuf, %r13
    mov $0, %r12
8:
    cmp $10, %r12
    je 9f
    movb $' ', (%r13)
    inc %r13
    inc %r12
    jmp 8b

9:
    # reset word buffer cursor, comparison buffer cursor, and inword alphabet counter
    mov $wordbuf, %r9
    mov $cmpbuf, %r13
    mov $wordcount, %r10
    mov $0, %r12

    # jump back to read next word
    cmp $0, %r15
    jne print_result
    jmp buffer_loop

7:
    # same word not found, jump back to compare next word
    sub %r12, %r9
    add $10, %r9
    add $1, %r10
    jmp compare_find_word_loop

print_result:
    # no word collected, just exit
    cmp $wordbuf, %r11
    je exit

    # loop: find the most common word
    # initial the most frequency: r8
    mov $0, %r8

    # the word cursor is the wordbuf cursor: r9, which is pre-initialized
    # the top of wordbuf cursor is the wordcount cursor: r11, which is pre-initialized
    # the word count cursor is the r10, which is pre-initialized

    # r13 is used to load the current top word address
    mov $wordbuf, %r13

    # r12 is used to print every word in the current top frequence word, that is needed and pre-initialized

find_most_common_word_loop:
    cmp %r9, %r11
    je print_most_common_word

    movb (%r10), %al
    cmpb %al, %r8b
    jae cur_update

    # update the most common word and the most common count
    movb %al, %r8b
    mov %r9, %r13

cur_update:
    # move to the next word and next word count
    add $10, %r9
    add $1, %r10
    jmp find_most_common_word_loop

print_most_common_word:
    # print the most common word without trailing spaces
    mov %r13, %rsi
    mov $0, %rdx

print_len_loop:
    cmp $10, %rdx
    je do_print
    movb (%rsi, %rdx), %al
    cmpb $' ', %al
    je do_print
    inc %rdx
    jmp print_len_loop

do_print:
    mov $1, %rax
    mov $1, %rdi
    syscall

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall
