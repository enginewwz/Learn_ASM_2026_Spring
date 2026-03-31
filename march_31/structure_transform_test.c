typedef struct Complex_Struct
{
    int a;
    unsigned int b;
    char c;
    float d;
    double e;
    long long f;
    unsigned long long g;
    short h;
    unsigned short i;
    unsigned char j;
}
complex_struct;

complex_struct Complext_Struct_Transmit(complex_struct *input)
{
    return (complex_struct){
        .a = input->a,
        .b = input->b,
        .c = input->c,
        .d = input->d,
        .e = input->e,
        .f = input->f,
        .g = input->g,
        .h = input->h,
        .i = input->i,
        .j = input->j
    };
}

int main()
{
    complex_struct input = {
        .a = 1,
        .b = 2,
        .c = 'A',
        .d = 3.14f,
        .e = 2.71828,
        .f = 123456789012345LL,
        .g = 987654321098765ULL,
        .h = 42,
        .i = 65535,
        .j = 'Z'
    };

    complex_struct output = Complext_Struct_Transmit(&input);

    return 0;
}