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
