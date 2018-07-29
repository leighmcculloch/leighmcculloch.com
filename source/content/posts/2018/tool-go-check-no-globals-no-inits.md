+++
slug = "tool-go-check-no-globals-no-inits"
title = "Go: No globals, no init functions"
date = 2018-05-21
disqus_identifier = "tklhlbq"
+++

I just created `gochecknoglobals` and `gochecknoinits`. The lint tools scan Go code in the current directory and error if they discover global variables or package-level `init` functions.

I recently saw Dave Cheney's tweet about not using global variables and read Peter Bourgon's in-depth follow up [A theory of modern Go](https://peter.bourgon.org/blog/2017/06/09/theory-of-modern-go.html). The tl;dr is magic code is bad because you need to know more about how it works than is immediate obvious from reading about it's use, and global variables and `init` functions are magic because they carry side-effects through an application that aren't contained by the functions that use or rely on them.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/peterbourgon?ref_src=twsrc%5Etfw">@peterbourgon</a> i present to you my thesis for &quot;modern Go&quot;<br><br>- no side effect imports<br>- no package level variables</p>&mdash; Dave Cheney (@davecheney) <a href="https://twitter.com/davecheney/status/871939730761547776?ref_src=twsrc%5Etfw">June 6, 2017</a></blockquote>

In my experience this tends to be true. Even in small apps I have worked on global variables have resulted in code that is harder to understand, and when I import a package that has an `init` function it surprises me.

This has led me to avoid using globals and `init` whenever I can. As an example both `gochecknoglobals` contained `gochecknoinits` use no globals or inits.

Install:
{{< highlight shell >}}
go get 4d63.com/gochecknoglobals
go get 4d63.com/gochecknoinit
{{</ highlight >}}

Usage:
{{< highlight shell >}}
gochecknoglobals
gochecknoinits
{{</ highlight >}}

Install with `gometalinter`:
{{< highlight shell >}}
gometalinter --update
{{</ highlight >}}

Usage with `gometalinter`:
{{< highlight shell >}}
gometalinter --enable=gochecknoinits --enable=gochecknoglobals ./...
{{</ highlight >}}

Source:

- [github.com/leighmcculloch/gochecknoglobals](https://github.com/leighmcculloch/gochecknoglobals)
- [github.com/leighmcculloch/gochecknoinits](https://github.com/leighmcculloch/gochecknoinits)
