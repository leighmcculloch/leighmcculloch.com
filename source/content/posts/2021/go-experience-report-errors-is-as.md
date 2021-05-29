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
	return _, ErrorNotFound{UserID: "1", Resource: "/items"}
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
scanning code. They differ by one character, and visually look very similar. 

### Semantic Ambiguity

The function names Is and As are ambiguous.

In natural language when I speak about wanting to know whether an error _is_ an
ErrorNotFound, my inclination is to want to write:

```go
if errors.Is(err, &ErrorNotFound{}) {
```

However, I need to write:
```go
if errors.As(err, &ErrorNotFound{}) {
```

I don't naturally speak about wanting to get the error _as_ an ErrNotFound.

This is something that becomes learned over time but it doesn't help new readers
of Go code using errors.Is.

### Surprise Functionality

The matching capabilities of Is are very powerful, however it is difficult to
understand what an errors.Is check will do without inspecting the implementation
details of an error.

The Is function is intended for both complete equality checks and partial
matching and the caller has no control over which takes place.

The caller may not be in control of when two errors are considered equal, but
the caller should be in control over when two errors are considered a match but
not equal.

## Final Thoughts

I think these functions would be clearer for the reader, and safer for the caller, if they had been given different names and the caller could choose between equality semantics and partial matching semantics.

The code I write using errors.Is and errors.As might be clearer if:

- `errors.As` was named `errors.Is`
- `errors.Is` was split into two functions:
  - `errors.Equals` that unwraps and checks for equality.
  - `errors.Match` that unwraps and checks for partial equality.

An implementation for experimentation for what this could look like is at:

[4d63.com/errors](https://4d63.com/errors)
