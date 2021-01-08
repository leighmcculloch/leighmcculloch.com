package main

import (
	"fmt"
	"unicode/utf8"
)

func reverse(s string) string {
	l := len(s)
	reversed := make([]byte, l)
	i := 0
	for i < l {
		c, size := utf8.DecodeRuneInString(s[i:])
		i += size
		utf8.EncodeRune(reversed[l-i:], c)
	}
	return string(reversed)
}

func main() {
	fmt.Println(reverse("cafés"))
}
