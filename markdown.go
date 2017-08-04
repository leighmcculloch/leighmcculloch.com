package main

import (
	"bytes"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"text/template"

	"github.com/russross/blackfriday"
)

var html = `<!DOCTYPE html>
<html>
<head>
<style>
body {
  background: white;
  color: rgba(0,0,0,0.8);
  font-family: -apple-system, BlinkMacSystemFont, sans-serif;
  font-weight: 300;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
  margin: 1em;
}
code {
  display: inline-block;
  font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace;
  padding: 0;
  padding-top: 0.2em;
  padding-bottom: 0.2em;
  margin: 0;
  font-size: 0.85em;
  background-color: #f7f7f7;
  border-radius: 3px;
}
code:before, code:after {
  letter-spacing: -0.2em;
  content: "\00a0";
}
pre code {
  display: block;
  padding: 0.5em;
  overflow: auto;
  font-size: 0.85em;
  line-height: 1.45;
}
</style>
</head>
<body>
{{.Body}}
<div id="disqus_thread"></div>
<script>
var disqus_config = function () {
	this.page.identifier = 'leighmcculloch.com-{{.DisqusID}}';
};
(function() {
	var d = document, s = d.createElement('script');
	s.src = 'https://leighmcculloch.disqus.com/embed.js';
	s.setAttribute('data-timestamp', +new Date());
	(d.head || d.body).appendChild(s);
})();
</script>

</body>
</html>`

var tmpl = func() *template.Template {
	t, err := template.New("").Parse(html)
	if err != nil {
		log.Fatalf("error loading template: %v", err)
	}
	return t
}()

func main() {
	fileIn := os.Args[1]
	fileOut := os.Args[2]
	dirOut := filepath.Dir(fileOut)

	log.Printf("Markdown %s => HTML %s", fileIn, fileOut)

	md, err := ioutil.ReadFile(fileIn)
	if err != nil {
		log.Fatalf("reading file %s: %v", fileIn, err)
	}

	html := blackfriday.MarkdownCommon(md)

	err = os.MkdirAll(dirOut, os.ModePerm)
	if err != nil {
		log.Fatalf("making dir path %s: %v", dirOut, err)
	}

	data := struct {
		Body     string
		DisqusID string
	}{
		Body:     string(html),
		DisqusID: fileIn,
	}

	out := bytes.Buffer{}
	err = tmpl.ExecuteTemplate(&out, "", data)
	if err != nil {
		log.Fatalf("generating template: %v", err)
	}

	err = ioutil.WriteFile(fileOut, []byte(out.Bytes()), 0644)
	if err != nil {
		log.Fatalf("writing file %s: %v", fileOut, err)
	}
}
