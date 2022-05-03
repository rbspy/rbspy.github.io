<img src="../static/images/rbspy.jpg" width="200" height="200">

# rbspy

Have you ever wanted to know what functions your Ruby program is calling? `rbspy` can tell you!

`rbspy` lets you profile Ruby processes that are already running. You give it a PID, and it starts
profiling! It's a sampling profiler, which means it's **low overhead** and **safe to run in
production**.

## Quick start

If you're on macOS, install rbspy with Homebrew:

```
brew install rbspy
```

If you have a working Rust toolchain (1.56 or newer), you can install with cargo:

```
cargo install rbspy
```

Otherwise, check out the [installing](./installing.md) section to get rbspy running on your computer.

## Profiling a Ruby program

If your program is already running, get its PID and profile it like this:

```
rbspy record --pid $PID
```

You can also use rbspy to profile a Ruby script, like this. It works both with and without bundle exec.

```
rbspy record -- bundle exec ruby my-script.rb
```

Here's what running `rbspy record` on a Rubocop process looks like. You'll see a live summary of
what the top functions being run are, and it also saves the raw data + a flamegraph for more in
depth analysis.

<img src="../static/images/rbspy-record.gif">
