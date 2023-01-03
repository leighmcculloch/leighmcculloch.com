+++
slug = "tantalizing-go-proposals-in-jan-2023"
title = "Go: Proposals that are Tantalizing in January 2023"
date = 2023-01-02
image = "image.jpg"
+++

I like programming in Go, just the way it is. I said the same thing when I first
started playing with it in 2015 and now in 2023. But I have to admit every new
feature that has been added has been awesome. I can't imagine now programming in
Go without things like Go Modules, built-in fuzzing, etc.

So my current contentment aside, I am looking forward to seeing these Go
proposals evolve into things that we might see in the language, tooling, etc
someday.

Ordered by my current level of interest.

- **[#19623]: change int to be arbitrary precision**

   Arbitrary sized integer types built-in to Go would, I feel like, be very
   in-line with Go's existing pattern of taking good things from Ruby, Python,
   and similar landscape. When I program in Ruby this is one of those joys that
   exists in that language that's just there. When I reach for `int` in Go, I'm
   not reaching for the system's word-size – even if that's what it is – I'm
   usually reaching for the most convenient largest integer size to avoid
   overflow. The fact that Go has sized types too like `int32` means that
   control is still there for those situations where I really am intentionally
   wanting a specific size. Go is a programming language for productivity and
   there's a reason arbitrary sized integers show up in other languages known
   for productivity too.

- **[#43557], [#56413]: user-defined iteration using range over func values**

   I have a hard time figuring out the right way to use iterators in Go. The
   stdlib has a ton of them, and each time I go to use one I read the docs, look
   at examples, and try and craft the loop and use of values just the right way
   for that specific iterator. They aren't all the same. I think this causes
   some people to think we need a common interface for iterators in Go. I don't
   know if we need that, but I do feel like if we had a way to write functions
   that could be used with `for`, then that would go a long way to let people
   write iterators however they'd like, and present them in a way that anyone
   could use them one way.

- **[#20733]: redefine range loop variables in each iteration**

   I've made this mistake too many times. It feels like something worth fixing.

- **[#19814]: add typed enum support**

   I'm regularly emulating enums using types and constants in Go. This actually
   works mostly fine, but if Go had enums I'd use them. The benefit I'd expect
   is validation on parsed values reducing runtime errors in areas of the code
   separate to when the value is created. It's so easy to introduce invalid enum
   values in Go applications today if as the developer you aren't diligent about
   validating the enum value after it exists. Unfortunately it's so easy to
   think that in a static langauge that strongly typed enum must be valid, when
   it might not be.

- **[#19412], [#54685]: add sum types / discriminated unions**

   I'm not very excited by either of these proposals, but I am by the general
   premise of some way of defining small closed set types, like interfaces, but
   not open, and not discriminated by their types.

   I frequently work with the [Stellar XDR] (See [RFC 4506]) and XDR contains
   discriminated union types. In languages like Go this ends up being
   represented as structs with a discriminant field, then a pointer-field per
   type. It works, but it's also a lot of work, easy to footgun if you aren't
   diligent with checking you exhaustively addressed all types.

   The proposal I was most intrigued with was [#41716] which proposed sum types
   via interface type sets, but it discriminated by type and not on a separate
   list of values, which I think is important for not unnecessarily constraining
   the use space.

- **[#47487]: allow explicit conversion from function to 1-method interface**

   Go has a nice pattern of being able to turn functions into interfaces, but it
   requires a significant amount of boilerplate and it'd be convenient if that
   wasn't required.

<!-- - [#9455]: add support for int128 and uint128 -->

<!-- - [#6386]: allow constants of arbitrary data structure type -->

[#19623]: https://github.com/golang/go/issues/19623
[#9455]: https://github.com/golang/go/issues/9455
[#47487]: https://github.com/golang/go/issues/47487
[#56413]: https://github.com/golang/go/discussions/56413
[#20733]: https://github.com/golang/go/issues/20733
[#19412]: https://github.com/golang/go/issues/19412
[#19814]: https://github.com/golang/go/issues/19814
[#43557]: https://github.com/golang/go/issues/43557
[#54685]: https://github.com/golang/go/issues/54685
[#6386]: https://github.com/golang/go/issues/6386
[#41716]: https://github.com/golang/go/issues/41716
[Stellar XDR]: http://github.com/stellar/stellar-xdr
[RFC 4506]: https://datatracker.ietf.org/doc/html/rfc4506
