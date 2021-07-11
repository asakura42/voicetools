package main

import (
	"fmt"
	"os"
	"time"

	"github.com/olebedev/when"
	"github.com/olebedev/when/rules/common"
	"github.com/olebedev/when/rules/en"
	"github.com/olebedev/when/rules/ru"
)

func main() {

	w := when.New(nil)
	w.Add(en.All...)
	w.Add(ru.All...)
	w.Add(common.All...)

	text := os.Args[1]

	fmt.Scanln(text)

	r, err := w.Parse(text, time.Now())
	if err != nil {
		// an error has occurred
	}
	if r == nil {
		// no matches found
	}

	fmt.Println(
		r.Time.String(),
		"\n",
		text[r.Index:r.Index+len(r.Text)],
	)

}

