# Questions to ask when optimizing code

When people start looking at profiling data, they're often unsure of where to start.

If you have a slow program that you want to start optimizing, here are a few questions to consider
using your profiling tools to answer.

### Is my program mostly using the CPU or mostly waiting?

If your program is slow, the first most important thing to find out is whether it's slow because
it's using the CPU or if it's slow because it's waiting for the disk or network or something.

If your program is spending 98% of its time waiting for the result of a database query, it's very
possible that you don't need to change your program's code at all, and what you need to do is work
on your database's indexes!

### Is my program swapping memory to disk?

This isn't a question that profilers can answer, but if your program is using a lot of memory (more
than is available on your machine), it's worth checking whether the program is swapping memory to
disk. Swapping will make your program run a lot slower, especially if your swap partition is
encrypted.

### Is there a single function where all the time is being spent?

Sometimes when a program is really unexpectedly slow, there's one function which is overwhelmingly
the culprit. Profilers can tell you what % of your program's execution time was spent in each
function.

When thinking about this question it's useful to understand the difference between "self time" and
"total time" spent in a function -- a lot of profilers (including rbspy) will give you a report like
this:

```
% self  % total  name
  3.05    10.09  each_child_node
  2.52    31.14  block (2 levels) in on_send
  2.17    14.31  do_parse
  1.76     3.28  cop_config
  1.70     2.29  block (2 levels) in <class:Node>
  1.41     1.41  end_pos
```

The **self time** is the percentage of time that function was at the top of the call stack.
Basically -- if the function is doing computations itself (vs calling other functions), it's what %
of time was spent in those functions.

**Looking for functions with high self time can be a good way to find low-hanging fruit for
optimizations** -- if 20% of the time is being spent in a single function's calculations and you
can make that function 90% faster, then you've improved your program's overall speed a lot! For
example, if you have a slow calculation, maybe you can cache it!

The **total time** is the percentage of time that function appeared in a call stack. Basically it's
the % of time spent in the function itself + every other function it called.

Both self time and total time are important to consider -- for example, if I have a function that
does this:

```
def parent_fun
    for x in list1
        for y in list2
            child_fun(x,y)
        end
    end
end
```

your profiler might report that `parent_fun` has 0% "self time" (because all it does is call
`child_fun` over and over again), but maybe it's still possible to optimize the algorithm it uses.

### How many times is function X being called?

If your profiler says that 98% of the time is being spent inside a single function
like `calculate_thing`, you're not done! There are 2 possible cases here:

* `calculate_thing` is taking a long time
* `calculate_thing` is fast, but another function is **calling** that function way too many times.
  No use having a fast function if it's being called 100 million times!

Because rbspy is a sampling profiler (not a tracing profiler), it actually can't tell you how times
a function was called -- it just reports "hey, I observed your program 100,000 times, and 98,000 of
those times it was in the `calculate_thing` function".

[ruby-prof](https://github.com/ruby-prof/ruby-prof) is a tracing profiler for Ruby, which can tell
you exactly how many times each function was called at the cost of being higher overhead.
