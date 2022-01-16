# Frequently asked questions

## Who makes rbspy?

[Julia Evans](https://jvns.ca) started the project and led its development until 2021.
[Adam Jensen](https://acj.sh) is the primary maintainer. For a full list of contributors,
see the [CONTRIBUTORS file](https://github.com/rbspy/rbspy/blob/master/CONTRIBUTORS.md).

## Who funds rbspy?

Initial rbspy development was funded by [the Segment Open Fellowship](https://segment.com/blog/segment-open-fellowship-2017/) -- they paid for 3 months of
development on the project, to take it from a sketchy prototype to an actual working profiler that
people use to make their Ruby programs faster. Julia took a 3 month sabbatical off work to build it.

This kind of short-term funding is an awesome way to bootstrap new open source projects that might
not happen otherwise! You can do a lot in 3 months :)

## Can I use rbspy in production?

Yes! rbspy only reads memory from the Ruby process you're monitoring, it doesn't make any changes.
Unlike some other statistical profilers, rbspy does **not** use signals or ptrace, so it won't
interrupt system calls your Ruby program is making.

The things to be aware of are:

* By default, `rbspy` 0.6 and newer pauses the ruby process when it's collecting samples. This can
  affect performance, especially if you're using a high sampling rate. You can disable the pausing
  with the `--nonblocking`, but be aware that this can lead to incorrect samples.
  flag.
* `rbspy` does use some CPU. If you use `rbspy record --subprocesses`, it can use a substantial
  amount of CPU (because it'll start a separate thread for every process it's recording)
* disk usage: `rbspy record` will save a data file to disk with compressed stack traces, and if you
  run it for many hours it's possible you'll use a lot of disk space. We recommend giving rbspy a
  time limit, like `rbspy record --duration 10`.

Any bugs in rbspy will manifest as rbspy crashing, not your Ruby program crashing.

## How does rbspy read data from my Ruby processes?

On Linux, it uses the `process_vm_readv` system call, which lets you read memory from any other
running process.

## How does rbspy handle threads?

`rbspy` always collects the stack from what the Ruby VM reports as the currently running thread.
This is because the global VM lock (GVL) only allows one thread to be running Ruby code at any given time. It ignores
threads that are not currently running.

When rbspy is profiling ruby 3 programs, it currently only samples the main ractor.

## Can rbspy profile C extensions?

Yes. Any calls into C will be reported in the format "sleep [c function] - (unknown)".

## I love rbspy! How can I thank you?

It really helps if you add a comment to our [list of testimonials on GitHub](https://github.com/rbspy/rbspy/issues/62) saying how rbspy helped you!

## Is there a similar project for Python?

Yes! [py-spy](https://github.com/benfred/py-spy) by [Ben Frederickson](https://www.benfrederickson.com/) and [pyflame](https://github.com/uber/pyflame) by [Evan Klitzke](https://eklitzke.org/) do
basically the same thing as rbspy, but for Python programs.

## Who made the logo?

[Ashley McNamara](https://twitter.com/ashleymcnamara) was extremely kind and designed it!! She's an
awesome software engineer who also makes delightful stickers. See her 
[gophers repository](https://github.com/ashleymcnamara/gophers) for a bunch of awesome gopher art she's done
for the Go community.
