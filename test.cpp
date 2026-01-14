#include <iostream>
using namespace std;

/**
 * C++ 引用传递 (Pass by Reference)
 * * 这里的 int &a 不是“取地址”，而是定义了一个“引用类型”。
 * 含义：a 就是传入变量的别名。
 * * 在函数内部，你完全不需要用 * 号，像操作普通 int 一样操作 a 和 b。
 * 编译器会在幕后自动处理地址和解引用的工作。
 */
void swap_cpp(int &a, int &b) {
    int temp = a; // 直接读 a (相当于读 main 里的 x)
    a = b;        // 直接写 a
    b = temp;     // 直接写 b
}

int main() {
    int x = 10;
    int y = 99;

    cout << "=== 初始状态 ===" << endl;
    cout << "x = " << x << ", y = " << y << endl << endl;

    // === 调用方式 ===
    // 注意：这里不需要写 swap_cpp(&x, &y)
    // 直接传 x 和 y 即可！C++ 会自动识别并把 a 绑定到 x 上。
    swap_cpp(x, y);

    cout << "=== 调用 swap_cpp(x, y) 之后 ===" << endl;
    cout << "x = " << x << ", y = " << y << " (交换成功！)" << endl;

    return 0;
}