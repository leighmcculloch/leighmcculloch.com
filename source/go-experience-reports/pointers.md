# Go Experience Report: Pointers

July 25th, 2017 by [Leigh McCulloch](https://leighmcculloch.com)  

* [Problem summary](#problem-summary)
* [Problem analysis](#problem-analysis)
* [Example: Indicate the lack of value](#example-Indicate-the-lack-of-value)
* [Example: Pass ownership of a value](#example-pass-ownership-of-a-value)
* [Example: A work around to indicate the lack of value](#example-a-work-around-to-indicate-the-lack-of-value)
* [Related Github Issues](#related-github-issues)
* [Experiments](#experiments)

## Problem summary

In Go, pointers get used for two things:

1. Indicate the lack of a value.
2. Pass ownership of a value.

When I make a pointer variable I usually only want to do one of the above. Regardless of my intent, the variable I create carries both intentions in it's declaration. Because the declaration of the variable does not communicate my intent, this is knowledge that the reader must infer from what my application does with the variable and is another piece of information that must live in the readers head rather than in the code. At times this has made it difficult for me to determine what the intent was when I've read others Go code, and it has confused others who have read my code.

In the first two examples a pointer variable/field has been declared with only one of the two intentions, but a reader looking at the code must infer the intention themselves.

## Problem analysis

Pointers are:

* Particularly good at allowing us to transfer ownership of memory, which isn't surprising since other languages with pointers use them for this reason also. But when doing this they trip us up when they lack value.
* Imperfect at communicating the lack of value, since it requires us to transfer ownership of memory.

They are often used to communicate a lack of value in JSON/XML deserialized into structs, but then introduce the additional meaning and burden that these fields also transfer ownership.

I am unable to declare variables/fields that only transfer ownership or only indicate a lack of value, but I frequently declare pointer variables that need only one of these features. Most of the time, the indicate a lack of value is the one where I feel the most pain because inheriting ownership transfer has many more side effects.

## Example: Indicate the lack of value

Package: `github.com/lionelbarrow/braintree-go`

In the `Plan` struct taken from the `braintree` package, the `TrialDuration` field is optional and may be `nil`. If it is `nil` it is indicative that there is no trial duration defined.

However, because `TrialDuration` is a pointer there are several nasty side effects:

* We transfer ownership of the value it pointers to whenever we pass a copy of `Plan` to another function. If either the caller or callee make changes to it the exchange, we run the risk that either party is relying on it staying the same.
* Printing the `Plan` struct outputs the memor address of `TrialDuration` and not the value it points to, significantly hampering debugging and the usefulness of logs in tests.
* Constructing the `Plan` struct is tedious, since constants cannot be assigned to pointer variables directly (`&5` is not valid) and it may not be practical to take the address of the location of the value, requiring the use of intermediary variables.

```go
type Plan struct {
	XMLName               string       `xml:"plan"`
	Id                    string       `xml:"id"`
	...
	TrialDuration         *int         `xml:"trial-duration"`
	TrialDurationUnit     string       `xml:"trial-duration-unit"`
	TrialPeriod           bool         `xml:"trial-period"`
	...
}
```

## Example: Pass ownership of a value

Package: `github.com/lionelbarrow/braintree-go`

In the `executeVersion` function taken from the `braintree` package, the `*Response` return value is declared as a variable because the function wishes to pass ownership of the value held in memory to the caller and avoid the unnecessary memory copy. The intent is that the `*Response` would always point to a value as long as an error had not occurred.

However, because `Response` is returned as a pointer there is one inconvenient side effect:

* We signal to the caller that this value could be `nil` and that may cause the caller to unnecessarily check the value against `nil` and to wonder in what cases could this function not error, but not return a value.

```go
func (g *Braintree) executeVersion(...) (*Response, error) {
	...

	resp, err := httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer func() { _ = resp.Body.Close() }()

	btr := &Response{
		Response: resp,
	}
	err = btr.unpackBody()
	if err != nil {
		return nil, err
	}

	...

	return btr, nil
}
```

## Example: A work around to indicate the lack of value

The null struct has become popular in some places to indicate lack of value by defining an additional type for every type that we need.

The `NullInt64` defined in [database/sql](https://golang.org/pkg/database/sql/#NullInt64) demonstrates we can represent the lack of value (null) by wrapping our value inside another struct with a side-car bool to indicate if there is a value of if it is empty.

However, because `NullInt64` is returned as a pointer there are inconvenient side effects:
* Consumers of any package that provides these values must reason about these structs. While they are simple, they add additional weight to the package, and likely have little to do with the core functionality the package is offering.
* Consumers of one package will need to reconcile null structs in one package with null structs in another. 

```go
type NullInt64 struct {
	Int64 int64
	Valid bool // Valid is true if Int64 is not NULL
}
```

## Related Github Issues

* https://github.com/golang/go/issues/7054
* https://github.com/golang/go/issues/19966
* https://github.com/golang/go/issues/9097


## Experiments

* https://github.com/leighmcculloch/go-optional
