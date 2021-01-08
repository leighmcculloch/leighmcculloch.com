package main

import (
	"fmt"
	"unicode"
	"unicode/utf8"
)

func reverse(s string) string {
	reversed := make([]byte, len(s))
	marks := make([]rune, 0)
	i := 0

	for len(s) > 0 {
		r, size := utf8.DecodeLastRuneInString(s)
		s = s[:len(s)-size]
		if unicode.IsMark(r) {
			marks = append(marks, r)
		} else {
			i += utf8.EncodeRune(reversed[i:], r)
			for m := len(marks) - 1; m >= 0; m-- {
				mark := marks[m]
				i += utf8.EncodeRune(reversed[i:], mark)
			}
			marks = marks[:0]
		}
	}
	return string(reversed)
}

func main() {
	fmt.Println(reverse("cafés 👍🏽"))
}
