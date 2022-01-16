# rbspy vs StackProf

[rbspy](https://github.com/rbspy/rbspy) and [StackProf](https://github.com/tmm1/stackprof) are both
sampling profilers for Ruby. They both let you generate flamegraphs. So when should you use rbspy,
and when should you use stackprof?

The two tools are actually used in pretty different ways! rbspy is a command line tool (`rbspy record --pid YOUR_PID`),
and StackProf is a library that you can include in your Ruby program and use to profile a given
section of code.

### When to use rbspy

rbspy profiles everything a given Ruby process is doing -- you give it a PID of a Ruby process, and
it profiles it. It's useful when:

* You don't want to edit your code to start profiling
* You have a Ruby program that you didn't write that you want to quickly get profiling information about (eg Chef / Puppet)
* You want to quickly profile a Ruby script (how to do it: `rbspy record ruby my-script.rb`)

One common use case for rbspy is profiling slow unit test runs -- instead of spending a bunch of
time adding instrumentation, you can run `rbspy record ruby my-test.rb` and instantly get profiling
information about what's going on.

### When to use StackProf

[StackProf](https://github.com/tmm1/stackprof) requires more work to set up, and gives you more
control over which code gets profiled.  It's best when you want to profile a specific section of
your code, or only want to profile certain HTTP requests. 

Here's what editing your code to use StackProf looks like

```
StackProf.run(mode: :cpu, out: 'tmp/stackprof-cpu-myapp.dump', raw: true) do
    # code you want to profile here
end
```

Here are the steps to using StackProf:

1. Add the `stackprof` gem to your Gemfile
1. Edit your code to call StackProf and save data to the right file
1. Use `stackprof` to summarize the reported data from the 

A more batteries-included way of doing profiling if you have a Rails/Rack program is to use
[rack-mini-profiler](https://github.com/MiniProfiler/rack-mini-profiler). It uses StackProf under
the hood to do CPU profiling as well as supporting memory profiling. [Here's a blog post about
rack-mini-profiler](https://www.speedshop.co/2015/08/05/rack-mini-profiler-the-secret-weapon.html).
