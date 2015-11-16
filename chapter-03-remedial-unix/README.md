# Remedial Unix Shell

## Useful Unix shortcuts

These are *essential* if you spend a lot of time in the shell. See the [preface
readme](https://github.com/vsbuffalo/bds-files/blob/master/chapter-00-preface/README.md)
for more details on how I set up my terminal (some of these changes are
necessary for the following to work):

 - `control-a`: move cursor to beginning of terminal line.
 - `control-e`: move cursor to end of terminal line.
 - `control-k`: delete (or *k*ill) all text from cursor to end of line.
 - `option-delete`: delete an entire word
 - `option-b`: move cursor backwards an entire word.
 - `option-f`: move cursor forwards an entire word.
 - `control-c`: cancel input text or when a command is running, stop it.
 - up arrow: access last entered command.
 - `control-r`: start searching shell history. Start typing to search -- `enter` will enter the current command. `control-c` will cancel.

I recommend you learn all of these -- they will greatly make working in the
shell easier and more enjoyable.

## The Unix Chainsaw

I use this quote from Gary Bernhardt's excellent talk [The UNIX
Chainsaw](http://confreaks.tv/videos/cascadiaruby2011-the-unix-chainsaw). It's
entertaining and includes some very nice examples of how powerful Unix (in the
context of software development, but still generally applicable).

## Doug McIlroy's "Garden Hose" Pipe Quote

The "garden hose" quote is from an October 1964 [Bell Labs
memo](http://cm.bell-labs.com/who/dmr/mdmpipe.html). There's a cool image of
the memo here: http://doc.cat-v.org/unix/pipes/

Brian Kernighan gives a great interview about the pipeline concept on the
[Computerphile YouTube
channel](https://www.youtube.com/watch?v=bKzonnwoR2I&feature=youtu.be).

## The Modular Unix Approach versus Monolithic Programs

There has been some debate about the Unix approach to bioinformatics versus
alternatives (e.g. giant monolithic programs). One counter argument (incorrect
in my opinion) is spelled out in [The iniquities of the Unix
shell](http://madhadron.com/posts/2011-07-29-the-iniquities-of-the-unix-shell.html)
(note this write has [left
bioinformatics](http://madhadron.com/posts/2012-03-26-a-farewell-to-bioinformatics.html)).
I've also written about this topic, in [Bioinformatics and Interface
Design](http://vincebuffalo.com/2013/01/26/bioinfo-interfaces.html).

The prevalence of Unix in not only bioinformatics, but also more generally data
science and statistics, indicates its success. I describe why this approach is
a good one both in this chapter and in chapter 7 when I discuss Unix data
tools.

## Z Shell

I use Z shell in my daily bioinformatics work -- if you're an advanced reader,
you may wan to try it. Configuring your shell to your exact needs is one of the
great joys of being a nerd; with Z shell, this is made much easier through a
project called [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh). I would
recommend using Oh My Zsh if you're just getting started. You can take a closer
look at my configurations in my [dotfiles
repository](https://github.com/vsbuffalo/dotfiles). Below are some other resources to get started with Z shell:

- [Why Zsh is Cooler than Your
  Shell](http://www.slideshare.net/jaguardesignstudio/why-zsh-is-cooler-than-your-shell-16194692)
is a very nice introduction (and also includes a reference to the Knuth
Programmer Pearls story I teach in chapter 7).
- [zsh: The last shell you’ll ever need](https://friedcpu.wordpress.com/2007/07/24/zsh-the-last-shell-youll-ever-need/).

## Latency Figures and Pipes

You can learn more about the latency statistics from this chapter from Peter
Norvig's terrific classic essay, [Teach Yourself Programming in Ten
Years](http://norvig.com/21-days.html) and this awesome interactive
explanation, [Latency Numbers Every Programmer Should
Know](http://www.eecs.berkeley.edu/~rcs/research/interactive_latency.html).

## Resource Management

### Managing Processes with `ps` and Brief Look at Memory Management

*Quick note: I have not had time to proof-read this section extensively*

When we start running computationally intensive tasks, we want to keep track of
how they're running. One way of doing this is by following the output they
create, perhaps by using `tail -f` on a log file or even `ls -lrt` (list all
files by reverse time order) to see if the program is writing to disk (you
would see the output files' sizes increasing). In cases where a program isn't
writing to output files or actively logging what it's doing require a different
way monitoring their activity, and the two most programs to do this are `top`
and `ps`.

`ps` stands for *process status*, as it gives you the status of all running
processes. Without any arguments, it's not too useful; systems administrators
and bioinformaticians usually run it as `ps aux`. Note that `aux` isn't a
special keyword, but rather merged options which display processes for all
users (from `-a`), adding a column indicating the user (from `-u`), and outputs
processes that are running even if they weren't started from a terminal (`-x`).
A feud between different Unix variants from UC Berkeley (BSD) and AT&T (System
V) and their different `ps` variants in the 1980s means that the cryptic,
engrained `aux` option is supported widely still (i.e. even in Apple's OS X).
Since `ps aux` gives us a *lot* of processes to sort through, it's common to
pipe the output to `grep` to give us a more powerful little combination
(there's also a tool called `psgrep` just for this task). Below, let's take a
look at the top of `ps` output (so we can see its column names) and then look
for "samtools":

    $ ps aux | head -n3
    USER    PID  %CPU %MEM      VSZ    RSS   TT    STAT STARTED      TIME  COMMAND
    todd    6384  12.7  4.0  4047300 166032   pts/7  S    Thu10AM  37:42.69 samtools
    todd    90710   8.9  4.6  1403080 193584   ??    S    Thu08PM  57:15.12 fastq_stats
    $ ps aux | grep "samtools"
    todd    6384  12.7  4.0  4047300 166032   pts/7  S    Thu10AM  42:16.59 samtools

We use `ps` and `grep` to search for our particular processes, which is useful
to see how much of our CPU (the third column above) and memory (the fourth
column) a process is using. The process ID, or PID. in the second column is a
unique identifier given to all our processes. Thee allows us to interact with
running processes through terminating and adjusting their priority (topics we
cover in the next section). Since `ps aux` is such a common idiom to monitor
process, a table of the columns and their meaning is included below.

Columns in `ps aux`:

 - `USER`: user running the process
 - `PID`: process ID
 - `CPU`: percentage of CPU used
 - `VSZ`: virtual memory size (in kilobytes)
 - `RSS`: resident set size (in kilobytes)
 - `TT`: controlling terminal
 - `STAT`: process state code
 - `START`: time command was started (sometimes this is `STARTED`)
 - `TIME`: time running
 - `COMMAND`: command that started process

When interacting with processes, it's common to read output and see columns
that look cryptic. With `ps aux`, what the columns `VSZ`, `RSS`, `TT`, and
`STAT` mean isn't exactly clear. First, `TT` is the controlling terminal, which
your or another user is using. Occasionally the process was started by another
process or your operating system, so this may appear as `??`. `STAT` is a
"state code", a jargon term for a letter that tells you if your process is
running (`R`), sleeping (`S`), stopped (`T`), or in another state (see `man ps`
for a full list). `VSZ` and `RSS` are more interesting to us, so we'll explore
them in more detail.

Occasionally your system runs low on physical memory (RAM), and your operating
system does its best to manage. Unfortunately the only way your operating
system can give a process more memory than is physical available is by taking a
chunk of less-used memory (these chunks are used by *pages*, a word you may see
in the `ps` and `top` manuals), writing it to disk (this is slow!), and then
using that now-free page for your process. Since you're *swapping* a in-memory
physical page of memory for one on a hard drive, the part of your disk that
manages this type of activity is called *swap space*. This may seem like a lot
of technical detail, but it has a very real result in day-to-day bioinformatics
work: if you run out of physical memory, your processes will be forced to start
swapping memory to the hard disk, and hard disks are really slow. High-memory
tasks like assembly (and in some cases alignment) on machines with insufficent
physical memory will halt even the fastest machines to a stand still.

With this information, `VSZ` and `RSS` will now make more sense. `VSZ` is the
amount of virtual memory and `RSS` is the amount of physical memory. Virtual
memory includes both swap and physical memory, so `VSZ` is larger than `RSS`.
`ps aux` gives you a quick glance at these values, but the way an operating
system allocates memory can be a very baffling process to decode. When we want
to integate our processes to see which are using the most memory, CPU, or swap
space, `ps` becomes a less useful and `top` becomes our tool of choice. But
remember, for searching for processes, `ps` and `grep` can be combined in great
ways.

### Interrogating Processes with +top+ and Understanding Bottlenecks

Unlike `ps`, `top` keeps refreshing your list of processes. Enter `top` at a
command line, and it will update (Linux versions usually update every three
seconds and OS X every one second). To exit `top`, just press 'q'. But
constantly updating isn't top's greatest strength — be able to interactively
look at which processes are using the most resources is.

Unfortunately, `top` differs considerably between Linux and Apple's OS X (and
other Unix variants that have UC Berkeley's BSD as their ancestor). Since most
bioinformatics servers we interact with over SSH are Linux-based, I will cover
the Linux version. If you have a Mac workstation, consult the table
<<table-top>> and the `top` manual.

Let's start `top` with the handy `-M` option, which displays our memory
units in larger units than kilobytes where appropriate. You should see
something like the below:

    $ top -M
    top - 19:49:58 up 22 min,  3 users,  load average: 0.88, 0.45, 0.23
    Tasks:  62 total,   3 running,  59 sleeping,   0 stopped,   0 zombie
    Cpu(s): 70.9%us,  2.0%sy,  0.0%ni,  0.0%id, 27.1%wa,  0.0%hi,  0.0%si
    Mem:   594.219M total,  304.293M used,  289.926M free, 4268.000k buffers
    Swap: 1983.992M total,   88.387M used, 1895.605M free,  248.055M cached

      PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
     1978 dalilah   20   0 65896  48m  864 R 86.7  8.2   0:10.17 bwa
     1979 dalilah   20   0 17940 1240  812 S 11.3  0.2   0:01.95 samtools
     1980 dalilah   20   0 66492  48m  724 S  1.7  8.1   0:00.25 samtools
        1 root      20   0 19356 1544 1240 S  0.0  0.3   0:00.69 init
        2 root      20   0     0    0    0 S  0.0  0.0   0:00.00 kthreadd

There's undoubtly a lot going on here, but let's take a look at the most
important parts. The manual for `top` are quite dense, so I'll cover the most
commonly used sections. The very first line covers the uptime (22 minutes), how
many users are on the system, and the *load averages*. Loads in Unix systems
are given as three numbers: the load in the past one minute, five minutes, and
fifteen minutes. The number ranges from 0 to over 1, but the interpretation
depends on how many *cores* your processor has, and what's holding up
processes. When we run bioinformatics programs, we can hit different
bottlenecks: memory running out requiring we use swap space, reading large
files from a slow disk, waiting for BLAST results to be recieved over the
network from another machine, or actually processing done in the CPU. In cases
where we have many processes all trying to use our CPU, we will see the load
average rise. Processes will have to wait for their turn to use our CPUs, and
this can lead to slow behavior. This is why if we have a single processor
machine, we don't want to use GNU Parallel or `xargs` in parallel: it would
create two processes that would have to weight on each other to share the only
CPU.

On a two core system, a load average of 2 means that both CPU cores are
constantly working over a given time period (in the load average case, one,
five, or fifteen minutes). A load average over 2 means that now processes are
having wait for each other. Under 2 means that our CPU has periods where it's
not doing processing. Load averages are a very important statistic to look at
when running large bioinformatics jobs because they could give you a hint if
you're doing too much at once, and maxing out your CPU (load average above the
number of cores you have), or if processes have been running for a while and
load average is low, this could indicate something else (disk, memory, or
network) is a the bottleneck.

The next line breaks gives you the number of processes broken down by state
(running, sleeping, etc), which we saw in `ps aux`'s output per process. The
third line is another important one: it specifies what the CPU spent its time
on since the last update of `top`. In our example, we see it spent 70.9% of
it's time in "us", 2% of it's time in "sy", and 27.1% of its time in "wa".
There are many options that we don't need to go into too much detail about (see
the manual if you are curious), but it's worth know that Unix systems divide up
userland ("us") and system ("sy"), and most of our data crunching
bioinformatics work will tax our userland resources. More importantly, Linux
`top` gives "wa", which is the percent of time the CPU is waiting on other
stuff, and a consistenly high percent "wa" is a good warning sign something
other than CPU is the bottleneck.

The next too lines cover memory and swap space usage. This machine has
physically more than 594 megabytes of memory, but this is the amount accessible
to the operating system. The amount of free memory can be an indicator as to
whether we're running out of memory and our machine is about to hit the much
slower swap space.

The next lines are each process running, and a summary of their process ID
(`PID`), who started them (`USER`), their priority (`PR`), the amount of
virtual and physical memory (`VIRT` and `RES`, repsectively), the state (`S`),
percentage CPU and memory usage (`%CPU` and `%MEM`), the time running
(`TIME`), and finally the actual command (`COMMAND`). We had many of these same
columns with `ps aux`, but a big advantage with `top` is that we can
interactively sort them and watch them update. Recall that your bioinformatics
processes may need lots of memory one minute, then start getting CPU-hungry the
next, and finally start reading gigabytes of information off the disk. We can
watch our process's resource requirements live with `top`.

Particularly useful is being able to sort this live in `top` (and for
completness, note this is possible with `ps` too). To sort by memory, just
press `O` (capital letter "o"), which brings up a list of possible sort fields.
One of these fields is `%MEM`, and corresponds to the letter "n" (recall, this
is only Linux `top`, consult `man top` if your version is different). Pressing
"n", then enter will resort your `top` process list by memory usage. Other
options I commonly use are "K" for CPU usage, "p" for swap size, "e" for user
name, and "l" for CPU time. If your machine is running slowly, using `top`
interactively to find greedy processes should be the first place to start.

### Interacting with Processes Through Signals: Using Kill

If you've used `ps aux` and `grep` to find a particular program, or
you've spotted a greedy process with `top`, you can kill or set its
priority using the Unix tools `kill` and `renice` respectively.

The command `kill` is used to send signals to running processes. The
default signal it sends to a running program is to terminate a
program. A _signal_ is a way to communicate with a running
process. The termination signal, called `SIGTERM`, and we can
terminate a program called "greedy_cmd" by first getting its process
ID with `ps aux` and `grep` (or through `top` too) and then using
`kill`:

    $ ps aux | grep "greedy_cmd"
    vinceb  10141   99.0  0.0  9235248  428 s004  U+  1:48PM  0:00.00 greedy_cmd
    $ kill 10141

However, programs can choose how they wish to handle a `SIGTERM`. Some
programs could even ignore a termination signal entirley, although
this is not common practice with most programs we'll use. Still,
sometimes you'll need to send a more forceful signal like `SIGKILL`,
which can't be ignored by programs. To specify the signal with `kill`,
we use `kill -s SIGKILL 10141`

If you've used Unix for a while, you've probably run across pressing
control-C to stop a program. This sends another common signal called
`SIGINT`, of which the the "int" is short for interupt. `kill -s
SIGINT` is the same as pretty control-C in the same terminal as a
program is running. If you've ever used control-Z (for suspend), this
is very similar too, as it sends the signal `SIGSTP`. `SIGSTP` is an
signal that suspends a process. Suspending a process pauses it, and
this paused process can then be changed to run in the background or
foreground with the `jobs`, `bg`, and `fg` commands we learned
earlier.

Most of the time when we're using `kill` we're not using it to send
these other signals to processes, we're trying to quickly kill an out
of control command that's using too many resources. For this, `kill
-s SIGKILL <pid>` is the standard tool we reach for. Signals also
have numeric shortcuts, and 9 corresponds to `SIGKILL`, so `kill -9
<pid>` does the same thing.

### Prioritizing Processes: Using Nice and Renice

Resources are finite on even our most powerful servers, so it's necessary to
mind how many resources are being used by programs. This is especially the case
with Unix machines which multitask, running many processes simultaneously. Since
multitasking is such a core part of Unix (and Unix comes from an era of
comparatively slower machines with fewers resources), there's a way to
prioritize certain processes: through a process's *nice* value.

The nice value of a process ranges from -20 to 20 (19 on some systems), where a
lower nice value gives a process _more_ priority. A good way to remember this is
that a lower nice value means a program isn't being nice to other processes, and
is instead using all the CPU resources for itself. A very high nice value like
19 tells your operating system that this process is pretty low priority, so it
should run it whenever resources are available. Note that the nice value only
affects how much CPU priority a process gets. Memory or disk-bound processes
will not gain much from getting a lower nice value.

The default nice value a process is 0, but this can be set by a using
the command `nice` to run a program under a specified nice value.
Good usage examples include tasks like backups, system updates, or
archiving old projects. For example, if you want to run gzip on a
large FASTQ file in the background, with lower priority, you would use
`nice`:

    $ nice -n 10 gzip zmaysA_R1.fastq

This runs the command `gzip zmaysA_R1.fastq`, incrementing the default
value of 0 to 10. If we have an already running process, we could
adjust its nice value with the command `renice`, which takes a nice
value and a process ID, like: `renice 10 <pid>`. This sets the nice
value of the process with ID `<pid>`.

As more cores are packed into modern CPUs, CPUs are less likely to be
the bottleneck than the disk or memory. Nice is handy, but it's not
can't work miracles on heavily-taxed systems. If a program is hanging,
or your system feels sluggish, it's very important to use `top` to
monitor CPU and memory usage. Somewhat surprisingly for beginners in
large data processing, the disk is usually the culprit for processing
bottlenecks, so in the next section we'll look at a way to monitor
disk input and output.

### Monitoring Disk Input and Output

It's not uncommon for the disk to be the bottleneck in bioinformatics.
Unfortunately, monitoring disks is a bit tricky, as intepretating the results
can depend quite a bit on your actual hardware. Some readers may wish to skip
this section, and revisit it if they experience a sluggish system that appears
to have free memory and CPU. Also, as with `top`, we'll focus on the Linux
`iostat`, which is the version more likely to be found on the large Linux
servers we do bioinformatics on.

Below is an example of a single disk that's facing too likely too much usage.
Using the `iostat` command without any arguments, we see that there's around
42% usage (this is a single core system), and around 51% of the time the CPU is
_waiting_ for I/O tasks to complete. In this case, we see that the disk, and
not the CPU would likely the cause of a sluggish process.

    $ iostat
    avg-cpu:  %user   %nice %system %iowait  %steal   %idle
              41.52    0.00    7.59   50.89    0.00    0.00

    Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
    xvdap1           59.83       528.73      4310.89    1002588    8174440

Additionally, for each disk, `iostat` outputs the transfers per second
(`tps`), block reads and writes per second (`Blk_read/s` and
`Blk_wrtn/s`), and total blocks read and written (`Blk_read` and
`Blk_wrtn`). For simple monitoring, we need to primarily look at
`iostat` (to see if there CPU is waiting for disk I/O), and then
`Blk_read/s` and `Blk_wrtn/s` to see if the disk usage is reading or
writing. Additionally, if you wish to continually monitor disk
activity, `iostat` can be run with two optional arguments, the
interval at which a report is generated, and the number of reports to
generate. For example, we could generate three reports continually (until we
exit with Control-C) in 10 seconds intervals with: `iostat 10 3`

If it's unclear which processes are the cause of increased I/O another
useful Linux program can help: `iotop`. Like the `top` we used earlier
to monitor memory and CPU usage, `iotop` updates at a fixed interval,
and indicates which processes have the highest disk I/O usage:

    $ iotop
    Total DISK READ: 37.67 M/s | Total DISK WRITE: 35.43 M/s
    TID PRIO  USER  DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
    85  be/4 violet  2.37 M/s    0.00 B/s  0.00 % 94.97 % biocmd in.fa -o out.txt
    89  be/4 lauren  35.30 M/s   34.72 M/s 0.00 % 56.23 % gzip ref.fa
      1 be/4 root    0.00 B/s    0.00 B/s  0.00 %  0.00 % init
      6 rt/4 root    0.00 B/s    0.00 B/s  0.00 %  0.00 % [migration/0]
      7 be/0 root    0.00 B/s    0.00 B/s  0.00 %  0.00 % [cpuset]
      8 be/0 root    0.00 B/s    0.00 B/s  0.00 %  0.00 % [khelper]
      9 be/4 root    0.00 B/s    0.00 B/s  0.00 %  0.00 % [kdevtmpfs]

Here, the imaginary program `biocmd` appears to be competing with gzip for
disk input and output. Gzip is reading and writing a fair amount, whereas
`biocmd` is spending nearly 95% percent of its time waiting for disk I/O.

Finally, a word about disks. Monitoring can only help so much, and it's
possible that under normal bioinformatics loads, some servers disk hardware
won't be able to keep up. Often systems administrators use RAID (Redundany
Array of Indepedent Disks) systems, which can increase disk I/O performance and
redundancy against failure. These topics are outside the scope of this book,
and in cases where disk I/O are common and continual, it may be worth
discussing disk hardware options with the person managing your servers (if it's
not you).

### Disk Usage

When processing bioinformatics data, it's not uncommon to fill up entire disk
volumes. As disks fill up, they also become more fragmented, meaning that they
write data to the disk in non-consecutive chunks. Disk fragmentation leads to
slower disk performance; disks pushing 80% full not only run a risk of being
filled up during data processing, but even performance tasks not requiring lots
of disk space will suffer. Thus, it's useful to monitor disk usage
periodically.

The two tools used to look at disk usage are `df` and `du`. The first, `df`
simply gives you a terminal-based display of your disk usage, broken down by
volume. Since I don't like having to trying to count the digits in figures like
"51228178" bytes (the default unit), I almost always the `-h` option to
display the units in human readable format. On the machine I'm on now, this
looks like:

    $ df -h
    Filesystem                  Size  Used Avail Use% Mounted on
    /dev/sda1                   854G   32G  779G   4% /
    none                        4.0K     0  4.0K   0% /sys/fs/cgroup
    udev                         32G  4.0K   32G   1% /dev
    tmpfs                       6.3G  372K  6.3G   1% /run
    nas-8-0:/export/1/vinceb     11T  2.6G   11T   1% /home/vinceb

Note that there are some file systems in this output that look strange, like
`none` and `tmpfs`. Many Unix-like operating systems use some virtual disks.
This all goes back to how files can be abstracted under Unix-like operating
systems. Real disks, like `/dev/sda1`, are interfaced with device files in
`/dev` on Unix (as well as the psuedo-devices like `/dev/null` we saw in the
redirection section above).

The command `df` is relatively straight forward: it lists the file system size,
the amount used, available, and the percent used, as well as where the file
system is mounted. _Mounting_ file systems allows us to access them through a
certain point on the Unix filesystem. For example, `/home/vinceb` is mounted to
a directory on nas-8-0, a Network Attached Storage device in the example above.
In day-to-day work, it's usually good to check that disks aren't getting too
full before running large data processing tasks.

However, now assume you've found that your disk is getting too full, and you
want to figure out which files are using the most disk space. One command
that's useful in finding large files is `du`, which recursively lists the sizes
of the file in the directory it's being run. For example, if you suspect that
there are some large files in a project directory named
`~/Projects/tarsier_genes`, you could use `du` to find which directories
contain the largest files:

    $ du -h ~/Projects/tarsier_genes
    20M    /home/vinceb/Projects/tarsier_genes
    64K    /home/vinceb/Projects/tarsier_genes/notes
    20M    /home/vinceb/Projects/tarsier_genes/data/
    640G   /home/vinceb/Projects/tarsier_genes/data/alignments

Clearly, there's some big files in our project `alignment/` directory we may
want to delete or compress with a program like `gzip`.

The program `du` can also be combined with `sort` and `head` to find the
largest files on a Unix system. This is a good example of how Unix pipes allow
many small programs to be connected to create useful other programs. If we run
`du /`, it will output the size of the contents for each directory below
`/` (recursively). With `/`, this will be a lot of directories, and
since we only care about the largest ones, we use `sort` with the `-n`
option to numerically sort the lines, and to do so `-r` in reverse order
so the largest files are at the top). Then, we pipe all output to `head -n 10`
to only give us the top five directories containg the most content. Note that
we can't use human readble formats (`-h`) anymore, since numeric sorting
doens't understand suffixes like "K" and "M" for kilobytes and megabytes. On
some BSD-variant systems, it may be necessary to explicitly say that you want
sizes in one unit with (`-m`). The basic command would like like:

    $ du / | sort -r -n | head -n 5
    2036816991542 /
    411030308497 /share/data/genomes
    19390538953 /Users
    1042908919 /Users/lauren
    1041811032 /Users/lauren/s_cereale_genome

Note that `du` is hierarchical, so there will be some redundancy as the
directory containing many large files, as well as the directory containg this
directory, and so on are all included. Finding large files is a common problem,
and specialized programs are also u













