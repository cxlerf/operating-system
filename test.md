Rotates this way
==沿此方向旋转==

HARD DISK DRIVES
==硬盘驱动器==

CRUX: HOW TO ACCOUNT FOR DISK ROTATION COSTS
==关键问题：如何计算磁盘旋转成本==

How can we implement an algorithm that more closely approximates SJF by taking both seek and rotation into account?
==我们如何实现一种算法，通过同时考虑寻道和旋转，从而更接近最短作业优先（SJF）？==

SPTF: Shortest Positioning Time First
==SPTF：最短定位时间优先==

Before discussing shortest positioning time first or SPTF scheduling (sometimes also called shortest access time first or SATF), which is the solution to our problem, let us make sure we understand the problem in more detail.
==在讨论作为解决方案的最短定位时间优先或 SPTF 调度（有时也称为最短访问时间优先或 SATF）之前，让我们确保更详细地理解这个问题。==

Figure 37.8 presents an example.
==图 37.8 展示了一个例子。==

In the example, the head is currently positioned over sector 30 on the inner track.
==在这个例子中，磁头当前位于内圈磁道的扇区 30 上方。==

The scheduler thus has to decide: should it schedule sector 16 (on the middle track) or sector 8 (on the outer track) for its next request.
==因此调度器必须决定：下一个请求应该调度扇区 16（在中间磁道）还是扇区 8（在外圈磁道）。==

So which should it service next?
==那么它应该接下来服务哪一个呢？==

The answer, of course, is "it depends".
==答案当然是“视情况而定”。==

In engineering, it turns out "it depends" is almost always the answer, reflecting that trade-offs are part of the life of the engineer;
==在工程学中，事实证明“视情况而定”几乎总是答案，这反映了权衡取舍是工程师生活的一部分；==

such maxims are also good in a pinch, e.g., when you don't know an answer to your boss's question, you might want to try this gem.
==这种格言在紧要关头也很好用，例如，当你不知道老板问题的答案时，你可能想试试这个锦囊妙计。==

However, it is almost always better to know why it depends, which is what we discuss here.
==然而，知道“为什么要视情况而定”几乎总是更好的，这正是我们要在这里讨论的。==

What it depends on here is the relative time of seeking as compared to rotation.
==这里取决于寻道时间与旋转时间的相对大小。==

If, in our example, seek time is much higher than rotational delay, then SSTF (and variants) are just fine.
==如果在这个例子中，寻道时间远高于旋转延迟，那么 SSTF（及其变体）就很好。==

However, imagine if seek is quite a bit faster than rotation.
==然而，想象一下如果寻道比旋转快得多。==

Then, in our example, it would make more sense to seek further to service request 8 on the outer track than it would to perform the shorter seek to the middle track to service 16, which has to rotate all the way around before passing under the disk head.
==那么，在我们的例子中，寻道至更远的外圈磁道去服务请求 8，比执行较短的寻道去中间磁道服务请求 16 更有意义，因为后者在经过磁头下方之前必须旋转一整圈。==

Figure 37.8: SSTF: Sometimes Not Good Enough
==图 37.8：SSTF：有时还不够好==

