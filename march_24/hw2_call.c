#include <stdio.h>

int find_first_one(unsigned int x);

int main(void)
{
    unsigned int x;
    if (scanf("%u", &x) != 1) {
        return 1;
    }

    printf("%d\n", find_first_one(x));
    return 0;
}