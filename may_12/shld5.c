/* original code:
    unsigned int shld5(unsigned int a, unsigned int b)
    {
        unsigned int result;
        result = (a << 5) | (b >> (32 - 5));
        return result;
    }
*/

// convert to inline assembly code
unsigned int shld5(unsigned int a, unsigned int b)
{
    unsigned int result;
    asm (
        "shld %3, %2, %0"
        : "=r" (result)
        : "0" (a), "r" (b), "i" (5)
        : "cc"  // flag register is modified
    );
    return result;
}