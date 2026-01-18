#include <stdio.h>

/**
 * C 语言：通过指针传递 (Pass by Pointer)
 * * * 这里的 int *a 表示 a 是一个指向整数的“指针”。
 * * a 存储的是变量 x 的内存地址，而不是值本身。
 * * 在函数内部，必须使用 *a（解引用）来访问或修改该地址指向的数值。
 */
void swap_c(int *a, int *b) {
    int temp = *a; // 取出 a 指向的地址里的值 (x 的值)
    *a = *b;       // 将 b 指向的值赋给 a 指向的地址
    *b = temp;     // 将 temp 赋给 b 指向的地址
}

int main() {
    int x = 10;
    int y = 99;

    printf("=== 初始状态 ===\n");
    printf("x = %d, y = %d\n\n", x, y);

    // === 调用方式 ===
    // 注意：在 C 中，你必须显式地使用 & 符号来获取变量的地址
    // 这样指针 a 才会指向 x，指针 b 才会指向 y
    swap_c(&x, &y);

    printf("=== 调用 swap_c(&x, &y) 之后 ===\n");
    printf("x = %d, y = %d (交换成功！)\n", x, y);

    return 0;
}