#include <stdio.h>

/* * 错误示范：按值传递 (Pass by Value)
 * 这里接收的是 x 和 y 的副本。
 * 交换它们只会改变函数内部的副本，函数结束后副本被销毁。
 */
void swap_wrong(int a, int b) {
    int temp = a;
    a = b;
    b = temp;
    printf("  [swap_wrong 内部] 交换后: a = %d, b = %d (这些是副本)\n", a, b);
}

/* * 正确示范：按指针传递 (Pass by Pointer)
 * 这里接收的是 x 和 y 的地址（指针）。
 * 通过解引用 (*pa, *pb) 直接修改地址指向的内存。
 */
void swap_correct(int *pa, int *pb) {
    int temp = *pa; // 取出 pa 指向的值存入 temp
    *pa = *pb;      // 把 pb 指向的值 赋给 pa 指向的位置
    *pb = temp;     // 把 temp 的值 赋给 pb 指向的位置
}

int main() {
    int x = 10;
    int y = 99;

    printf("=== 初始状态 ===\n");
    printf("x = %d, y = %d\n\n", x, y);

    // 1. 测试错误的方法
    printf("=== 1. 调用 swap_wrong(x, y) ===\n");
    swap_wrong(x, y);
    printf("调用后检查: x = %d, y = %d (没变！)\n\n", x, y);

    // 2. 测试正确的方法
    // 注意：我们要把 x 和 y 的地址 (&x, &y) 传进去
    printf("=== 2. 调用 swap_correct(&x, &y) ===\n");
    swap_correct(&x, &y);
    printf("调用后检查: x = %d, y = %d (变了！)\n", x, y);

    return 0;
}