TIP: IT ALWAYS DEPENDS (LIVNY'S LAW)
==提示：永远视情况而定（LIVNY 定律）==

Almost any question can be answered with "it depends", as our colleague Miron Livny always says.
==正如我们的同事 Miron Livny 常说的那样，几乎任何问题都可以用“视情况而定”来回答。==

However, use with caution, as if you answer too many questions this way, people will stop asking you questions altogether.
==不过，使用时要小心，因为如果你用这种方式回答太多问题，人们就会完全不再问你问题了。==

For example, somebody asks: "want to go to lunch?"
==例如，有人问：“想去吃午饭吗？”==

You reply: "it depends, are you coming along?"
==你回答：“视情况而定，你也去吗？”==

On modern drives, as we saw above, both seek and rotation are roughly equivalent (depending, of course, on the exact requests), and thus SPTF is useful and improves performance.
==在现代驱动器上，正如我们上面所看到的，寻道和旋转大致相当（当然取决于具体的请求），因此 SPTF 是有用的并且可以提高性能。==

However, it is even more difficult to implement in an OS, which generally does not have a good idea where track boundaries are or where the disk head currently is (in a rotational sense).
==然而，在操作系统中实现它更加困难，因为操作系统通常不太清楚磁道边界在哪里，或者磁头当前在哪里（在旋转意义上）。==

Thus, SPTF is usually performed inside a drive, described below.
==因此，SPTF 通常在驱动器内部执行，如下所述。==

Other Scheduling Issues
==其他调度问题==

There are many other issues we do not discuss in this brief description of basic disk operation, scheduling, and related topics.
==在这个关于基本磁盘操作、调度和相关主题的简要描述中，还有许多其他问题我们没有讨论。==

One such issue is this: where is disk scheduling performed on modern systems?
==其中一个问题是：现代系统的磁盘调度是在哪里执行的？==

In older systems, the operating system did all the scheduling;
==在旧系统中，操作系统负责所有的调度；==

after looking through the set of pending requests, the OS would pick the best one, and issue it to the disk.
==在浏览了一组未决请求后，操作系统会挑选最好的一个，并将其发送给磁盘。==

When that request completed, the next one would be chosen, and so forth.
==当该请求完成后，会选择下一个，依此类推。==

Disks were simpler then, and so was life.
==那时的磁盘比较简单，生活也是如此。==

In modern systems, disks can accommodate multiple outstanding requests, and have sophisticated internal schedulers themselves (which can implement SPTF accurately; inside the disk controller, all relevant details are available, including exact head position).
==在现代系统中，磁盘可以容纳多个未完成的请求，并且自身拥有复杂的内部调度器（它可以准确地实现 SPTF；在磁盘控制器内部，所有相关的细节都是可用的，包括精确的磁头位置）。==

Thus, the OS scheduler usually picks what it thinks the best few requests are (say 16) and issues them all to disk;
==因此，操作系统调度器通常会挑选它认为最好的几个请求（比如 16 个），并将它们全部发送给磁盘；==

the disk then uses its internal knowledge of head position and detailed track layout information to service said requests in the best possible (SPTF) order.
==然后，磁盘利用其内部的磁头位置知识和详细的磁道布局信息，以尽可能最好的顺序（SPTF）服务这些请求。==

Another important related task performed by disk schedulers is I/O merging.
==磁盘调度器执行的另一个重要的相关任务是 I/O 合并。==

For example, imagine a series of requests to read blocks 33, then 8, then 34, as in Figure 37.8.
==例如，想象一系列读取块 33，然后是 8，然后是 34 的请求，如图 37.8 所示。==

In this case, the scheduler should merge the requests for blocks 33 and 34 into a single two-block request;
==在这种情况下，调度器应该将块 33 和 34 的请求合并为一个单独的双块请求；==

any reordering that the scheduler does is performed upon the merged requests.
==调度器所做的任何重新排序都是针对合并后的请求执行的。==

Merging is particularly important at the OS level, as it reduces the number of requests sent to the disk and thus lowers overheads.
==合并在操作系统层面特别重要，因为它减少了发送到磁盘的请求数量，从而降低了开销。==

One final problem that modern schedulers address is this: how long should the system wait before issuing an  to disk?
==现代调度器解决的最后一个问题是：系统在向磁盘发出 I/O 请求之前应该等待多久？==

One might naively think that the disk, once it has even a single I/O, should immediately issue the request to the drive;
==人们可能会天真地认为，磁盘一旦有一个 I/O 请求，就应该立即向驱动器发出请求；==

this approach is called work-conserving, as the disk will never be idle if there are requests to serve.
==这种方法被称为工作守恒（work-conserving），因为如果有请求需要服务，磁盘将永远不会空闲。==

However, research on anticipatory disk scheduling has shown that sometimes it is better to wait for a bit [ID01], in what is called a non-work-conserving approach.
==然而，关于预期磁盘调度的研究表明，有时等待一会儿会更好 [ID01]，这被称为非工作守恒（non-work-conserving）方法。==

By waiting, a new and "better" request may arrive at the disk, and thus overall efficiency is increased.
==通过等待，一个新的且“更好”的请求可能会到达磁盘，从而提高整体效率。==

Of course, deciding when to wait, and for how long, can be tricky;
==当然，决定何时等待以及等待多久可能很棘手；==

see the research paper for details, or check out the Linux kernel implementation to see how such ideas are transitioned into practice (if you are the ambitious sort).
==详情请参阅研究论文，或者查看 Linux 内核的实现，看看这些想法是如何转化为实践的（如果你是有抱负的那类人）。==

37.6 Summary
==37.6 总结==

We have presented a summary of how disks work.
==我们已经总结了磁盘是如何工作的。==

The summary is actually a detailed functional model;
==这个总结实际上是一个详细的功能模型；==

it does not describe the amazing physics, electronics, and material science that goes into actual drive design.
==它没有描述实际驱动器设计中涉及的惊人的物理学、电子学和材料科学。==

For those interested in even more details of that nature, we suggest a different major (or perhaps minor);
==对于那些对这些细节感兴趣的人，我们建议选择不同的专业（或许是辅修）；==

for those that are happy with this model, good!
==对于那些对这个模型感到满意的人，很好！==

We can now proceed to using the model to build more interesting systems on top of these incredible devices.
==我们现在可以继续利用该模型，在这些不可思议的设备之上构建更有趣的系统。==

References
==参考文献==

[ADR03] "More Than an Interface: SCSI vs. ATA" by Dave Anderson, Jim Dykes, Erik Riedel.
==[ADR03] "More Than an Interface: SCSI vs. ATA" 作者：Dave Anderson, Jim Dykes, Erik Riedel。==

FAST '03, 2003. One of the best recent-ish references on how modern disk drives really work;
==FAST '03, 2003。关于现代磁盘驱动器真正如何工作的最佳近期参考文献之一；==

a must read for anyone interested in knowing more.
==任何有兴趣了解更多信息的人的必读之作。==

[CKR72] "Analysis of Scanning Policies for Reducing Disk Seek Times" E.G. Coffman, L.A. Klimko, B. Ryan
==[CKR72] "Analysis of Scanning Policies for Reducing Disk Seek Times" 作者：E.G. Coffman, L.A. Klimko, B. Ryan==

SIAM Journal of Computing, September 1972, Vol 1. No 3. Some of the early work in the field of disk scheduling.
==SIAM Journal of Computing, 1972 年 9 月, 第 1 卷第 3 期。磁盘调度领域的一些早期工作。==

[HK+17] "The Unwritten Contract of Solid State Drives" by Jun He, Sudarsun Kannan, Andrea C. Arpaci-Dusseau, Remzi H. Arpaci-Dusseau.
==[HK+17] "The Unwritten Contract of Solid State Drives" 作者：Jun He, Sudarsun Kannan, Andrea C. Arpaci-Dusseau, Remzi H. Arpaci-Dusseau。==

EuroSys '17, Belgrade, Serbia, April 2017. We take the idea of the unwritten contract, and extend it to SSDs.
==EuroSys '17，塞尔维亚贝尔格莱德，2017 年 4 月。我们采用了不成文契约的想法，并将其扩展到了 SSD。==

Using SSDs well seems as complicated as hard drives, and sometimes more so.
==用好 SSD 似乎和硬盘一样复杂，有时甚至更复杂。==

[ID01] "Anticipatory Scheduling: A Disk-scheduling Framework To Overcome Deceptive Idleness In Synchronous I/O" by Sitaram Iyer, Peter Druschel.
==[ID01] "Anticipatory Scheduling: A Disk-scheduling Framework To Overcome Deceptive Idleness In Synchronous I/O" 作者：Sitaram Iyer, Peter Druschel。==

SOSP '01, October 2001. A cool paper showing how waiting can improve disk scheduling: better requests may be on their way!
==SOSP '01，2001 年 10 月。一篇很酷的论文，展示了等待如何改善磁盘调度：更好的请求可能正在路上！==

[JW91] "Disk Scheduling Algorithms Based On Rotational Position" by D. Jacobson, J. Wilkes.
==[JW91] "Disk Scheduling Algorithms Based On Rotational Position" 作者：D. Jacobson, J. Wilkes。==

Technical Report HPL-CSP-91-7rev1, Hewlett-Packard, February 1991. A more modern take on disk scheduling.
==技术报告 HPL-CSP-91-7rev1，惠普，1991 年 2 月。对磁盘调度的更现代的看法。==

It remains a technical report (and not a published paper) because the authors were scooped by Seltzer et al. [SCO90].
==它仍然是一份技术报告（而不是已发表的论文），因为作者被 Seltzer 等人抢先了一步 [SCO90]。==

[RW92] "An Introduction to Disk Drive Modeling" by C. Ruemmler, J. Wilkes.
==[RW92] "An Introduction to Disk Drive Modeling" 作者：C. Ruemmler, J. Wilkes。==

IEEE Computer, 27:3, March 1994. A terrific introduction to the basics of disk operation.
==IEEE Computer, 27:3, 1994 年 3 月。对磁盘操作基础知识极好的介绍。==

Some pieces are out of date, but most of the basics remain.
==有些部分已经过时，但大部分基础知识仍然适用。==

[SCO90] "Disk Scheduling Revisited" by Margo Seltzer, Peter Chen, John Ousterhout.
==[SCO90] "Disk Scheduling Revisited" 作者：Margo Seltzer, Peter Chen, John Ousterhout。==

USENIX 1990. A paper that talks about how rotation matters too in the world of disk scheduling.
==USENIX 1990。一篇讨论在磁盘调度领域中旋转也很重要的论文。==

[SG04] "MEMS-based storage devices and standard disk interfaces: A square peg in a round hole?" Steven W. Schlosser, Gregory R. Ganger
==[SG04] "MEMS-based storage devices and standard disk interfaces: A square peg in a round hole?" 作者：Steven W. Schlosser, Gregory R. Ganger==

FAST '04, pp. 87-100, 2004. While the MEMS aspect of this paper hasn't yet made an impact, the discussion of the contract between file systems and disks is wonderful and a lasting contribution.
==FAST '04, pp. 87-100, 2004。虽然这篇论文中关于 MEMS 的方面尚未产生影响，但关于文件系统和磁盘之间契约的讨论非常精彩，是一个持久的贡献。==

We later build on this work to study the "Unwritten Contract of Solid State Drives" [HK+17]
==我们后来在这项工作的基础上研究了“固态硬盘的不成文契约” [HK+17]==

[S09a] "Barracuda ES.2 data sheet" by Seagate, Inc..
==[S09a] "Barracuda ES.2 data sheet" 作者：希捷公司（Seagate, Inc.）。==

Available at this website, at least, it was: [http://www.seagate.com/docs/pdf/datasheet/disc/ds_barracuda_es.pdf](http://www.seagate.com/docs/pdf/datasheet/disc/ds_barracuda_es.pdf).
==该网站提供下载，至少以前是：[http://www.seagate.com/docs/pdf/datasheet/disc/ds_barracuda_es.pdf](http://www.seagate.com/docs/pdf/datasheet/disc/ds_barracuda_es.pdf)。==

A data sheet; read at your own risk.
==一份数据表；阅读风险自负。==

Risk of what?
==什么风险？==

Boredom.
==无聊。==

[S09b] "Cheetah 15K.5" by Seagate, Inc..
==[S09b] "Cheetah 15K.5" 作者：希捷公司（Seagate, Inc.）。==

Available at this website, we're pretty sure it is: [http://www.seagate.com/docs/pdf/datasheet/disc/ds-cheetah-15k-5-us.pdf](http://www.seagate.com/docs/pdf/datasheet/disc/ds-cheetah-15k-5-us.pdf).
==该网站提供下载，我们很确定是：[http://www.seagate.com/docs/pdf/datasheet/disc/ds-cheetah-15k-5-us.pdf](http://www.seagate.com/docs/pdf/datasheet/disc/ds-cheetah-15k-5-us.pdf)。==

See above commentary on data sheets.
==参见上面关于数据表的评论。==

Homework (Simulation)
==作业（模拟）==

This homework uses disk.py to familiarize you with how a modern hard drive works.
==本作业使用 `disk.py` 来让你熟悉现代硬盘驱动器是如何工作的。==

It has a lot of different options, and unlike most of the other simulations, has a graphical animator to show you exactly what happens when the disk is in action.
==它有许多不同的选项，而且与大多数其他模拟不同，它有一个图形动画演示器，向你展示磁盘运行时究竟发生了什么。==

See the README for details.
==详情请参阅 README。==

1. Compute the seek, rotation, and transfer times for the following sets of requests: `-a 0`, `-a 6`, `-a 30`, `-a 7,30,8`, and finally `-a 10,11,12,13`.
==2. 计算以下几组请求的寻道、旋转和传输时间：`-a 0`，`-a 6`，`-a 30`，`-a 7,30,8`，最后是 `-a 10,11,12,13`。==
3. Do the same requests above, but change the seek rate to different values: `-S 2`, `-S 4`, `-S 8`, `-S 10`, `-S 40`, `-S 0.1`.
==4. 执行与上面相同的请求，但将寻道速率更改为不同的值：`-S 2`，`-S 4`，`-S 8`，`-S 10`，`-S 40`，`-S 0.1`。==

How do the times change?
==时间是如何变化的？==

3. Do the same requests above, but change the rotation rate: `-R 0.1`, `-R 0.5`, `-R 0.01`.
==4. 执行与上面相同的请求，但更改旋转速率：`-R 0.1`，`-R 0.5`，`-R 0.01`。==

How do the times change?
==时间是如何变化的？==

4. FIFO is not always best, e.g., with the request stream `-a 7,30,8`, what order should the requests be processed in?
==5. 先进先出（FIFO）并不总是最好的，例如，对于请求流 `-a 7,30,8`，应该按什么顺序处理请求？==

Run the shortest seek-time first (SSTF) scheduler (`-p SSTF`) on this workload;
==在此工作负载上运行最短寻道时间优先（SSTF）调度器（`-p SSTF`）；==

how long should it take (seek, rotation, transfer) for each request to be served?
==每个请求被服务需要多长时间（寻道、旋转、传输）？==

5. Now use the shortest access-time first (SATF) scheduler (`-p SATF`).
==6. 现在使用最短访问时间优先（SATF）调度器（`-p SATF`）。==

Does it make any difference for `-a 7,30,8` workload?
==这对于 `-a 7,30,8` 工作负载有什么区别吗？==

Find a set of requests where SATF outperforms SSTF;
==找到一组 SATF 优于 SSTF 的请求；==

more generally, when is SATF better than SSTF?
==更一般地讲，SATF 什么时候比 SSTF 更好？==

6. Here is a request stream to try: `-a 10,11,12,13`.
==7. 这里有一个可以尝试的请求流：`-a 10,11,12,13`。==

What goes poorly when it runs?
==运行时什么地方表现得很差？==

Try adding track skew to address this problem (`-o skew`).
==尝试添加磁道倾斜（track skew）来解决这个问题（`-o skew`）。==

Given the default seek rate, what should the skew be to maximize performance?
==在给定默认寻道速率的情况下，倾斜度应该是多少才能使性能最大化？==

What about for different seek rates (e.g., `-S 2`, `-S 4`)?
==对于不同的寻道速率（例如 `-S 2`，`-S 4`）呢？==

In general, could you write a formula to figure out the skew?
==总的来说，你能写一个公式来计算倾斜度吗？==

7. Specify a disk with different density per zone, e.g., `-z 10,20,30`, which specifies the angular difference between blocks on the outer, middle, and inner tracks.
==8. 指定一个各区域密度不同的磁盘，例如 `-z 10,20,30`，它指定了外圈、中间和内圈磁道上块之间的角度差。==

Run some random requests (e.g., `-a -1 -A 5,-1,0`, which specifies that random requests should be used via the `-a -1` flag and that five requests ranging from 0 to the max be generated), and compute the seek, rotation, and transfer times.
==运行一些随机请求（例如 `-a -1 -A 5,-1,0`，它通过 `-a -1` 标志指定应使用随机请求，并生成 5 个范围从 0 到最大值的请求），并计算寻道、旋转和传输时间。==

Use different random seeds.
==使用不同的随机种子。==

What is the bandwidth (in sectors per unit time) on the outer, middle, and inner tracks?
==外圈、中间和内圈磁道的带宽（每单位时间的扇区数）是多少？==

8. A scheduling window determines how many requests the disk can examine at once.
==9. 调度窗口决定了磁盘一次可以检查多少个请求。==

Generate random workloads (e.g., `-A 1000,-1,0`, with different seeds) and see how long the SATF scheduler takes when the scheduling window is changed from 1 up to the number of requests.
==生成随机工作负载（例如 `-A 1000,-1,0`，使用不同的种子），并观察当调度窗口从 1 变为请求总数时，SATF 调度器需要多长时间。==

How big of a window is needed to maximize performance?
==多大的窗口才能使性能最大化？==

Hint: use the flag and don't turn on graphics (`-G`) to run these quickly.
==提示：使用该标志且不要打开图形界面（`-G`）以快速运行这些。==

When the scheduling window is set to 1, does it matter which policy you are using?
==当调度窗口设置为 1 时，使用哪种策略有关系吗？==

9. Create a series of requests to starve a particular request, assuming an SATF policy.
==10. 创建一系列请求来“饿死”某个特定请求，假设使用的是 SATF 策略。==

Given that sequence, how does it perform if you use a bounded SATF (BSATF) scheduling approach?
==给定该序列，如果你使用有界 SATF（BSATF）调度方法，它的表现如何？==

In this approach, you specify the scheduling window (e.g., `-w 4`);
==在这种方法中，你指定调度窗口（例如 `-w 4`）；==

the scheduler only moves onto the next window of requests when all requests in the current window have been serviced.
==调度器只有在当前窗口中的所有请求都得到服务后，才会移动到下一个请求窗口。==

Does this solve starvation?
==这解决了饥饿问题吗？==

How does it perform, as compared to SATF?
==与 SATF 相比，它的表现如何？==

In general, how should a disk make this trade-off between performance and starvation avoidance?
==一般来说，磁盘应该如何在性能和避免饥饿之间进行权衡？==

10. All the scheduling policies we have looked at thus far are greedy;
==11. 到目前为止，我们看到的所有调度策略都是贪婪的；==

they pick the next best option instead of looking for an optimal schedule.
==它们挑选下一个最佳选项，而不是寻找最佳时间表。==

Can you find a set of requests in which greedy is not optimal?
==你能找到一组贪婪算法并非最优的请求吗？==

Redundant Arrays of Inexpensive Disks (RAIDS)
==廉价磁盘冗余阵列（RAID）==

38
38

When we use a disk, we sometimes wish it to be faster;
==当我们要使用磁盘时，有时候希望它能更快；==

 operations are slow and thus can be the bottleneck for the entire system.
==I/O 操作很慢，因此可能成为整个系统的瓶颈。==

When we use a disk, we sometimes wish it to be larger;
==当我们要使用磁盘时，有时候希望它能更大；==

more and more data is being put online and thus our disks are getting fuller and fuller.
==越来越多的数据被放到网上，因此我们的磁盘变得越来越满。==

When we use a disk, we sometimes wish for it to be more reliable;
==当我们要使用磁盘时，有时候希望它更可靠；==

when a disk fails, if our data isn't backed up, all that valuable data is gone.
==当磁盘发生故障时，如果我们的数据没有备份，所有那些宝贵的数据都会丢失。==

CRUX: HOW TO MAKE A LARGE, FAST, RELIABLE DISK
==关键问题：如何构建大容量、快速且可靠的磁盘==

How can we make a large, fast, and reliable storage system?
==我们要如何构建一个大容量、快速且可靠的存储系统？==

What are the key techniques?
==关键技术有哪些？==

What are trade-offs between different approaches?
==不同方法之间的权衡是什么？==

In this chapter, we introduce the Redundant Array of Inexpensive Disks better known as RAID [P+88], a technique to use multiple disks in concert to build a faster, bigger, and more reliable disk system.
==在本章中，我们将介绍廉价磁盘冗余阵列，即人们熟知的 RAID [P+88]，这是一种协同使用多个磁盘来构建更快、更大、更可靠的磁盘系统的技术。==

The term was introduced in the late 1980s by a group of researchers at U.C. Berkeley (led by Professors David Patterson and Randy Katz and then student Garth Gibson);
==这个术语是 20 世纪 80 年代末由加州大学伯克利分校的一组研究人员（由 David Patterson 教授和 Randy Katz 教授以及当时的学生 Garth Gibson 领导）提出的；==

it was around this time that many different researchers simultaneously arrived upon the basic idea of using multiple disks to build a better storage system [BG88, K86, K88, PB86, SG86].
==大约在这个时候，许多不同的研究人员不约而同地得出了利用多个磁盘构建更好存储系统的基本想法 [BG88, K86, K88, PB86, SG86]。==

Externally, a RAID looks like a disk: a group of blocks one can read or write.
==在外部看来，RAID 就像一个磁盘：一组可以读写的块。==

Internally, the RAID is a complex beast, consisting of multiple disks, memory (both volatile and non-), and one or more processors to manage the system.
==在内部，RAID 是一个复杂的庞然大物，由多个磁盘、内存（易失性和非易失性）以及一个或多个用于管理系统的处理器组成。==

A hardware RAID is very much like a computer system, specialized for the task of managing a group of disks.
==硬件 RAID 非常像一个计算机系统，专门用于管理一组磁盘的任务。==

RAIDs offer a number of advantages over a single disk.
==RAID 相比单个磁盘提供了许多优势。==

One advantage is performance.
==一个优势是性能。==

Using multiple disks in parallel can greatly speed up  times.
==并行使用多个磁盘可以大大加快 I/O 速度。==

Another benefit is capacity.
==另一个好处是容量。==

Large data sets demand large disks.
==大数据集需要大磁盘。==

Finally, RAIDs can improve reliability;
==最后，RAID 可以提高可靠性；==

spreading data across multiple disks (without RAID techniques) makes the data vulnerable to the loss of a single disk;
==将数据分散到多个磁盘（不使用 RAID 技术）会使数据容易因单个磁盘丢失而受损；==

with some form of redundancy, RAIDs can tolerate the loss of a disk and keep operating as if nothing were wrong.
==通过某种形式的冗余，RAID 可以容忍磁盘丢失并像什么都没发生一样继续运行。==

TIP: TRANSPARENCY ENABLES DEPLOYMENT
==提示：透明性有助于部署==

When considering how to add new functionality to a system, one should always consider whether such functionality can be added transparently, in a way that demands no changes to the rest of the system.
==当考虑如何向系统添加新功能时，应始终考虑是否可以透明地添加该功能，即不需要更改系统的其余部分。==

Requiring a complete rewrite of the existing software (or radical hardware changes) lessens the chance of impact of an idea.
==要求完全重写现有软件（或彻底的硬件更改）会降低一个想法产生影响的机会。==

RAID is a perfect example, and certainly its transparency contributed to its success;
==RAID 是一个完美的例子，它的透明性无疑促成了它的成功；==

administrators could install a SCSI-based RAID storage array instead of a SCSI disk, and the rest of the system (host computer, OS, etc.) did not have to change one bit to start using it.
==管理员可以安装基于 SCSI 的 RAID 存储阵列来代替 SCSI 磁盘，而系统的其余部分（主机、操作系统等）完全不需要更改即可开始使用它。==

By solving this problem of deployment, RAID was made more successful from day one.
==通过解决这个部署问题，RAID 从第一天起就更加成功。==

Amazingly, RAIDs provide these advantages transparently to systems that use them, i.e., a RAID just looks like a big disk to the host system.
==令人惊讶的是，RAID 透明地向使用它们的系统提供这些优势，也就是说，RAID 在主机系统看来就像一个大磁盘。==

The beauty of transparency, of course, is that it enables one to simply replace a disk with a RAID and not change a single line of software;
==当然，透明之美在于它使人们可以简单地用 RAID 替换磁盘，而无需更改任何一行软件代码；==

the operating system and client applications continue to operate without modification.
==操作系统和客户端应用程序无需修改即可继续运行。==

In this manner, transparency greatly improves the deployability of RAID, enabling users and administrators to put a RAID to use without worries of software compatibility.
==通过这种方式，透明性极大地提高了 RAID 的可部署性，使用户和管理员能够使用 RAID 而无需担心软件兼容性。==

We now discuss some of the important aspects of RAIDs.
==我们现在讨论 RAID 的一些重要方面。==

We begin with the interface, fault model, and then discuss how one can evaluate a RAID design along three important axes: capacity, reliability, and performance.
==我们从接口、故障模型开始，然后讨论如何沿三个重要轴线评估 RAID 设计：容量、可靠性和性能。==

We then discuss a number of other issues that are important to RAID design and implementation.
==然后我们将讨论对 RAID 设计和实现很重要的其他一些问题。==

38.1 Interface And RAID Internals
==38.1 接口和 RAID 内部结构==

To a file system above, a RAID looks like a big, (hopefully) fast, and (hopefully) reliable disk.
==对于上层的文件系统来说，RAID 看起来像是一个大的、（希望是）快速的、（希望是）可靠的磁盘。==

Just as with a single disk, it presents itself as a linear array of blocks, each of which can be read or written by the file system (or other client).
==就像单个磁盘一样，它呈现为一个线性的块数组，文件系统（或其他客户端）可以读取或写入其中的每一个块。==

When a file system issues a logical I/O request to the RAID, the RAID internally must calculate which disk (or disks) to access in order to complete the request, and then issue one or more physical I/Os to do so.
==当文件系统向 RAID 发出逻辑 I/O 请求时，RAID 内部必须计算要访问哪个（或哪些）磁盘以完成请求，然后发出一各或多个物理 I/O 来执行此操作。==

The exact nature of these physical I/Os depends on the RAID level, as we will discuss in detail below.
==这些物理 I/O 的确切性质取决于 RAID 级别，我们将在下面详细讨论。==

However, as a simple example, consider a RAID that keeps two copies of each block (each one on a separate disk);
==然而，作为一个简单的例子，考虑一个保留每个块的两个副本的 RAID（每个副本在单独的磁盘上）；==

when writing to such a mirrored RAID system, the RAID will have to perform two physical I/Os for every one logical I/O it is issued.
==当向这样的镜像 RAID 系统写入时，RAID 必须为发出的每一个逻辑 I/O 执行两个物理 I/O。==

A RAID system is often built as a separate hardware box, with a standard connection (e.g., SCSI, or SATA) to a host.
==RAID 系统通常被构建为一个独立的硬件盒，通过标准连接（例如 SCSI 或 SATA）连接到主机。==

Internally, however, RAIDs are fairly complex, consisting of a microcontroller that runs firmware to direct the operation of the RAID, volatile memory such as DRAM to buffer data blocks as they are read and written, and in some cases, non-volatile memory to buffer writes safely and perhaps even specialized logic to perform parity calculations (useful in some RAID levels, as we will also see below).
==然而在内部，RAID 相当复杂，包括运行固件以指导 RAID 操作的微控制器，用于在读写时缓冲数据块的易失性内存（如 DRAM），在某些情况下，还有用于安全缓冲写入的非易失性内存，甚至可能有用于执行奇偶校验计算的专用逻辑（在某些 RAID 级别中有用，我们也将在下面看到）。==

At a high level, a RAID is very much a specialized computer system: it has a processor, memory, and disks;
==从高层来看，RAID 非常像一个专用的计算机系统：它有处理器、内存和磁盘；==

however, instead of running applications, it runs specialized software designed to operate the RAID.
==然而，它不是运行应用程序，而是运行专门设计用来操作 RAID 的软件。==

38.2 Fault Model
==38.2 故障模型==

To understand RAID and compare different approaches, we must have a fault model in mind.
==要理解 RAID 并比较不同的方法，我们必须在脑海中有一个故障模型。==

RAIDs are designed to detect and recover from certain kinds of disk faults;
==RAID 旨在检测并从某些类型的磁盘故障中恢复；==

thus, knowing exactly which faults to expect is critical in arriving upon a working design.
==因此，确切地知道预期会有哪些故障对于达成一个有效的设计至关重要。==

The first fault model we will assume is quite simple, and has been called the fail-stop fault model [S84].
==我们将假设的第一个故障模型非常简单，被称为故障-停止（fail-stop）故障模型 [S84]。==

In this model, a disk can be in exactly one of two states: working or failed.
==在这个模型中，磁盘只能处于两种状态之一：工作或故障。==

With a working disk, all blocks can be read or written.
==工作中的磁盘，所有块都可以读写。==

In contrast, when a disk has failed, we assume it is permanently lost.
==相反，当磁盘发生故障时，我们假设它永久丢失了。==

One critical aspect of the fail-stop model is what it assumes about fault detection.
==故障-停止模型的一个关键方面是它对故障检测的假设。==

Specifically, when a disk has failed, we assume that this is easily detected.
==具体来说，当磁盘发生故障时，我们假设这很容易被检测到。==

For example, in a RAID array, we would assume that the RAID controller hardware (or software) can immediately observe when a disk has failed.
==例如，在 RAID 阵列中，我们会假设 RAID 控制器硬件（或软件）可以立即观察到磁盘何时发生故障。==

Thus, for now, we do not have to worry about more complex "silent" failures such as disk corruption.
==因此，目前我们不必担心更复杂的“静默”故障，如磁盘损坏。==

We also do not have to worry about a single block becoming inaccessible upon an otherwise working disk (sometimes called a latent sector error).
==我们也不必担心在其他方面工作正常的磁盘上单个块变得无法访问（有时称为潜在扇区错误）。==

We will consider these more complex (and unfortunately, more realistic) disk faults later.
==我们稍后将考虑这些更复杂（不幸的是，也更现实）的磁盘故障。==

38.3 How To Evaluate A RAID
==38.3 如何评估 RAID==

As we will soon see, there are a number of different approaches to building a RAID.
==正如我们将很快看到的，构建 RAID 有许多不同的方法。==

Each of these approaches has different characteristics which are worth evaluating, in order to understand their strengths and weaknesses.
==每种方法都有值得评估的不同特征，以便了解它们的优缺点。==

Specifically, we will evaluate each RAID design along three axes.
==具体来说，我们将沿三个轴线评估每种 RAID 设计。==

The first axis is capacity;
==第一个轴线是容量；==

given a set of N disks each with B blocks, how much useful capacity is available to clients of the RAID?
==给定一组 N 个磁盘，每个磁盘有 B 个块，RAID 客户端可用的有用容量是多少？==

Without redundancy, the answer is ; in contrast, if we have a system that keeps two copies of each block (called mirroring), we obtain a useful capacity of .
==没有冗余时，答案是 ；相反，如果我们有一个保留每个块两个副本的系统（称为镜像），我们将获得  的有用容量。==

Different schemes (e.g., parity-based ones) tend to fall in between.
==不同的方案（例如基于奇偶校验的方案）往往介于两者之间。==

The second axis of evaluation is reliability.
==评估的第二个轴线是可靠性。==

How many disk faults can the given design tolerate?
==给定的设计可以容忍多少个磁盘故障？==

In alignment with our fault model, we assume only that an entire disk can fail;
==根据我们的故障模型，我们假设只有整个磁盘会发生故障；==

in later chapters (i.e., on data integrity), we'll think about how to handle more complex failure modes.
==在后面的章节（即关于数据完整性的章节）中，我们将思考如何处理更复杂的故障模式。==

Finally, the third axis is performance.
==最后，第三个轴线是性能。==

Performance is somewhat challenging to evaluate, because it depends heavily on the workload presented to the disk array.
==性能评估有些挑战性，因为它在很大程度上取决于提交给磁盘阵列的工作负载。==

Thus, before evaluating performance, we will first present a set of typical workloads that one should consider.
==因此，在评估性能之前，我们将首先提出一组应考虑的典型工作负载。==

We now consider three important RAID designs: RAID Level 0 (striping), RAID Level 1 (mirroring), and RAID Levels 4/5 (parity-based redundancy).
==我们现在考虑三种重要的 RAID 设计：RAID 0 级（条带化）、RAID 1 级（镜像）和 RAID 4/5 级（基于奇偶校验的冗余）。==

The naming of each of these designs as a "level" stems from the pioneering work of Patterson, Gibson, and Katz at Berkeley [P+88].
==将这些设计中的每一个命名为“级别”源于伯克利的 Patterson、Gibson 和 Katz 的开创性工作 [P+88]。==

38.4 RAID Level 0: Striping
==38.4 RAID 0 级：条带化==

The first RAID level is actually not a RAID level at all, in that there is no redundancy.
==第一个 RAID 级别实际上根本不是 RAID 级别，因为它没有冗余。==

However, RAID level 0, or striping as it is better known, serves as an excellent upper-bound on performance and capacity and thus is worth understanding.
==然而，RAID 0 级，或者更为人熟知的条带化，是性能和容量的极好上限，因此值得理解。==

The simplest form of striping will stripe blocks across the disks of the system as follows (assume here a 4-disk array):
==最简单的条带化形式将在系统的磁盘上条带化块，如下所示（这里假设是一个 4 磁盘阵列）：==

Figure 38.1: RAID-0: Simple Striping
==图 38.1：RAID-0：简单条带化==

From Figure 38.1, you get the basic idea: spread the blocks of the array across the disks in a round-robin fashion.
==从图 38.1 中，你得到了基本思路：以轮询方式将阵列的块分散到磁盘上。==

This approach is designed to extract the most parallelism from the array when requests are made for contiguous chunks of the array (as in a large, sequential read, for example).
==这种方法旨在当请求阵列的连续块时（例如在大型顺序读取中），从阵列中提取最大的并行性。==

We call the blocks in the same row a stripe;
==我们将同一行中的块称为一个条带；==

thus, blocks 0, 1, 2, and 3 are in the same stripe above.
==因此，上面的块 0、1、2 和 3 处于同一个条带中。==

In the example, we have made the simplifying assumption that only 1 block (each of say size 4KB) is placed on each disk before moving on to the next.
==在这个例子中，我们做了一个简化的假设，即在移至下一个磁盘之前，每个磁盘上只放置 1 个块（每个大小约为 4KB）。==

However, this arrangement need not be the case.
==然而，这种安排不一定是必须的。==

For example, we could arrange the blocks across disks as in Figure 38.2:
==例如，我们可以像图 38.2 那样在磁盘上排列块：==

Figure 38.2: Striping With A Bigger Chunk Size
==图 38.2：具有更大块大小的条带化==

In this example, we place two 4KB blocks on each disk before moving on to the next disk.
==在这个例子中，我们在移至下一个磁盘之前，在每个磁盘上放置两个 4KB 的块。==

Thus, the chunk size of this RAID array is 8KB, and a stripe thus consists of 4 chunks or 32KB of data.
==因此，这个 RAID 阵列的块大小是 8KB，一个条带因此由 4 个块或 32KB 数据组成。==

ASIDE: THE RAID MAPPING PROBLEM
==旁注：RAID 映射问题==

Before studying the capacity, reliability, and performance characteristics of the RAID, we first present an aside on what we call the mapping problem.
==在研究 RAID 的容量、可靠性和性能特征之前，我们首先插入一段关于我们所谓的映射问题的讨论。==

This problem arises in all RAID arrays;
==这个问题出现在所有的 RAID 阵列中；==

simply put, given a logical block to read or write, how does the RAID know exactly which physical disk and offset to access?
==简单地说，给定一个要读写的逻辑块，RAID 如何确切地知道要访问哪个物理磁盘和偏移量？==

For these simple RAID levels, we do not need much sophistication in order to correctly map logical blocks onto their physical locations.
==对于这些简单的 RAID 级别，我们不需要太复杂的技术就能正确地将逻辑块映射到它们的物理位置。==

Take the first striping example above (chunk size = 1 block = 4KB).
==以上面的第一个条带化示例为例（块大小 = 1 个块 = 4KB）。==

In this case, given a logical block address A, the RAID can easily compute the desired disk and offset with two simple equations:
==在这种情况下，给定逻辑块地址 A，RAID 可以用两个简单的方程轻松计算出所需的磁盘和偏移量：==

Disk = A % number_of_disks
==磁盘 = A % 磁盘数量==

Offset = A / number_of_disks
==偏移量 = A / 磁盘数量==

Note that these are all integer operations (e.g.,  not 1.33333...).
==注意这些都是整数运算（例如， 而不是 1.33333...）。==

Let's see how these equations work for a simple example.
==让我们看一个简单的例子，看看这些方程是如何工作的。==

Imagine in the first RAID above that a request arrives for block 14.
==想象在上面的第一个 RAID 中，来了一个对块 14 的请求。==

Given that there are 4 disks, this would mean that the disk we are interested in is (): disk 2.
==鉴于有 4 个磁盘，这意味着我们感兴趣的磁盘是 ()：磁盘 2。==

The exact block is calculated as (): block 3.
==具体的块计算为 ()：块 3。==

Thus, block 14 should be found on the fourth block (block 3, starting at 0) of the third disk (disk 2, starting at 0), which is exactly where it is.
==因此，块 14 应该位于第三个磁盘（磁盘 2，从 0 开始）的第四个块（块 3，从 0 开始）上，这正是它所在的位置。==

You can think about how these equations would be modified to support different chunk sizes.
==你可以思考一下如何修改这些方程以支持不同的块大小。==

Try it!
==试一试！==

It's not too hard.
==并不太难。==

Chunk Sizes
==块大小（Chunk Sizes）==

Chunk size mostly affects performance of the array.
==块大小主要影响阵列的性能。==

For example, a small chunk size implies that many files will get striped across many disks, thus increasing the parallelism of reads and writes to a single file;
==例如，较小的块大小意味着许多文件将被条带化到许多磁盘上，从而增加了对单个文件的读写并行性；==

however, the positioning time to access blocks across multiple disks increases, because the positioning time for the entire request is determined by the maximum of the positioning times of the requests across all drives.
==然而，跨多个磁盘访问块的定位时间会增加，因为整个请求的定位时间由所有驱动器上请求的定位时间的最大值决定。==

A big chunk size, on the other hand, reduces such intra-file parallelism, and thus relies on multiple concurrent requests to achieve high throughput.
==另一方面，大的块大小减少了这种文件内并行性，因此依赖于多个并发请求来实现高吞吐量。==

However, large chunk sizes reduce positioning time;
==然而，大的块大小减少了定位时间；==

if, for example, a single file fits within a chunk and thus is placed on a single disk, the positioning time incurred while accessing it will just be the positioning time of a single disk.
==例如，如果单个文件适合放入一个块中，从而被放置在单个磁盘上，那么访问它时产生的定位时间将仅仅是单个磁盘的定位时间。==

Thus, determining the "best" chunk size is hard to do, as it requires a great deal of knowledge about the workload presented to the disk system [CL95].
==因此，确定“最佳”块大小很难，因为它需要大量关于提交给磁盘系统的工作负载的知识 [CL95]。==

For the rest of this discussion, we will assume that the array uses a chunk size of a single block (4KB).
==在接下来的讨论中，我们将假设阵列使用单个块（4KB）的块大小。==

Most arrays use larger chunk sizes (e.g., 64 KB), but for the issues we discuss below, the exact chunk size does not matter;
==大多数阵列使用更大的块大小（例如 64 KB），但对于我们下面讨论的问题，确切的块大小并不重要；==

thus we use a single block for the sake of simplicity.
==因此为简单起见，我们使用单个块。==

Back To RAID-0 Analysis
==回到 RAID-0 分析==

Let us now evaluate the capacity, reliability, and performance of striping.
==现在让我们评估条带化的容量、可靠性和性能。==

From the perspective of capacity, it is perfect: given N disks each of size B blocks, striping delivers  blocks of useful capacity.
==从容量的角度来看，它是完美的：给定 N 个大小为 B 块的磁盘，条带化提供  块的有用容量。==

From the standpoint of reliability, striping is also perfect, but in the bad way: any disk failure will lead to data loss.
==从可靠性的角度来看，条带化也是完美的，但是是糟糕的那种：任何磁盘故障都会导致数据丢失。==

Finally, performance is excellent: all disks are utilized, often in parallel, to service user  requests.
==最后，性能非常好：所有磁盘都被利用，通常是并行地，来服务用户的 I/O 请求。==

Evaluating RAID Performance
==评估 RAID 性能==

In analyzing RAID performance, one can consider two different performance metrics.
==在分析 RAID 性能时，可以考虑两个不同的性能指标。==

The first is single-request latency.
==第一个是单请求延迟。==

Understanding the latency of a single  request to a RAID is useful as it reveals how much parallelism can exist during a single logical  operation.
==了解 RAID 单个 I/O 请求的延迟很有用，因为它揭示了在单个逻辑 I/O 操作期间可以存在多少并行性。==

The second is steady-state throughput of the RAID, i.e., the total bandwidth of many concurrent requests.
==第二个是 RAID 的稳态吞吐量，即许多并发请求的总带宽。==

Because RAIDs are often used in high-performance environments, the steady-state bandwidth is critical, and thus will be the main focus of our analyses.
==由于 RAID 通常用于高性能环境，因此稳态带宽至关重要，因此将成为我们分析的重点。==

To understand throughput in more detail, we need to put forth some workloads of interest.
==为了更详细地理解吞吐量，我们需要提出一些感兴趣的工作负载。==

We will assume, for this discussion, that there are two types of workloads: sequential and random.
==在这个讨论中，我们将假设有两种类型的工作负载：顺序的和随机的。==

With a sequential workload, we assume that requests to the array come in large contiguous chunks;
==对于顺序工作负载，我们假设对阵列的请求是以大的连续块形式出现的；==

for example, a request (or series of requests) that accesses 1 MB of data, starting at block  and ending at block , would be deemed sequential.
==例如，访问 1 MB 数据的请求（或一系列请求），从块  开始并在块  结束，将被视为顺序的。==

Sequential workloads are common in many environments (think of searching through a large file for a keyword), and thus are considered important.
==顺序工作负载在许多环境中都很常见（想想在大型文件中搜索关键字），因此被认为是重要的。==

For random workloads, we assume that each request is rather small, and that each request is to a different random location on disk.
==对于随机工作负载，我们假设每个请求都相当小，并且每个请求都指向磁盘上不同的随机位置。==

For example, a random stream of requests may first access 4KB at logical address 10, then at logical address 550,000, then at 20,100, and so forth.
==例如，随机请求流可能首先访问逻辑地址 10 处的 4KB，然后在逻辑地址 550,000 处，然后在 20,100 处，依此类推。==

Some important workloads, such as transactional workloads on a database management system (DBMS), exhibit this type of access pattern, and thus it is considered an important workload.
==一些重要的工作负载，如数据库管理系统（DBMS）上的事务性工作负载，表现出这种类型的访问模式，因此它被认为是一种重要的工作负载。==

Of course, real workloads are not so simple, and often have a mix of sequential and random-seeming components as well as behaviors in-between the two.
==当然，实际的工作负载并不是那么简单，通常混合了顺序和看似随机的成分，以及介于两者之间的行为。==

For simplicity, we just consider these two possibilities.
==为了简单起见，我们只考虑这两种可能性。==

As you can tell, sequential and random workloads will result in widely different performance characteristics from a disk.
==正如你所知，顺序和随机工作负载将导致磁盘产生截然不同的性能特征。==

With sequential access, a disk operates in its most efficient mode, spending little time seeking and waiting for rotation and most of its time transferring data.
==对于顺序访问，磁盘以其最高效的模式运行，花费很少的时间寻道和等待旋转，而大部分时间用于传输数据。==

With random access, just the opposite is true: most time is spent seeking and waiting for rotation and relatively little time is spent transferring data.
==对于随机访问，情况正好相反：大部分时间花在寻道和等待旋转上，相对较少的时间花在传输数据上。==

To capture this difference in our analysis, we will assume that a disk can transfer data at  under a sequential workload, and  when under a random workload.
==为了在我们的分析中捕捉这种差异，我们将假设磁盘在顺序工作负载下可以以  的速度传输数据，而在随机工作负载下以  的速度传输。==

In general, S is much greater than R (i.e., ).
==通常，S 远大于 R（即 ）。==

To make sure we understand this difference, let's do a simple exercise.
==为了确保我们理解这种差异，让我们做一个简单的练习。==

Specifically, let's calculate S and R given the following disk characteristics.
==具体来说，让我们根据以下磁盘特性计算 S 和 R。==

Assume a sequential transfer of size 10 MB on average, and a random transfer of 10 KB on average.
==假设平均顺序传输大小为 10 MB，平均随机传输大小为 10 KB。==

Also, assume the following disk characteristics:
==此外，假设以下磁盘特性：==

Average seek time: 7 ms
==平均寻道时间：7 ms==

Average rotational delay: 3 ms
==平均旋转延迟：3 ms==

Transfer rate of disk: 
==磁盘传输速率：==

To compute S, we need to first figure out how time is spent in a typical 10 MB transfer.
==为了计算 S，我们需要首先弄清楚典型的 10 MB 传输是如何花费时间的。==

First, we spend 7 ms seeking, and then 3 ms rotating.
==首先，我们花费 7 ms 寻道，然后 3 ms 旋转。==

Finally, transfer begins;
==最后，传输开始；==

10 MB @ 50  leads to  of a second, or 200 ms, spent in transfer.
==10 MB @ 50  导致花费  秒，即 200 ms 进行传输。==

Thus, for each 10 MB request, we spend 210 ms completing the request.
==因此，对于每个 10 MB 请求，我们花费 210 ms 完成请求。==

To compute S, we just need to divide:
==要计算 S，我们只需进行除法：==




As we can see, because of the large time spent transferring data, S is very near the peak bandwidth of the disk (the seek and rotational costs have been amortized).
==我们可以看到，由于大部分时间花在传输数据上，S 非常接近磁盘的峰值带宽（寻道和旋转成本已被摊销）。==

We can compute R similarly.
==我们可以类似地计算 R。==

Seek and rotation are the same;
==寻道和旋转是一样的；==

we then compute the time spent in transfer, which is 10 KB @ 50  or 0.195 ms.
==然后我们计算传输所花费的时间，即 10 KB @ 50  或 0.195 ms。==




As we can see, R is less than 1 , and  is almost 50.
==正如我们所见，R 小于 1 ，且  接近 50。==

Back To RAID-0 Analysis, Again
==再次回到 RAID-0 分析==

Let's now evaluate the performance of striping.
==现在让我们评估条带化的性能。==

As we said above, it is generally good.
==正如我们上面所说，通常很好。==

From a latency perspective, for example, the latency of a single-block request should be just about identical to that of a single disk;
==例如，从延迟的角度来看，单块请求的延迟应该与单个磁盘的延迟几乎相同；==

after all, RAID-0 will simply redirect that request to one of its disks.
==毕竟，RAID-0 只是将该请求重定向到其磁盘之一。==

From the perspective of steady-state sequential throughput, we'd expect to get the full bandwidth of the system.
==从稳态顺序吞吐量的角度来看，我们期望获得系统的全部带宽。==

Thus, throughput equals N (the number of disks) multiplied by S (the sequential bandwidth of a single disk).
==因此，吞吐量等于 N（磁盘数量）乘以 S（单个磁盘的顺序带宽）。==

For a large number of random , we can again use all of the disks, and thus obtain .
==对于大量的随机 I/O，我们可以再次使用所有磁盘，从而获得 。==

As we will see below, these values are both the simplest to calculate and will serve as an upper bound in comparison with other RAID levels.
==正如我们将在下面看到的，这些值既是最容易计算的，也将作为与其他 RAID 级别比较的上限。==

38.5 RAID Level 1: Mirroring
==38.5 RAID 1 级：镜像==

Our first RAID level beyond striping is known as RAID level 1, or mirroring.
==除了条带化之外，我们的第一个 RAID 级别被称为 RAID 1 级，或镜像。==

With a mirrored system, we simply make more than one copy of each block in the system;
==对于镜像系统，我们只是简单地为系统中的每个块制作多个副本；==

each copy should be placed on a separate disk, of course.
==当然，每个副本应该放在单独的磁盘上。==

By doing so, we can tolerate disk failures.
==这样做，我们可以容忍磁盘故障。==

In a typical mirrored system, we will assume that for each logical block, the RAID keeps two physical copies of it.
==在一个典型的镜像系统中，我们将假设对于每个逻辑块，RAID 保留两个物理副本。==

Here is an example:
==这里有一个例子：==

Figure 38.3: Simple RAID-1: Mirroring
==图 38.3：简单 RAID-1：镜像==

In the example, disk 0 and disk 1 have identical contents, and disk 2 and disk 3 do as well;
==在这个例子中，磁盘 0 和磁盘 1 有相同的内容，磁盘 2 和磁盘 3 也是如此；==

the data is striped across these mirror pairs.
==数据在这些镜像对之间条带化。==

In fact, you may have noticed that there are a number of different ways to place block copies across the disks.
==事实上，你可能已经注意到有许多不同的方式在磁盘上放置块副本。==

The arrangement above is a common one and is sometimes called RAID-10 (or RAID , stripe of mirrors) because it uses mirrored pairs (RAID-1) and then stripes (RAID-0) on top of them;
==上面的排列是一种常见的方式，有时被称为 RAID-10（或 RAID ，镜像的条带），因为它使用镜像对（RAID-1），然后在它们之上进行条带化（RAID-0）；==

another common arrangement is RAID-01 (or RAID , mirror of stripes), which contains two large striping (RAID-0) arrays, and then mirrors (RAID-1) on top of them.
==另一种常见的排列是 RAID-01（或 RAID ，条带的镜像），它包含两个大的条带化（RAID-0）阵列，然后在它们之上进行镜像（RAID-1）。==

For now, we will just talk about mirroring assuming the above layout.
==目前，我们将假设上述布局来讨论镜像。==

When reading a block from a mirrored array, the RAID has a choice: it can read either copy.
==当从镜像阵列读取块时，RAID 有一个选择：它可以读取任意一个副本。==

For example, if a read to logical block 5 is issued to the RAID, it is free to read it from either disk 2 or disk 3.
==例如，如果向 RAID 发出一个读取逻辑块 5 的请求，它可以自由地从磁盘 2 或磁盘 3 读取它。==

When writing a block, though, no such choice exists: the RAID must update both copies of the data, in order to preserve reliability.
==然而，当写入一个块时，不存在这样的选择：RAID 必须更新数据的两个副本，以保持可靠性。==

Do note, though, that these writes can take place in parallel;
==请注意，这些写入可以并行进行；==

for example, a write to logical block 5 could proceed to disks 2 and 3 at the same time.
==例如，对逻辑块 5 的写入可以同时在磁盘 2 和 3 上进行。==

RAID-1 Analysis
==RAID-1 分析==

Let us assess RAID-1.
==让我们评估一下 RAID-1。==

From a capacity standpoint, RAID-1 is expensive;
==从容量的角度来看，RAID-1 是昂贵的；==

with the mirroring level , we only obtain half of our peak useful capacity.
==当镜像级别  时，我们只获得峰值有用容量的一半。==

With N disks of B blocks, RAID-1 useful capacity is .
==对于 N 个磁盘，每个磁盘有 B 个块，RAID-1 的有用容量是 。==

From a reliability standpoint, RAID-1 does well.
==从可靠性的角度来看，RAID-1 表现良好。==

It can tolerate the failure of any one disk.
==它可以容忍任何一个磁盘的故障。==

You may also notice RAID-1 can actually do better than this, with a little luck.
==你可能也注意到，运气好的话，RAID-1 实际上可以做得比这更好。==

Imagine, in the figure above, that disk 0 and disk 2 both failed.
==想象一下，在上图中，磁盘 0 和磁盘 2 都坏了。==

In such a situation, there is no data loss!
==在这种情况下，没有数据丢失！==

More generally, a mirrored system (with mirroring level of 2) can tolerate 1 disk failure for certain, and up to  failures depending on which disks fail.
==更一般地说，一个镜像系统（镜像级别为 2）可以确定地容忍 1 个磁盘故障，并且最多可以容忍  个故障，具体取决于哪些磁盘发生故障。==

In practice, we generally don't like to leave things like this to chance;
==在实践中，我们通常不喜欢把这种事情留给运气；==

thus most people consider mirroring to be good for handling a single failure.
==因此大多数人认为镜像适合处理单个故障。==

Finally, we analyze performance.
==最后，我们分析性能。==

From the perspective of the latency of a single read request, we can see it is the same as the latency on a single disk;
==从单个读取请求的延迟角度来看，我们可以看到它与单个磁盘的延迟相同；==

all the RAID-1 does is direct the read to one of its copies.
==RAID-1 所做的只是将读取指向其副本之一。==

A write is a little different: it requires two physical writes to complete before it is done.
==写入稍有不同：它需要完成两个物理写入才算完成。==

These two writes happen in parallel, and thus the time will be roughly equivalent to the time of a single write;
==这两个写入是并行发生的，因此时间将大致相当于单个写入的时间；==

however, because the logical write must wait for both physical writes to complete, it suffers the worst-case seek and rotational delay of the two requests, and thus (on average) will be slightly higher than a write to a single disk.
==然而，因为逻辑写入必须等待两个物理写入都完成，所以它会遭受两个请求中最坏情况的寻道和旋转延迟，因此（平均而言）会略高于对单个磁盘的写入。==

ASIDE: THE RAID CONSISTENT-UPDATE PROBLEM
==旁注：RAID 一致性更新问题==

Before analyzing RAID-1, let us first discuss a problem that arises in any multi-disk RAID system, known as the consistent-update problem [DAA05].
==在分析 RAID-1 之前，让我们首先讨论任何多磁盘 RAID 系统中都会出现的一个问题，即一致性更新问题 [DAA05]。==

The problem occurs on a write to any RAID that has to update multiple disks during a single logical operation.
==当对任何需要在单个逻辑操作期间更新多个磁盘的 RAID 进行写入时，就会出现此问题。==

In this case, let us assume we are considering a mirrored disk array.
==在这种情况下，让我们假设我们正在考虑一个镜像磁盘阵列。==

Imagine the write is issued to the RAID, and then the RAID decides that it must be written to two disks, disk 0 and disk 1.
==想象写入请求被发往 RAID，然后 RAID 决定必须将其写入两个磁盘，磁盘 0 和磁盘 1。==

The RAID then issues the write to disk 0, but just before the RAID can issue the request to disk 1, a power loss (or system crash) occurs.
==然后 RAID 向磁盘 0 发出写入，但在 RAID 向磁盘 1 发出请求之前，发生了断电（或系统崩溃）。==

In this unfortunate case, let us assume that the request to disk 0 completed (but clearly the request to disk 1 did not, as it was never issued).
==在这个不幸的情况下，让我们假设对磁盘 0 的请求已完成（但显然对磁盘 1 的请求没有完成，因为它从未发出）。==

The result of this untimely power loss is that the two copies of the block are now inconsistent;
==这种不合时宜的断电导致的结果是，该块的两个副本现在不一致了；==

the copy on disk 0 is the new version, and the copy on disk 1 is the old.
==磁盘 0 上的副本是新版本，而磁盘 1 上的副本是旧版本。==

What we would like to happen is for the state of both disks to change atomically, i.e., either both should end up as the new version or neither.
==我们要希望发生的是两个磁盘的状态原子性地改变，即要么都变成新版本，要么都不是。==

The general way to solve this problem is to use a write-ahead log of some kind to first record what the RAID is about to do (i.e., update two disks with a certain piece of data) before doing it.
==解决这个问题的一般方法是使用某种预写日志，在执行操作之前先记录 RAID 将要做什么（即，用特定数据更新两个磁盘）。==

By taking this approach, we can ensure that in the presence of a crash, the right thing will happen;
==通过采取这种方法，我们可以确保在发生崩溃时，会发生正确的事情；==

by running a recovery procedure that replays all pending transactions to the RAID, we can ensure that no two mirrored copies (in the RAID-1 case) are out of sync.
==通过运行一个重放所有挂起事务到 RAID 的恢复程序，我们可以确保没有两个镜像副本（在 RAID-1 案例中）是不同步的。==

One last note: because logging to disk on every write is prohibitively expensive, most RAID hardware includes a small amount of non-volatile RAM (e.g., battery-backed) where it performs this type of logging.
==最后一点：因为在每次写入时都记录到磁盘极其昂贵，大多数 RAID 硬件包含少量非易失性 RAM（例如，电池供电的），并在那里执行此类日志记录。==

Thus, consistent update is provided without the high cost of logging to disk.
==因此，在没有记录到磁盘的高昂成本的情况下提供了一致性更新。==

To analyze steady-state throughput, let us start with the sequential workload.
==为了分析稳态吞吐量，让我们从顺序工作负载开始。==

When writing out to disk sequentially, each logical write must result in two physical writes;
==当顺序写入磁盘时，每个逻辑写入必须导致两个物理写入；==

for example, when we write logical block 0 (in the figure above), the RAID internally would write it to both disk 0 and disk 1.
==例如，当我们写入逻辑块 0（在上图中）时，RAID 内部会将其写入磁盘 0 和磁盘 1。==

Thus, we can conclude that the maximum bandwidth obtained during sequential writing to a mirrored array is , or half the peak bandwidth.
==因此，我们可以得出结论，镜像阵列顺序写入期间获得的最大带宽是 ，即峰值带宽的一半。==

Unfortunately, we obtain the exact same performance during a sequential read.
==不幸的是，在顺序读取期间我们获得了完全相同的性能。==

One might think that a sequential read could do better, because it only needs to read one copy of the data, not both.
==人们可能认为顺序读取可以做得更好，因为它只需要读取数据的一个副本，而不是两个。==

However, let's use an example to illustrate why this doesn't help much.
==然而，让我们用一个例子来说明为什么这没有太大帮助。==

Imagine we need to read blocks 0, 1, 2, 3, 4, 5, 6, and 7.
==想象一下我们需要读取块 0、1、2、3、4、5、6 和 7。==

Let's say we issue the read of 0 to disk 0, the read of 1 to disk 2, the read of 2 to disk 1, and the read of 3 to disk 3.
==假设我们将 0 的读取发给磁盘 0，1 的读取发给磁盘 2，2 的读取发给磁盘 1，3 的读取发给磁盘 3。==

We continue by issuing reads to 4, 5, 6, and 7 to disks 0, 2, 1, and 3, respectively.
==我们继续将 4、5、6 和 7 的读取分别发给磁盘 0、2、1 和 3。==

One might naively think that because we are utilizing all disks, we are achieving the full bandwidth of the array.
==人们可能会天真地认为，因为我们在利用所有磁盘，所以我们实现了阵列的全部带宽。==

To see that this is not (necessarily) the case, however, consider the requests a single disk receives (say disk 0).
==然而，要明白情况（未必）如此，请考虑单个磁盘（比如说磁盘 0）收到的请求。==

First, it gets a request for block 0; then, it gets a request for block 4 (skipping block 2).
==首先，它收到块 0 的请求；然后，它收到块 4 的请求（跳过了块 2）。==

In fact, each disk receives a request for every other block.
==事实上，每个磁盘每隔一个块接收一个请求。==

While it is rotating over the skipped block, it is not delivering useful bandwidth to the client.
==当它在被跳过的块上旋转时，它并没有向客户端提供有用的带宽。==

Thus, each disk will only deliver half its peak bandwidth.
==因此，每个磁盘将只提供其峰值带宽的一半。==

And thus, the sequential read will only obtain a bandwidth of .
==因此，顺序读取将只获得  的带宽。==

Random reads are the best case for a mirrored RAID.
==随机读取是镜像 RAID 的最佳情况。==

In this case, we can distribute the reads across all the disks, and thus obtain the full possible bandwidth.
==在这种情况下，我们可以将读取分布到所有磁盘上，从而获得全部可能的带宽。==

Thus, for random reads, RAID-1 delivers .
==因此，对于随机读取，RAID-1 提供 。==

Finally, random writes perform as you might expect: .
==最后，随机写入的表现正如你所预期的那样：。==

Each logical write must turn into two physical writes, and thus while all the disks will be in use, the client will only perceive this as half the available bandwidth.
==每个逻辑写入必须变成两个物理写入，因此虽然所有磁盘都将被使用，但客户端只能感知到可用带宽的一半。==

Even though a write to logical block x turns into two parallel writes to two different physical disks, the bandwidth of many small requests only achieves half of what we saw with striping.
==即使对逻辑块 x 的写入变成了对两个不同物理磁盘的两个并行写入，许多小请求的带宽也只能达到我们在条带化中看到的一半。==

As we will soon see, getting half the available bandwidth is actually pretty good!
==正如我们很快就会看到的，获得可用带宽的一半实际上已经相当不错了！==

38.6 RAID Level 4: Saving Space With Parity
==38.6 RAID 4 级：利用奇偶校验节省空间==

We now present a different method of adding redundancy to a disk array known as parity.
==我们现在介绍一种不同的向磁盘阵列添加冗余的方法，称为奇偶校验。==

Parity-based approaches attempt to use less capacity and thus overcome the huge space penalty paid by mirrored systems.
==基于奇偶校验的方法试图使用更少的容量，从而克服镜像系统付出的巨大空间代价。==

They do so at a cost, however: performance.
==然而，这样做是有代价的：性能。==

Figure 38.4: RAID-4 With Parity
==图 38.4：具有奇偶校验的 RAID-4==

Here is an example five-disk RAID-4 system (Figure 38.4).
==这里有一个五磁盘 RAID-4 系统的例子（图 38.4）。==

For each stripe of data, we have added a single parity block that stores the redundant information for that stripe of blocks.
==对于每个数据条带，我们添加了一个奇偶校验块，用于存储该条带块的冗余信息。==

For example, parity block P1 has redundant information that it calculated from blocks 4, 5, 6, and 7.
==例如，奇偶校验块 P1 具有从块 4、5、6 和 7 计算得出的冗余信息。==

To compute parity, we need to use a mathematical function that enables us to withstand the loss of any one block from our stripe.
==为了计算奇偶校验，我们需要使用一个数学函数，使我们能够承受条带中任何一个块的丢失。==

It turns out the simple function XOR does the trick quite nicely.
==事实证明，简单的异或（XOR）函数就能很好地达到目的。==

For a given set of bits, the XOR of all of those bits returns a 0 if there are an even number of 1's in the bits, and a 1 if there are an odd number of 1's.
==对于给定的一组位，如果其中 1 的个数是偶数，则所有这些位的异或返回 0，如果是奇数，则返回 1。==

For example:
==例如：==

In the first row (0,0,1,1), there are two 1's (C2, C3), and thus XOR of all of those values will be 0 (P);
==在第一行 (0,0,1,1) 中，有两个 1 (C2, C3)，因此所有这些值的异或将是 0 (P)；==

similarly, in the second row there is only one 1 (C1), and thus the XOR must be 1 (P).
==同样，在第二行中只有一个 1 (C1)，因此异或必须是 1 (P)。==

You can remember this in a simple way: that the number of 1s in any row, including the parity bit, must be an even (not odd) number;
==你可以用一种简单的方式记住这一点：任何一行中 1 的数量，包括奇偶校验位，必须是偶数（不是奇数）；==

that is the invariant that the RAID must maintain in order for parity to be correct.
==这是 RAID 必须维护的不变性，以便奇偶校验是正确的。==

From the example above, you might also be able to guess how parity information can be used to recover from a failure.
==从上面的例子中，你也许能猜出奇偶校验信息如何用于从故障中恢复。==

Imagine the column labeled C2 is lost.
==想象一下标记为 C2 的列丢失了。==

To figure out what values must have been in the column, we simply have to read in all the other values in that row (including the XOR'd parity bit) and reconstruct the right answer.
==为了弄清楚该列中一定是什么值，我们只需读入该行中的所有其他值（包括异或的奇偶校验位）并重构正确的答案。==

Specifically, assume the first row's value in column C2 is lost (it is a 1);
==具体来说，假设第一行 C2 列的值丢失（它是 1）；==

by reading the other values in that row (0 from C0, 0 from C1, 1 from C3, and 0 from the parity column P), we get the values 0, 0, 1, and 0.
==通过读取该行中的其他值（来自 C0 的 0，来自 C1 的 0，来自 C3 的 1，以及来自奇偶校验列 P 的 0），我们得到值 0、0、1 和 0。==

Because we know that XOR keeps an even number of 1's in each row, we know what the missing data must be: a 1.
==因为我们知道异或保持每一行中 1 的数量为偶数，我们知道丢失的数据一定是什么：一个 1。==

And that is how reconstruction works in a XOR-based parity scheme!
==这就是基于异或的奇偶校验方案中重建的工作原理！==

Note also how we compute the reconstructed value: we just XOR the data bits and the parity bits together, in the same way that we calculated the parity in the first place.
==还要注意我们如何计算重构的值：我们只是将数据位和奇偶校验位异或在一起，就像我们最初计算奇偶校验一样。==

Now you might be wondering: we are talking about XORing all of these bits, and yet from above we know that the RAID places 4KB (or larger) blocks on each disk;
==现在你可能会想：我们在谈论异或所有这些位，但从上面我们知道 RAID 在每个磁盘上放置 4KB（或更大）的块；==

how do we apply XOR to a bunch of blocks to compute the parity?
==我们如何对一堆块应用异或来计算奇偶校验？==

It turns out this is easy as well.
==事实证明这也容易。==

Simply perform a bitwise XOR across each bit of the data blocks;
==只需对数据块的每一位执行按位异或；==

put the result of each bitwise XOR into the corresponding bit slot in the parity block.
==将每个按位异或的结果放入奇偶校验块中相应的位槽中。==

As you can see from the figure, the parity is computed for each bit of each block and the result placed in the parity block.
==正如图中所示，奇偶校验是为每个块的每一位计算的，结果放置在奇偶校验块中。==

RAID-4 Analysis
==RAID-4 分析==

Let us now analyze RAID-4.
==现在让我们分析 RAID-4。==

From a capacity standpoint, RAID-4 uses 1 disk for parity information for every group of disks it is protecting.
==从容量的角度来看，RAID-4 为它保护的每组磁盘使用 1 个磁盘用于奇偶校验信息。==

Thus, our useful capacity for a RAID group is .
==因此，我们的 RAID 组的有用容量是 。==

Reliability is also quite easy to understand: RAID-4 tolerates 1 disk failure and no more.
==可靠性也很容易理解：RAID-4 可以容忍 1 个磁盘故障，不能更多。==

If more than one disk is lost, there is simply no way to reconstruct the lost data.
==如果丢失超过一个磁盘，根本无法重构丢失的数据。==

Figure 38.5: Full-stripe Writes In RAID-4
==图 38.5：RAID-4 中的全条带写入==

Finally, there is performance.
==最后是性能。==

This time, let us start by analyzing steady-state throughput.
==这一次，让我们从分析稳态吞吐量开始。==

Sequential read performance can utilize all of the disks except for the parity disk, and thus deliver a peak effective bandwidth of  (an easy case).
==顺序读取性能可以利用除奇偶校验磁盘以外的所有磁盘，从而提供  的峰值有效带宽（这是一个简单的情况）。==

To understand the performance of sequential writes, we must first understand how they are done.
==要理解顺序写入的性能，我们必须首先了解它们是如何完成的。==

When writing a big chunk of data to disk, RAID-4 can perform a simple optimization known as a full-stripe write.
==当向磁盘写入一大块数据时，RAID-4 可以执行一种称为全条带写入的简单优化。==

For example, imagine the case where the blocks 0, 1, 2, and 3 have been sent to the RAID as part of a write request (Figure 38.5).
==例如，想象块 0、1、2 和 3 作为写入请求的一部分已发送到 RAID 的情况（图 38.5）。==

In this case, the RAID can simply calculate the new value of P0 (by performing an XOR across the blocks 0, 1, 2, and 3) and then write all of the blocks (including the parity block) to the five disks above in parallel (highlighted in gray in the figure).
==在这种情况下，RAID 可以简单地计算 P0 的新值（通过对块 0、1、2 和 3 执行异或），然后并行地将所有块（包括奇偶校验块）写入上面的五个磁盘（图中以灰色突出显示）。==

Thus, full-stripe writes are the most efficient way for RAID-4 to write to disk.
==因此，全条带写入是 RAID-4 写入磁盘的最有效方式。==

Once we understand the full-stripe write, calculating the performance of sequential writes on RAID-4 is easy;
==一旦我们理解了全条带写入，计算 RAID-4 上顺序写入的性能就很容易了；==

the effective bandwidth is also .
==有效带宽也是 。==

Even though the parity disk is constantly in use during the operation, the client does not gain performance advantage from it.
==即使奇偶校验磁盘在操作过程中一直被使用，客户端也不会从中获得性能优势。==

Now let us analyze the performance of random reads.
==现在让我们分析随机读取的性能。==

As you can also see from the figure above, a set of 1-block random reads will be spread across the data disks of the system but not the parity disk.
==正如你从上图中看到的那样，一组 1 块大小的随机读取将分布在系统的数据磁盘上，但不会分布在奇偶校验磁盘上。==

Thus, the effective performance is: .
==因此，有效性能是：。==

Random writes, which we have saved for last, present the most interesting case for RAID-4.
==我们留到最后的随机写入，展示了 RAID-4 最有趣的情况。==

Imagine we wish to overwrite block 1 in the example above.
==想象一下我们希望覆盖上面例子中的块 1。==

We could just go ahead and overwrite it, but that would leave us with a problem: the parity block P0 would no longer accurately reflect the correct parity value of the stripe;
==我们可以直接覆盖它，但这会给我们留下一个问题：奇偶校验块 P0 将不再准确反映条带的正确奇偶校验值；==

in this example, P0 must also be updated.
==在这个例子中，P0 也必须更新。==

How can we update it both correctly and efficiently?
==我们如何既正确又有效地更新它？==

It turns out there are two methods.
==事实证明有两种方法。==

The first, known as additive parity, requires us to do the following.
==第一种称为加法奇偶校验，需要我们要执行以下操作。==

To compute the value of the new parity block, read in all of the other data blocks in the stripe in parallel (in the example, blocks 0, 2, and 3) and XOR those with the new block (1).
==为了计算新奇偶校验块的值，并行读入条带中的所有其他数据块（在示例中为块 0、2 和 3），并将它们与新块 (1) 进行异或。==

The result is your new parity block.
==结果就是你的新奇偶校验块。==

To complete the write, you can then write the new data and new parity to their respective disks, also in parallel.
==要完成写入，你可以随后将新数据和新奇偶校验并行写入各自的磁盘。==

The problem with this technique is that it scales with the number of disks, and thus in larger RAIDs requires a high number of reads to compute parity.
==这种技术的问题在于它随磁盘数量扩展，因此在较大的 RAID 中需要大量的读取来计算奇偶校验。==

Thus, the subtractive parity method.
==因此，有了减法奇偶校验方法。==

For example, imagine this string of bits (4 data bits, one parity):
==例如，想象这串位（4 个数据位，1 个奇偶校验位）：==

C0 C1 C2 C3 P
0 0 1 1 0

XOR(0,0,1,1) = 0
XOR(0,0,1,1) = 0

Let's imagine that we wish to overwrite bit C2 with a new value which we will call .
==让我们想象一下，我们希望用一个新值覆盖位 C2，我们称之为 。==

The subtractive method works in three steps.
==减法分三步进行。==

First, we read in the old data at C2 () and the old parity ().
==首先，我们读入 C2 处的旧数据（）和旧奇偶校验（）。==

Then, we compare the old data and the new data;
==然后，我们比较旧数据和新数据；==

if they are the same (e.g., ), then we know the parity bit will also remain the same (i.e., ).
==如果它们相同（例如，），那么我们知道奇偶校验位也将保持不变（即 ）。==

If, however, they are different, then we must flip the old parity bit to the opposite of its current state, that is, if ,  will be set to 0;
==然而，如果它们不同，那么我们必须将旧奇偶校验位翻转为其当前状态的反面，也就是说，如果 ， 将被设置为 0；==

if ,  will be set to 1.
==如果 ， 将被设置为 1。==

We can express this whole mess neatly with XOR:
==我们可以用异或整洁地表达这一团乱麻：==




Because we are dealing with blocks, not bits, we perform this calculation over all the bits in the block (e.g., 4096 bytes in each block multiplied by 8 bits per byte).
==因为我们处理的是块，而不是位，所以我们对块中的所有位执行此计算（例如，每个块 4096 字节乘以每字节 8 位）。==

Thus, in most cases, the new block will be different than the old block and thus the new parity block will too.
==因此，在大多数情况下，新块将不同于旧块，因此新奇偶校验块也将不同。==

You should now be able to figure out when we would use the additive parity calculation and when we would use the subtractive method.
==你现在应该能够弄清楚我们要何时使用加法奇偶校验计算，何时使用减法。==

Think about how many disks would need to be in the system so that the additive method performs fewer I/Os than the subtractive method;
==想一想系统中需要有多少个磁盘，才能使加法方法执行的 I/O 少于减法方法；==

what is the cross-over point?
==交叉点是多少？==

For this performance analysis, let us assume we are using the subtractive method.
==对于这个性能分析，让我们假设我们使用的是减法。==

Thus, for each write, the RAID has to perform 4 physical  (two reads and two writes).
==因此，对于每次写入，RAID 必须执行 4 次物理 I/O（两次读取和两次写入）。==

Now imagine there are lots of writes submitted to the RAID; how many can RAID-4 perform in parallel?
==现在想象有大量写入提交给 RAID；RAID-4 可以并行执行多少个？==

To understand, let us again look at the RAID-4 layout (Figure 38.6).
==为了理解，让我们再次看看 RAID-4 的布局（图 38.6）。==

Figure 38.6: Example: Writes To 4, 13, And Respective Parity Blocks
==图 38.6：示例：写入 4、13 和各自的奇偶校验块==

Now imagine there were 2 small writes submitted to the RAID-4 at about the same time, to blocks 4 and 13.
==现在想象大约在同一时间向 RAID-4 提交了 2 个小写入，分别写入块 4 和 13。==

The data for those disks is on disks 0 and 1, and thus the read and write to data could happen in parallel, which is good.
==这些磁盘的数据位于磁盘 0 和 1 上，因此数据的读写可以并行发生，这很好。==

The problem that arises is with the parity disk; both the requests have to read the related parity blocks for 4 and 13, parity blocks 1 and 3.
==出现的问题在于奇偶校验磁盘；两个请求都必须读取 4 和 13 的相关奇偶校验块，即奇偶校验块 1 和 3。==

Hopefully, the issue is now clear: the parity disk is a bottleneck under this type of workload;
==希望现在问题已经很清楚了：在这种类型的工作负载下，奇偶校验磁盘是一个瓶颈；==

we sometimes thus call this the small-write problem for parity-based RAIDs.
==因此我们有时将此称为基于奇偶校验的 RAID 的小写入问题。==

Thus, even though the data disks could be accessed in parallel, the parity disk prevents any parallelism from materializing;
==因此，即使数据磁盘可以并行访问，奇偶校验磁盘也阻碍了任何并行性的实现；==

all writes to the system will be serialized because of the parity disk.
==由于奇偶校验磁盘，所有对系统的写入都将被序列化。==

Because the parity disk has to perform two  (one read, one write) per logical  we can compute the performance of small random writes in RAID-4 by computing the parity disk's performance on those two , and thus we achieve  MB/s.
==因为奇偶校验磁盘必须为每个逻辑 I/O 执行两个 I/O（一次读取，一次写入），我们可以通过计算奇偶校验磁盘在这两个 I/O 上的性能来计算 RAID-4 中小随机写入的性能，因此我们达到了  MB/s。==

RAID-4 throughput under random small writes is terrible;
==随机小写入下的 RAID-4 吞吐量很糟糕；==

it does not improve as you add disks to the system.
==随着向系统添加磁盘，它并没有改善。==

We conclude by analyzing I/O latency in RAID-4.
==最后我们分析 RAID-4 中的 I/O 延迟。==

As you now know, a single read (assuming no failure) is just mapped to a single disk, and thus its latency is equivalent to the latency of a single disk request.
==正如你现在所知，单个读取（假设没有故障）只是映射到单个磁盘，因此其延迟相当于单个磁盘请求的延迟。==

The latency of a single write requires two reads and then two writes;
==单个写入的延迟需要两次读取，然后是两次写入；==

the reads can happen in parallel, as can the writes, and thus total latency is about twice that of a single disk (with some differences because we have to wait for both reads to complete and thus get the worst-case positioning time, but then the updates don't incur seek cost and thus may be a better-than-average positioning cost).
==读取可以并行发生，写入也可以，因此总延迟大约是单个磁盘的两倍（有一些差异，因为我们必须等待两个读取都完成，从而得到最坏情况的定位时间，但随后的更新不会产生寻道成本，因此可能具有优于平均水平的定位成本）。==

38.7 RAID Level 5: Rotating Parity
==38.7 RAID 5 级：旋转奇偶校验==

To address the small-write problem (at least, partially), Patterson, Gibson, and Katz introduced RAID-5.
==为了解决小写入问题（至少是部分解决），Patterson、Gibson 和 Katz 推出了 RAID-5。==

RAID-5 works almost identically to RAID-4, except that it rotates the parity block across drives (Figure 38.7).
==RAID-5 的工作原理与 RAID-4 几乎相同，除了它会在驱动器之间旋转奇偶校验块（图 38.7）。==

Figure 38.7: RAID-5 With Rotated Parity
==图 38.7：具有旋转奇偶校验的 RAID-5==

As you can see, the parity block for each stripe is now rotated across the disks, in order to remove the parity-disk bottleneck for RAID-4.
==正如你所看到的，每个条带的奇偶校验块现在在磁盘之间旋转，以消除 RAID-4 的奇偶校验磁盘瓶颈。==

RAID-5 Analysis
==RAID-5 分析==

Much of the analysis for RAID-5 is identical to RAID-4.
==RAID-5 的大部分分析与 RAID-4 相同。==

For example, the effective capacity and failure tolerance of the two levels are identical.
==例如，这两个级别的有效容量和故障容忍度是相同的。==

So are sequential read and write performance.
==顺序读写性能也是如此。==

The latency of a single request (whether a read or a write) is also the same as RAID-4.
==单个请求的延迟（无论是读还是写）也与 RAID-4 相同。==

Random read performance is a little better, because we can now utilize all disks.
==随机读取性能稍微好一点，因为我们现在可以利用所有磁盘。==

Finally, random write performance improves noticeably over RAID-4, as it allows for parallelism across requests.
==最后，随机写入性能比 RAID-4 显着提高，因为它允许跨请求并行。==

Imagine a write to block 1 and a write to block 10;
==想象一下对块 1 的写入和对块 10 的写入；==

this will turn into requests to disk 1 and disk 4 (for block 1 and its parity) and requests to disk 0 and disk 2 (for block 10 and its parity).
==这将变成对磁盘 1 和磁盘 4 的请求（针对块 1 及其奇偶校验），以及对磁盘 0 和磁盘 2 的请求（针对块 10 及其奇偶校验）。==

Thus, they can proceed in parallel.
==因此，它们可以并行进行。==

Figure 38.8: RAID Capacity, Reliability, and Performance
==图 38.8：RAID 容量、可靠性和性能==

In fact, we can generally assume that given a large number of random requests, we will be able to keep all the disks about evenly busy.
==事实上，我们通常可以假设，给定大量的随机请求，我们将能够使所有磁盘大致均匀地忙碌。==

If that is the case, then our total bandwidth for small writes will be .
==如果是这种情况，那么我们小写入的总带宽将是 。==

The factor of four loss is due to the fact that each RAID-5 write still generates 4 total  operations, which is simply the cost of using parity-based RAID.
==四倍的损失是由于每个 RAID-5 写入仍然产生 4 个总 I/O 操作，这仅仅是使用基于奇偶校验的 RAID 的成本。==

Because RAID-5 is basically identical to RAID-4 except in the few cases where it is better, it has almost completely replaced RAID-4 in the marketplace.
==因为 RAID-5 除了在少数情况下更好之外，基本上与 RAID-4 相同，所以它在市场上几乎完全取代了 RAID-4。==

The only place where it has not is in systems that know they will never perform anything other than a large write, thus avoiding the small-write problem altogether [HLM94];
==唯一的例外是那些知道除了大写入之外永远不会执行其他操作的系统，从而完全避免了小写入问题 [HLM94]；==

in those cases, RAID-4 is sometimes used as it is slightly simpler to build.
==在这些情况下，有时会使用 RAID-4，因为它的构建稍微简单一些。==

38.8 RAID Comparison: A Summary
==38.8 RAID 比较：总结==

We now summarize our simplified comparison of RAID levels in Figure 38.8.
==我们现在在图 38.8 中总结我们对 RAID 级别的简化比较。==

Note that we have omitted a number of details to simplify our analysis.
==请注意，为了简化分析，我们省略了许多细节。==

For example, when writing in a mirrored system, the average seek time is a little higher than when writing to just a single disk, because the seek time is the max of two seeks (one on each disk).
==例如，在镜像系统中写入时，平均寻道时间比仅写入单个磁盘时稍高，因为寻道时间是两次寻道（每个磁盘一次）的最大值。==

Thus, random write performance to two disks will generally be a little less than random write performance of a single disk.
==因此，对两个磁盘的随机写入性能通常会略低于单个磁盘的随机写入性能。==

Also, when updating the parity disk in RAID-4/5, the first read of the old parity will likely cause a full seek and rotation, but the second write of the parity will only result in rotation.
==此外，在 RAID-4/5 中更新奇偶校验磁盘时，第一次读取旧奇偶校验可能会导致完全的寻道和旋转，但第二次写入奇偶校验将只会导致旋转。==

Finally, sequential I/O to mirrored RAIDs pay a 2x performance penalty as compared to other approaches.
==最后，与其他方法相比，镜像 RAID 的顺序 I/O 付出了 2 倍的性能代价。==

The  penalty assumes a naive read/write pattern for mirroring;
== 的代价假设了镜像的朴素读写模式；==

a more sophisticated approach that issued large  requests to differing parts of each mirror could potentially achieve full bandwidth.
==一种更复杂的方法，即向每个镜像的不同部分发出大型 I/O 请求，可能实现全带宽。==

Think about this to see if you can figure out why.
==思考一下，看看你是否能弄清楚原因。==