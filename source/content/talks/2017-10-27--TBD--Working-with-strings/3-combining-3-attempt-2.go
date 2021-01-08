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
		// START OMIT
		r, size := utf8.DecodeLastRuneInString(s)
		s = s[:len(s)-size]
		if unicode.IsMark(r) { // HL
			marks = append(marks, r) // HL
		} else {
			i += utf8.EncodeRune(reversed[i:], r)
			for m := len(marks) - 1; m >= 0; m-- { // HL
				mark := marks[m]                         // HL
				i += utf8.EncodeRune(reversed[i:], mark) // HL
			} // HL
			marks = marks[:0] // HL
		}
	}
	return string(reversed)
}

func main() {
	fmt.Println(reverse("cafés"))
	fmt.Printf("%v\n", []byte(reverse("cafés")))
}
