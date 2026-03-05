.section .data
	a: .long 10
	b: .long 20
	c: .long 3
	d: .long 15

.section .text
.globl _start
_start:
	mov	a, %eax
	addl b, %eax

	imull c, %eax

	subl d, %eax	# %eax = (a+b)*c - d

	movl $1, %eax
	movl $0, %ebx
	int $0x80

