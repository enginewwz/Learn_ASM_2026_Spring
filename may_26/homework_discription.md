source: CSAPP chapter 5 homework 5.17

The library function memset has the following prototype:

```c
void *memset(void *s, int c, size_t n);
``` 

This function fills n bytes of the memory area starting at s with copies of the loworder byte of c. For example, it can be used to zero out a region of memory by giving argument 0 for c, but other values are possible.  
The following is a straightforward implementation of memset:

```c
/* Basic implementation of memset */
void *basic_memset(void *s, int c, size_t n)
{
    size_t cnt = 0;
    unsigned char *schar = s;
    while (cnt < n) {
        *schar++ = (unsigned char) c;
        cnt++;
    }
    return s;
}
```

Implement a more efficient version of the function by using a word of data type unsigned long to pack eight copies of c, and then step through the region using word-level writes. You might find it helpful to do additional loop unrolling as well. On our reference machine, we were able to reduce the CPE from 1.00 for the straightforward implementation to 0.127. That is, the program is able to write 8 bytes every clock cycle.  
Here are some additional guidelines. To ensure portability, let K denote the value of sizeof(unsigned long) for the machine on which you run your program.
1. You may not call any library functions.
2. Your code should work for arbitrary values of n, including when it is not a multiple of K. You can do this in a manner similar to the way we finish the last few iterations with loop unrolling.
3. You should write your code so that it will compile and run correctly on any machine regardless of the value of K. Make use of the operation sizeof to do this.
4. On some machines, unaligned writes can be much slower than aligned ones. (On some non-x86 machines, they can even cause segmentation faults.) Write your code so that it starts with byte-level writes until the destination address is a multiple of K, then do word-level writes, and then (if necessary) finish with byte-level writes.
5. Beware of the case where cnt is small enough that the upper bounds on some of the loops become negative. With expressions involving the sizeof operator, the testing may be performed with unsigned arithmetic. (See Section 2.2.8 and Problem 2.72.)