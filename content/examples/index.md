+++
title = "Profiling examples"
description = ""
keywords = []
categories = []
+++

## The case of the slow unit test

To get an idea of how rbspy can help you do profiling, let's do a couple of quick examples!

```
$ wget http://rbspy.github.io/examples/slow_test.rb
$ ruby slow_test.rb
Loaded suite static/examples/test
Started
.

Finished in 4.001482979 seconds.
```

Why is this test taking 4 seconds to run? Let's run rbspy!

```
$ rbspy record ruby slow_test.rb
Summary of profiling data so far:
% self  % total  name
 96.98    96.98  slow_function - static/examples/slow_test.rb
  1.26     1.76  require - /usr/lib/ruby/2.3.0/rubygems/core_ext/kernel_require.rb
  0.50     1.01  <top (required)> - /usr/lib/ruby/2.3.0/rubygems.rb
  0.25     0.50  <module:Gem> - /usr/lib/ruby/2.3.0/rubygems.rb
  0.25     0.25  block in make_switch - /usr/lib/ruby/2.3.0/optparse.rb
  0.25     0.25  block in <module:NoWrite> - /usr/lib/ruby/2.3.0/fileutils.rb
  0.25     0.25  block in <class:SexpBuilder> - /usr/lib/ruby/2.3.0/ripper/sexp.rb
  0.25     0.25  <top (required)> - /usr/lib/ruby/2.3.0/rubygems/specification.rb
```

It's spending 96% of its time in `slow_function`! What's that?

```

def slow_function
    sleep(4)
    return 4
end
```

`slow_function` sleeps for 4 seconds! That's why our tests are slow.

This is obviously a manufactured example, but this technique (run `rbspy record`, see which function
all the time is being spent in, figure out why) is helpful when you code is taking WAY longer than
you think it should (for instance something that should take 2 seconds is taking 5 minutes).

## The case of the Selenium test

```
$ wget http://rbspy.github.io/examples/selenium.rb
$ time ruby selenium.rb # requires a bunch of dependencies to be installed
```

```
require 'rubygems'
require 'headless'
require 'selenium-webdriver'

Headless.ly do
  driver = Selenium::WebDriver.for :firefox
  driver.navigate.to 'http://google.com'
  puts driver.title 
end
```

```
  0.00    88.13  request - /home/bork/.rbenv/versions/2.4.0/lib/ruby/2.4.0/net/http.rb
```


## The case of the slow download

```
$ wget http://rbspy.github.io/examples/mystery_download.rb
$ time ruby mystery_download.rb
0.09user 0.00system 0:02.13elapsed 4%CPU (0avgtext+0avgdata 11576maxresident)k
```

2 seconds! Why is this program taking 2 seconds? Again, let's start by running `rbspy record`!

```
$ rbspy record ruby mystery_download.rb
Time since start: 2s. Press Ctrl+C to stop.
Summary of profiling data so far:
% self  % total  name
 95.94    95.94  block in connect - /usr/lib/ruby/2.3.0/net/http.rb
  2.03     2.03  require - /usr/lib/ruby/2.3.0/rubygems/core_ext/kernel_require.rb
  0.51    99.49  <c function> - unknown
  0.51     0.51  expand - /usr/lib/x86_64-linux-gnu/ruby/2.3.0/rbconfig.rb
  0.51     0.51  base_dir - /usr/lib/ruby/2.3.0/rubygems/specification.rb

Wrote raw data to /home/bork/.cache/rbspy/records/rbspy-2018-03-20-udS4Y8WHgj.raw.gz
Writing formatted output to /home/bork/.cache/rbspy/records/rbspy-2018-03-20-KZlFL4Jx8Q.flamegraph.svg
```

This tells us 95% of the time is being spent in `connect`

<a href="/examples/slow-network.svg">
<img src="/examples/slow-network.svg">
</a>


## Profiling Jekyll

<a href="/examples/jekyll-flamegraph.svg">
<img src="/examples/jekyll-flamegraph.png">
</a>
