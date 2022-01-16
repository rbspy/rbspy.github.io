# Record

Record continuously captures stack traces from your process and saves them to disk. This is what you want to use when profiling a program over a period of time, or when you want to produce a flamegraph or other output for offline analysis.

`rbspy record` will save 2 files: a gzipped raw data file, and a visualization (by default a flamegraph, you can configure the visualization format with `--format`). The raw data file contains every stack trace that `rbspy` recorded, so that you can generate other visualizations later if you want. By default, rbspy saves both files to `~/.cache/rbspy/records`, but you can customize where those are stored with `--file` and `--raw-file`.

This is useful when you want to know what functions your program is spending most of its time in.

You can record stack traces in two different ways, by PID or by executing a new ruby process.

## Record by PID

```
# Must be run as root
sudo rbspy record --pid $PID
```

## Record by executing the process through rbspy

```
# Must be run as root on Mac (but not Linux)
rbspy record ruby myprogram.rb
# Put `--` after record if your program has command line arguments
rbspy record -- ruby myprogram.rb --log-level 0
```

The reason this has to be run as root on Mac but not on Linux is that Mac and Linux systems APIs are different. rbspy can use the `process_vm_readv` system call to read memory from a child process on Linux without being root, but can't do the same with `vm_read` on Mac.

If run with sudo, `rbspy record` by default drops root privileges when executing a subprocess. So if you're user `bork` and run `sudo rbspy record ruby script.rb`. You can disable this with `--no-drop-root`.

## Optional Arguments

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
