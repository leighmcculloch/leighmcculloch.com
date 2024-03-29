---
marp: true
theme: gaia
class: lead invert
---

# Tools for Understanding<br/>Go Module Dependencies

<!--
My talk today is about tools for understanding Go module dependencies.

I'm going to start with a super brief recap on what Go modules are, then we'll dive into the tools.

TRANSITION: What are Go modules...
-->

---

# What are Go modules?

<!--
Go modules is the name given to how dependencies get managed in Go.

A Go module is similar to a Node package, or a Ruby gem, or a Rust crate. It's a collection of one or more directories of code files.

TRANSITION: A Go module defines its dependencies in one file...
-->

---

# go.mod

<!--
If you work on our Go code you'll see a go.mod file.

The go.mod file contains a list of dependencies our application has on other libraries.

Here is one of our go.mod files...
-->

---

# Everything is sweet 🥥<br/><br/><br/><br/><br/><br/>

![bg](unsplash/artem-beliaikin-BsjASVFy6IU-unsplash.jpg)

<!--
This is for the most part all you need to know for 99% general day-to-day development in Go. Everything is sweet... Everything appears to work the way we'd expect it to...

TRANSITION: Eventually we'll come across some gotchas...
-->

---

# Gotcha 1
## go.mod versions aren't the compiled versions

<!--
Go.mod versions aren't the compiled versions.

The version listed in the go.mod for a dependency might not be the version that'll be used at compile time.

If you depend on a library that has a go.mod file referencing v1.1 of another library, you might get a newer version of that other library if there's something else in your dependency tree that requires a newer version.

The versions in the go.mod file are the only minimum version the code requires. The go.mod file doesn't tell us what version we are compiling with.
-->

---

# Gotcha 2
## go.mod does not tell us all our deps

<!--
Go.mod does not tell us about all our dependencies.

Go.mod is only intended to capture direct dependencies and not the dependencies of your dependencies.

In some edge cases indirect dependencies will show up in the file, but that only happens if a dependency doesn't have its own go.mod file. The first time we see the `// indirect` we might think the go.mod is capturing all our dependencies dependencies, but that's not the case.

So a go.mod file is not a snapshot of all the dependencies of your application.
-->

---

# Gotcha 3
## go.mod tells us nothing about indirect deps

<!--
Go.mod tells us nothing about indirect dependencies.

The go.mod file won't tell you what most of your indirect dependencies are, but even if it does for some, it won't tell you what direct dependency is importing them.

All we know is one of your dependencies is importing it, but not which one.

So a go.mod file doesn't tell us why we have dependencies.
-->
---

![bg cover](unsplash/jon-tyson-XmMsdtiGSfo-unsplash.jpg)

---

# Tool 1
## `go list -m all`

<!--
The first one is `go list`. Now this command is really powerful, it has _lots_ of options, it can tell you a lot about your Go code, one being what all the dependencies are.

`go list -m all`

Let's compare the difference with what this command gives us vs what's in the go.mod file.

I'm using master on the stellar/go monorepo:

go mod edit -json | jq -r '.Require[].Path' | wc -l = 87
go list -m all | wc -l = 147

`go list` doesn't only tell us what modules there are, but it also tells us which versions are being used during this compile.

The output of this command can be really useful to track over time. So you'll see in our Go repos we commit a file named `go.list` that is just an output of that command. It helps us see when our dependencies change.
-->

---

# Tool 2
## `go mod graph`

<!--
The next command is `go mod graph`.

This command does one thing.

It prints a line for every module, similar to go list, and a line for every indirect dependency.

This command is really great for understanding why you import something, or which of your dependencies is pulling in the most sub-dependencies.

This is what it looks like.
-->

---

# Tool 3
## `go mod why <pkg>`
## `go mod why -m <module>`
<!--
The final command is `go mod why`.

This command is for understanding why you have a particular dependency.

It'll tell us which packages within our module are importing the dependency, and it'll show us the dependency chain. So if you go mod why C, and A imports B, and B imports C, it'll show us that chain.

go mod why google.golang.org/grpc
go mod why -m github.com/stretchr/testify
-->

---

# Tool 4
## install: `go get github.com/stellar/golistcmp`
## `golistcmp <go list before> <go list after>`
<!--
The final command is `golistcmp`.

This command isn't built in to Go, it's a command that we created. It generates easy to understand comparisons for go list outputs.

So if we upgrade one dependency, and that in turn upgrades many dependencies, golistcmp shows us clearly what all the changing dependencies are, and gives us links to their diffs so that we can understand what is changing.

This command is for understanding why you have a particular dependency.

go get github.com/stellar/golistcmp
go list -m -json all > go.list.before
go get -u github.com/stretchr/testify
go list -m -json all > go.list.after
golistcmp
-->

---

# Recap
## `go list -m all`
## `go mod graph`
## `go mod why`
## `golistcmp`

<!--
And that's it, there are four commands you can use to understand what dependencies you have and why you have them.
-->

---

# Further Reading

alexedwards.net/blog/an-overview-of-go-tooling

golang.org/ref/mod

ardanlabs.com/blog/2019/12/modules-03-minimal-version-selection.html

research.swtch.com/vgo
research.swtch.com/vgo-principles

---

<!-- class: -->

#### Attributions

- Photo of [Man with fresh coconut relaxing](https://unsplash.com/photos/BsjASVFy6IU) by [Artem Beliaikin](https://unsplash.com/@belart84)

- Photo of [Good news is coming](https://unsplash.com/photos/XmMsdtiGSfo) by [Jon Tyson](https://unsplash.com/@jontyson)
