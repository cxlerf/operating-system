from collections import Counter

#在这里输入你的数据，用空格隔开即可
str1 = "11 22 33 44 55"
str2 = "11 22 33 44 66 66"

# 数据处理
list1 = str1.split()
list2 = str2.split()

# 1. 找组内重复
dup1 = [item for item, count in Counter(list1).items() if count > 1]
dup2 = [item for item, count in Counter(list2).items() if count > 1]

# 2. 找两组不同 (使用集合set，忽略顺序)
set1 = set(list1)
set2 = set(list2)

unique_in_1 = set1 - set2 # 在1里有，2里没有
unique_in_2 = set2 - set1 # 在2里有，1里没有

# 3. 输出结果
print("-" * 30)
print(f"第一组数据: {list1}")
print(f"第二组数据: {list2}")
print("-" * 30)

if dup1:
    print(f"【第一组内重复】: {', '.join(dup1)}")
else:
    print("【第一组】无重复")

if dup2:
    print(f"【第二组内重复】: {', '.join(dup2)}")
else:
    print("【第二组】无重复")

print("-" * 30)
print(f"【第一组独有】(第二组没这数): {unique_in_1 if unique_in_1 else '无'}")
print(f"【第二组独有】(第一组没这数): {unique_in_2 if unique_in_2 else '无'}")