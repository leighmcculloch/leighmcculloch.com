+++
slug = "go-find-slow-tests"
title = "Go: Find slow tests"
date = 2018-11-15
disqus_identifier = "pzhvkyn"
+++

Finding slow tests in Go is not straight forward. There's no built in flag you can pass to `go test` to get it to tell you which tests are slow, or to output a sorted list of durations. Good news! We can join a few tools together to do the job.

For the below you'll need to have installed: `go`, `jq`, `tee`, and `sort`. You'll likely have most of them if you're running linux and the rest can be installed relatively easily.

**Step 1:** Run the tests with verbose json output, without caching.
{{< highlight shell >}}
go test -count=1 -v -json | tee testoutput.txt
{{</ highlight >}}

**Step 2:** Extract from that output a sorted list of tests and their elapsed times.
{{< highlight shell >}}
cat testoutput.txt \
  | jq -r 'select(.Action == "pass" and .Test != null) | .Test + "," + (.Elapsed | tostring)' \
  | sort -k2 -n -t,
{{</ highlight >}}

You should end up with CSV output with two columns, where each row is the name of a test and it's duration in seconds sorted with the longest tests at the bottom. Something like the following.

{{< highlight csv >}}
TestStruct_Function1,0.98
TestStruct_Function3/subtest2,3.39
TestStruct_Function3/subtest1,6.39
TestStruct_Function2,7.01
{{</ highlight >}}

*You could pipe the tests and extract commands together, but assuming your tests take a while it's easier to break these up. Saving the output to file before attempting to pipe them to `jq` allows you to see what's happening, and if you pipe it directly to `jq` that tool will consume stdin until the tests are finished and you won't get any feedback about what is happening.*
