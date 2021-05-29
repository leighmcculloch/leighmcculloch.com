+++
slug = "go-experience-report-errors-is-as"
title = "Go: Experience Report: errors.Is and errors.As"
date = 2021-05-28
+++

* [Context](#context)
* [Examples](#examples)
* [Confusion](#confusion)
    * [Visual Similarity](#visual-similarity)
    * [Semantic Ambiguity](#semantic-ambiguity)
    * [Surprise Functionality](#surprise-functionality)
* [Final Thoughts](#final-thoughts)

## Context

In Go, since version 1.13, error chains have been inspectable using two
functions, `errors.Is` and `errors.As`.

Both functions search through the chain of errors and return the first matching
error.

These functions are really helpful, especially in applications that wrap errors providing additional context to errors as they bubble back up the stack.

## Examples

Let's assume I have an error `ErrNotFound` that my code returns when an item isn't found:

```go
type ErrNotFound struct {
	UserID   string
	Resource string
}

func (err ErrNotFound) Error() string {
	return "not found: " + err.Resource + " for user: " + err.UserID
}
```

And let's assume that the error is wrapped as it bubbles up the stack:

```go
func Find(/*...*/) (_, error) {
	// ...
	return ErrorNotFound{UserID: "1", Resource: "/items"}
}
```

```go
_, err := Find(/*...*/)
if err != nil {
	return fmt.Errorf("finding item: %w", err)
}
```

We can check if the wrapped error is an ErrorNotFound with:

```go
if errors.As(err, &ErrorNotFound{}) {
```

And we can check if the wrapped error is equal to a specific ErrorNotFound with:

```go
if errors.Is(err, ErrorNotFound{UserID: "1", Resource: "/items"}) {
```

And we can also check if the above error partially matches a ErrorNotFound if it
implements the Is function, which is [functionality promoted on the Go
blog](https://blog.golang.org/go1.13-errors#TOC_4.):

```go
func (err ErrNotFound) Is(target error) bool {
	t, ok := target.(ErrNotFound)
	if !ok {
		return false
	}
	return (t.UserID == "" || t.UserID == err.UserID) &&
		(t.Resource == "" || t.Resource == err.Resource)
}
```

```go
if errors.Is(err, ErrorNotFound{Resource: "/items"}) {
```

## Confusion

The above allows for some rather elegant error handling code except that to a
reader the above code is not particularly clear. This is particularly surprising
given that Go emphasises clarity for the reader, and so much Go code delivers on
that value by being very clear.

### Visual Similarity

It is difficult to distinguish between `errors.Is` and `errors.As` when quickly
scanning code. They only differ by one characters, and so visually look very
similar. 

### Semantic Ambiguity

The function names Is and As are ambiguous.

In natural language when I speak about wanting to know whether an error _is_ an ErrorNotFound, my inclination is to want to write `if errors.Is(err, &ErrorNotFound)`. I don't naturally think about can I get the error _as_ an ErrNotFound.

This is something that becomes learned over time but it doesn't help new readers
of Go code using errors.Is.

### Surprise Functionality

The matching capabilities of Is are very powerful, however it is difficult to
understand what an errors.Is check will do without inspecting the implementation
details of errors. The Is function is intended for both complete matching and
partial matching and the caller cannot choose which takes place. The caller
cannot choose an equals over a partial match or some other logic being executed.
It is the caller who should be in control when deciding if an error is the error
they are looking for.

## Final Thoughts

I think these functions would be clearer for the reader, and safer for the caller, if they had been given different names and the caller could choose between exact matching semantics and partial matching semantics.

The code I write using errors.Is and errors.As would be clearer if:

- `errors.As` was named `errors.AssignsTo`
- `errors.Is` was split into two functions:
  - `errors.Equals` that unwraps and checks for equality.
  - `errors.Match` that unwraps and checks for partial equality.

An implementation for experimentation for what this could look like is at:

[4d63.com/errors](https://4d63.com/errors)
