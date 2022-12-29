+++
slug = "rust-fast-builds"
title = "Rust: Fast Builds"
date = 2022-12-16
image = "image.jpg"
+++

If you regularly program in languages like Go, Ruby, Python, JavaScript, or
other scripting and fast-to-build languages you probably live in a utopia of
build time. Gone are the days of sitting around waiting for the computer to turn
things I've typed into executable programs...or so I thought.

This year I started programming in Rust, and while the language is an amazing
innovation in so many ways, it has felt like 10 steps backwards in developer
experience. Specifically in terms of build times. Once again [xkcd] rang true.

[xkcd]: https://xkcd.com/303/

After trying lots of different things people suggested for speeding up builds
I've found the following two things are what make the biggest difference for
my projects.

## 1. Buy a fast machine

When I compare the performance of an older Apple Intel with a newer Apple
Silicon M1MAX, the difference is stark. It's difficult to put a price on how
much time I've saved just waiting for code to build, or time I've saved by not
losing flow state from waiting.

## 2. Use [`sccache`] to cache build artifacts

[`sccache`]: https://github.com/mozilla/sccache

It's as easy as:
```console
cargo install sccache
```

Or:

```console
brew install sccache
```

Then place the following in your shell files:
```
export RUSTC_WRAPPER="$(which sccache)"
```

The next times you build, build artifacts will be cached in a single global
cache, which means caching across projects.

---

_There are some other things I've seen others recommend, like using RAM disk, or
alternative linkers like `zld`. I've tried them, and I found no or minimal
benefit in them on the projects I work on with the hardware I have. If you don't
have a fast SSD then a RAM disk might be an improvement. You might want to
explore them, they just haven't yielded a benefit for me._

---
