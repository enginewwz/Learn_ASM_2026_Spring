#include <stdio.h>
#define Y_Initial 1.0
#define Tolerance 0.00001

int main()
{
    double x, y, y_prev;
    printf("Enter a number: ");
    scanf("%lf", &x);

    y = Y_Initial;
    do {
        y_prev = y;
        y = (y + x / y) / 2.0; // Newton's method formula
    } while (y - y_prev > Tolerance || y_prev - y > Tolerance); // Check for convergence

    printf("The square root of %.2lf is approximately %.5lf\n", x, y);
    return 0;
}