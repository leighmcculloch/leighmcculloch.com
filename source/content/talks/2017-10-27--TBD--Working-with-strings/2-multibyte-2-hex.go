package main

import (
	"fmt"
)

func reverse(s string) string {
	l := len(s)
	reversed := make([]byte, l)
	for i := 0; i < l; i++ {
		reversed[l-1-i] = s[i]
	}
	return string(reversed)
}

func main() {
	fmt.Printf("Input:  %v\n", []byte("cafés"))
	fmt.Printf("Output: %v\n", []byte(reverse("cafés")))
	fmt.Printf("Want:   %v\n", []byte("séfac"))
	fmt.Printf("é:      %v\n", []byte("é"))
}
