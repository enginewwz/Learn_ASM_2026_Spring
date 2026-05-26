// Implement a more efficient version of memset
#define K sizeof(unsigned long)
#include <stddef.h>
#include <stdint.h>

void *memset_practise(void *s, int c, size_t n)
{
    unsigned char chr = (unsigned char) c;
    unsigned char *schar = s; 

    if (n < K)
    {
        while (n)
        {
            *schar++ = chr;
            n--;
        }
        return s;
    }

    // config front
    while (((uintptr_t)schar % K != 0) && n > 0)
    {
        *schar++ = chr;
        n--;
    }

    // def unsigned long element
    unsigned long long_cpy = (unsigned long) chr;
    for (size_t i = 1; i < K; i <<= 1)
    {
        long_cpy |= (long_cpy << (i << 3));
    }

    // prevent strict-aliasing rule
    typedef unsigned long __attribute__((__may_alias__)) alias_ulong;
    alias_ulong *slong = (alias_ulong *)schar;

    // copy body
    size_t step = 4 * K;
    while (n >= step)
    {
        slong[0] = long_cpy;
        slong[1] = long_cpy;
        slong[2] = long_cpy;
        slong[3] = long_cpy;
        slong += 4;
        n -= step;
    }

    // copy tail
    while (n >= K)
    {
        *slong++ = long_cpy;
        n -= K;
    }

    schar = (unsigned char *)slong;
    while (n)
    {
        *schar++ = chr;
        n--;
    }

    return s;
}