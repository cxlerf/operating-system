#include <stdio.h>

int main()
{
    int arr[5] = {1, 2, 3, 4, 5};
    int *p = arr;

    printf("sizeof(arr) = %zu (数组的总字节数)\n", sizeof(arr));     // 5 * 4 = 20
    printf("sizeof(p)   = %zu (指针变量本身的字节数)\n", sizeof(p)); // 64位系统下通常是 8
    printf(" p    = %p,  &p    = %p\n", p, &p);
    printf(" arr  = %p,  &arr  = %p\n", arr, &arr);

    return 0;
}