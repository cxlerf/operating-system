#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>

int main() {
    // 1. 定义一个“水桶”（缓冲区）
    // 这就是你熟悉的字符数组，用来暂存搬运的数据
    char buffer[1024]; 
    int bytes_read; // 用来记录每次搬运了多少“水”

    // 2. 打开源文件 a.txt (只读模式)
    // O_RDONLY: Read Only
    int fd_in = open("a.txt", O_RDONLY);
    if (fd_in < 0) {
        printf("打开 a.txt 失败！请确保文件存在。\n");
        exit(1);
    }

    // 3. 打开/创建目标文件 b.txt (写模式)
    // O_CREAT: 没有就创建
    // O_TRUNC: 有内容就清空
    // 0644: 设置文件权限（类似右键属性里的读写权限）
    int fd_out = open("b.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd_out < 0) {
        printf("创建 b.txt 失败！\n");
        close(fd_in); // 出错了别忘了关掉上一个文件
        exit(1);
    }

    // 4. 核心循环：开始搬运！
    // 逻辑：只要能读到数据 (bytes_read > 0)，就继续搬
    while ((bytes_read = read(fd_in, buffer, sizeof(buffer))) > 0) {
        // 读到了 bytes_read 这么多字节，马上写入到 b.txt
        write(fd_out, buffer, bytes_read);
    }

    // 5. 收工：关闭文件
    close(fd_in);
    close(fd_out);

    printf("复制完成！\n");
    return 0;
}