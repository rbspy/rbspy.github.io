# Benchmarking your code

People who are just getting started making their code faster sometimes confuse **benchmarking** and
**profiling**. Let's explain the difference and how to use both techniques to make your code faster!

In short: a benchmark tells you **how slow** your code is ("it took 20 seconds to do X Y Z") and a
profiler tells you **why it's slow** ("35% of that time was spent doing compression").

## What's benchmarking? Why is it important?

Optimizing code is often very counterintuitive -- often I'll have a great idea for how to make my
code faster, and it'll turn out to make almost no difference at all in practice. So when optimizing,
it's extremely important to have objective standards you can measure your changes against!

A **benchmark** is a test that you run to measure how fast your code is. For example, if I have a
compression library, I might test how long it takes to compress a given 100MB file. Or if I was
working on Jekyll's performance (a static site generator), I might take a specific large site and
benchmark how long Jekyll takes to render that site.

If you can run the benchmark on your dev machine, you can make changes, see "oh, that didn't make
any difference!", and then quickly try out a different approach.

## Run your benchmarks more than once

Suppose you run your benchmark and it takes 6 seconds. You make some optimizations and run it again,
and afterwards it takes 5.7 seconds. That's a 5% performance improvement, right? Not huge, but not
nothing?

Not necessarily!

Here's a real benchmark from my computer (generating a Jekyll site), and how long it took (in
seconds) across 10 different runs:

```
5.94
6.00
6.04
5.98
6.15
6.37
6.14
6.20
5.98
6.18
6.22
6.04
6.16
```

When I ran it 100 times, there was even more variation -- sometimes it would take up to 9 seconds
(for instance if I was using a lot of CPU).

So the same benchmark, on the same computer, can take anywhere between 6 to 9 seconds.
This means that if, for this benchmark, I see a performance improvement of less than 0.5 seconds
(~10%) or so, it's worth being suspicious.

We don't have time here to do a rigorous discussion of statistics and benchmarking, but here are a
few guidelines:

* be suspicious of small performance improvements (like 5% or 10%). The smaller the performance
  improvement you're trying to verify, the more times you need to run your benchmark to be sure that
  it's real.
* running any benchmark 10 times instead of just once is a good way to get an idea of how much
  natural variation that benchmark has.

If you're interested in taking a more statistically rigorous approach, a good starting point is to
look up "bootstrap confidence intervals", which is an easy computational way (very little math!) to
get confidence intervals.

## Using benchmarking + profiling to make your code faster

There are basically 2 typical workflows you can use when optimizing your code. Basically: you can
either profile a benchmark of your code, or you can profile your code running in production.

Both of these techniques are basically the same: measure your code's speed somehow, profile it, come
up with potentially faster code, and then measure again afterwards to see if it actually worked!

The most important tip here is: **don't use profiler results to figure out if your optimization
worked, use benchmark results**. Using benchmark results will help you make sure that your
optimization actually makes a significant improvement to the program's performance as a whole.

### Technique 1: Benchmark locally

1. Realize something is slow ("oh no, this computation is taking SO LONG, why??")
1. Create a **benchmark** that you can run locally that demonstrates the slow behavior. This doesn't
   need to be complicated!
1. Run your benchmark (10 times!) to get a baseline for how long it takes
1. Profile the benchmark.
1. Implement a fix
1. Run your benchmark again to see if your fix worked!

### Technique 2: Monitor production performance

This technique has a little less of the scientific rigor that you get when you make a benchmark, but
often making a benchmark isn't practical! A lot of things happen in production that are hard to
reproduce, but you need to figure out why they're happening anyway.

1. Realize something is slow (your users are complaining about performance!)
2. Find a way to monitor the slow thing in production with your favorite monitoring tool (graphite,
   datadog, new relic, whatever)
3. Profile the code running in production
4. Implement a fix and deploy it to a test environment or to production
5. Use your monitoring to see if the performance improved!
