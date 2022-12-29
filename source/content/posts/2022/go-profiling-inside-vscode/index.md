+++
slug = "go-profiling-inside-vscode"
title = "Go: Profiling Inside VSCode"
date = 2022-12-29
image = "image.jpg"
+++

Profiling Go code is a dream. If you've got Go installed, you already have
everything you need to profile code.

Writing benchmark tests and using `pprof` get me a long way in understanding
where my applications are spending their CPU time or memory resources.

There are some articles and blogs that outline how to profile Go code:
- https://medium.com/@felipedutratine/profile-your-benchmark-with-pprof-fb7070ee1a94
- https://go.dev/blog/pprof

Today I learned that The [VSCode Go extension] has a feature built-in for
running a benchmark test with a profile being recorded and then automatically
opening the graphs for it right there in the IDE. This feature isn't a
necessity, but it streamlines my profiling workflow.

To profile a benchmark test, open the testing panel, right-click the benchmark, and select `Go: Test Profile`.

<video width="100%" controls>
  <source src="video.mp4" type="video/mp4">
</video>

_Note: You need graphviz installed to be able to view the profile graphs. On
macOS graphviz can be installed with [Homebrew] and `brew install graphviz`._

[VSCode Go extension]: https://marketplace.visualstudio.com/items?itemName=golang.Go
[Homebrew]: https://brew.sh
