#include <stdio.h>

/**
 * 函数功能：计算并打印长方形的面积和周长
 * 参数：
 * - w: 宽度 (float)
 * - h: 高度 (float)
 * 说明：这是“值传递”，函数内部修改 w 或 h 不会影响 main 里的变量。
 */
void printRectangleStats(float w, float h) {
    float area = w * h;
    float perimeter = 2 * (w + h);

    printf("\n--- 计算结果 ---\n");
    printf("宽度: %.2f\n", w);
    printf("高度: %.2f\n", h);
    printf("面积: %.2f\n", area);
    printf("周长: %.2f\n", perimeter);
}

int main() {
    float width, height;

    printf("请输入长方形的宽度: ");
    // scanf 需要变量的地址来存入数据，所以用 &
    if (scanf("%f", &width) != 1) return 1; 

    printf("请输入长方形的高度: ");
    if (scanf("%f", &height) != 1) return 1;

    // 调用函数，将 width 和 height 的“副本”传给函数
    printRectangleStats(width, height);

    return 0;
}