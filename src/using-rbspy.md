# Using rbspy

# Subcommands

`rbspy` has 3 subcommands: `snapshot`, `record`, and `report`.

## Snapshot

Snapshot takes a single stack trace from the specified process, prints it, and exits. This is
useful if you have a stuck Ruby program and just want to know what it's doing right now.  Must be
run as root.

```
sudo rbspy snapshot --pid $PID
```

## Record

Record records stack traces from your process and saves them to disk.

`rbspy record` will save 2 files: a gzipped raw data file, and a visualization (by default a flamegraph, you
can configure the visualization format with `--format`). The raw data file contains every stack
trace that `rbspy` recorded, so that you can generate other visualizations later if you want. By
default, rbspy saves both files to `~/.cache/rbspy/records`, but you can customize where those are
stored with `--file` and `--raw-file`.

This is useful when you want to know what functions your program is spending most of its time in.

You can record stack traces in two different ways, by PID or by executing a new ruby process.

### Record by PID

```
# Must be run as root
sudo rbspy record --pid $PID
```

### Record by executing the process through rbspy

```
# Must be run as root on Mac (but not Linux)
rbspy record ruby myprogram.rb
# Put `--` after record if your program has command line arguments
rbspy record -- ruby myprogram.rb --log-level 0
```

The reason this has to be run as root on Mac but not on Linux is that Mac and Linux systems APIs are
different. rbspy can use the `process_vm_readv` system call to read memory from a child process on
Linux without being root, but can't do the same with `vm_read` on Mac.

If run with sudo, `rbspy record` by default drops root privileges when executing a subprocess. So if
you're user `bork` and run `sudo rbspy record ruby script.rb`. You can disable this with
`--no-drop-root`.

### Optional Arguments

These work regardless of how you started the recording.

 * `--rate`: Specifies the number of stack traces that are sampled per second. The default rate is 100hz.
 * `--duration`: Specifies how long to run before stopping rbspy. This conficts with running a subcommand (`rbspy record ruby myprogram.rb`).
 * `--format`: Specifies what format to use to report profiling data. The options are:
   * `flamegraph`: generates a flamegraph SVG that you can view in a browser
   * `speedscope`: generates a file to drop into https://www.speedscope.app/ to interactively explore flamegraphs
   * `callgrind`: generates a callgrind-formatted file that you can view with a tool like
     `kcachegrind`.
   * `summary`: aggregates % self and % total times by function. Useful to get a basic overview
   * `summary_by_line`: aggregates % self and % total times by line number. Especially useful when
      there's 1 line in your program which is taking up all the time.
 * `--file`: Specifies where rbspy will save formatted output.
 * `--raw-file`: Specifies where rbspy will save formatted data. Use a gz extension because it will be gzipped.
 * `--flame-min-width`: Specifies the minimum flame width in flamegraphs as a percentage. Useful for excluding functions that appear in a small number of samples.
 * `--nonblocking`: Don't pause the ruby process when collecting stack samples. Setting this option will reduce the performance impact of sampling but may produce inaccurate results.
 * `--subprocesses`: Record all subprocesses of the given PID or command.
 * `--silent`: Don't print the summary profiling data every second.

## Report

If you have a raw rbspy data file that you've previously recorded, you can use `rbspy report` to
generate different kinds of visualizations from it (the flamegraph/callgrind/summary formats, as
documented above). This is useful because you can record raw data from a program and then decide how
you want to visualize it afterwards.

For example, here's what recording a simple program and then generating a summary report looks like:

```
$ sudo rbspy record --raw-file raw.gz ruby ci/ruby-programs/short_program.rb
$ rbspy report -f summary -i raw.gz -o summary.txt
$ cat summary.txt
% self  % total  name
100.00   100.00  sleep [c function] - (unknown)
  0.00   100.00  ccc - ci/ruby-programs/short_program.rb
  0.00   100.00  bbb - ci/ruby-programs/short_program.rb
  0.00   100.00  aaa - ci/ruby-programs/short_program.rb
  0.00   100.00  <main> - ci/ruby-programs/short_program.rb
```

# Containers

If you want to profile a ruby program that's running in a container on Linux, be sure to add the
`SYS_PTRACE` capability. For Docker containers, this can be done by adding a flag to the command
when you launch the container:

```
docker run --cap-add=SYS_PTRACE ...
```

If you're using Kubernetes, you can add the ptrace capability to a deployment like this:

```
securityContext:
  capabilities:
    add:
      - SYS_PTRACE
```

If this doesn't work for you, see [issue 325](https://github.com/rbspy/rbspy/issues/325) for
troubleshooting steps. You may need additional `securityContext` configuration if the processes
in your container are running as an unprivileged (non-root) user, which is recommended for security
reasons.
