+++
slug = "go-experience-report-pointers"
title = "Go: Experience Report: Pointers"
date = 2017-07-25
disqus_identifier = "leighmcculloch.com-source/go-experience-reports/pointers.md"
aliases = [
  "/go-experience-reports/pointers.html",
]
+++

* [Problem summary](#problem-summary)
* [Problem analysis](#problem-analysis)
* [Example: Indicate a lack of value](#example-Indicate-a-lack-of-value)
* [Example: Pass ownership of a value](#example-pass-ownership-of-a-value)
* [Example: A work around for lack of value](#example-a-work-around-for-lack-of-value)
* [Related Github Issues](#related-github-issues)
* [Experiments](#experiments)

## Problem summary

In Go, pointers get used for two things:

1. Indicate the lack of a value.
2. Pass ownership of a value.

When I make a pointer variable I often only want to do one of the above. Regardless of my intent, the variable I create carries both intentions in its declaration. Because the declaration of the variable does not communicate my intent, this is knowledge that the reader must infer from what my application does with the variable and is another piece of information that must live in the readers head rather than in the code. At best it lives in the comments. This has made it difficult for me to determine what the intent was when I’ve read others Go code, and it has confused others who have read my code.

## Problem analysis

Pointers are:

- Particularly good at allowing us to transfer ownership of memory, which isn’t surprising since other languages with pointers use them for this reason also. But when doing this they trip us up when they lack value.

- Imperfect at communicating the lack of value, since it requires us to transfer ownership of memory when it may be more appropriate to copy.

They are often used to communicate a lack of value in JSON/XML deserialized into structs, but then introduce the additional meaning and burden that these fields also transfer ownership.

It is not possible to variables/fields that only transfer ownership or only indicate a lack of value, but I frequently declare pointer variables that need only one of these features. Most of the time, to indicate a lack of value is the one where I feel the most pain because inheriting ownership transfer has many several side effects.

## Example: Indicate a lack of value

Package: `github.com/lionelbarrow/braintree-go`

{{< highlight go >}}
type Plan struct {
	XMLName               string       `xml:"plan"`
	ID                    string       `xml:"id"`
	//...
	TrialDuration         *int         `xml:"trial-duration"`
	//...
}
{{< / highlight >}}

In the `Plan` struct taken from the `braintree` package, the `TrialDuration` field is optional and may be `nil`. If it is `nil` it is indicative that there is no trial duration defined.

However, because `TrialDuration` is a pointer there are several nasty side effects:

- We transfer ownership of the value it points to whenever we pass a copy of `Plan` to another function. If either the caller or callee make changes to it the exchange, we run the risk that either party is relying on it staying the same.

- Printing the `Plan` struct outputs the memory address of `TrialDuration` and not the value it points to, significantly hampering debugging and the usefulness of logs in tests.
{{< highlight go >}}
func main() {
	trialDuration := 5
	p := &Plan{
		ID: "plan1",
		TrialDuration: &trialDuration,
	}
	fmt.Printf("%+v", p)
	// Output: &{XMLName: ID:plan1 TrialDuration:0x10414020}
}
{{< / highlight >}}

- Constructing the `Plan` struct is tedious, since constants cannot be assigned to pointer variables directly (`&5` is not valid) and it may not be practical to take the address of the location of the value, requiring the use of intermediary variables.
{{< highlight go >}}
func main() {
	trialDuration := 5
	p := Plan{
		TrialDuration: &trialDuration,
	}
	//...
}
{{< / highlight >}}

## Example: Pass ownership of a value

Package: `github.com/lionelbarrow/braintree-go`

{{< highlight go >}}
func NewWithHttpClient(env Environment, merchantId, publicKey, privateKey string, client *http.Client) *Braintree {
	return &Braintree{credentials: newAPIKey(env, merchantId, publicKey, privateKey), HttpClient: client}
}
{{< / highlight >}}

In the `NewWithHttpClient` function taken from the `braintree` package, the `*Braintree` return value is declared as a pointer because the function wishes to pass ownership of the value held in memory to the caller and not copy the value pointed at. The intent is that the `*Braintree` would always point to a value.

However, because `Braintree` is returned as a pointer there is one inconvenient side effect:

- We signal to the caller that this value could be `nil` and that may cause the caller to unnecessarily check the value against `nil` and to wonder in what cases could this function not error, but not return a value.

- We set precedence for users to assume that other pointers will not be `nil`. There are return values in the `braintree` package that are pointers and may be `nil` and there is nothing in the syntax to tell the reader which values may be `nil`.

## Example: A work around for lack of value

Package: `database/sql`

{{< highlight go >}}
type NullInt64 struct {
	Int64 int64
	Valid bool // Valid is true if Int64 is not NULL
}
{{< / highlight >}}

The null struct is used in some packages to indicate a lack of value by defining an additional type for every type that may lack value.

The `NullInt64` defined in [database/sql](https://golang.org/pkg/database/sql/#NullInt64) demonstrates we can represent the lack of value (null) by wrapping our value inside another struct with a side-car bool to indicate if there is a value or if it is empty.

Because `NullInt64` is returned as a pointer there are inconvenient side effects:

- Consumers of any package that provide these values must reason about these structs. While they are simple, they add additional weight to the package, and likely have little to do with the core functionality the package is offering.

- Consumers of one package will need to reconcile null structs in one package with null structs in another.

## Closing remarks

Software engineers use pointers in Go to indicate the lack of value or pass ownership, but the intent of which is lost, and the side-effects of both must be adopted, because a single mechnism is used for both.

## Related Github Issues

- https://github.com/golang/go/issues/7054
- https://github.com/golang/go/issues/19966
- https://github.com/golang/go/issues/9097
- https://github.com/golang/go/issues/36884
- https://github.com/golang/go/issues/30177
- https://github.com/golang/go/issues/22729
- https://github.com/golang/go/issues/28133

## Experiments

- https://github.com/leighmcculloch/go-optional





