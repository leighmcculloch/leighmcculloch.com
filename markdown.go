package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	"github.com/shurcooL/github_flavored_markdown"
	"github.com/shurcooL/github_flavored_markdown/gfmstyle"
)

var template = `<!DOCTYPE html>
<html>
<head>
<style>%s</style>
</head>
<body class="markdown-body" style="overflow:auto">%s

<div id="disqus_thread"></div>
<script>
var disqus_config = function () {
	this.page.identifier = 'leighmcculloch.com-%s';
};
(function() { // DON'T EDIT BELOW THIS LINE
var d = document, s = d.createElement('script');
s.src = 'https://leighmcculloch.disqus.com/embed.js';
s.setAttribute('data-timestamp', +new Date());
(d.head || d.body).appendChild(s);
})();
</script>

</body>
</html>`

func main() {
	fileIn := os.Args[1]
	fileOut := os.Args[2]
	dirOut := filepath.Dir(fileOut)

	log.Printf("Markdown %s => HTML %s", fileIn, fileOut)

	md, err := ioutil.ReadFile(fileIn)
	if err != nil {
		log.Fatalf("reading file %s: %v", fileIn, err)
	}

	html := github_flavored_markdown.Markdown(md)

	err = os.MkdirAll(dirOut, os.ModePerm)
	if err != nil {
		log.Fatalf("making dir path %s: %v", dirOut, err)
	}

	cssFile, err := gfmstyle.Assets.Open("/gfm.css")
	if err != nil {
		log.Fatalf("getting gfmstyle css: %v", err)
	}
	css, err := ioutil.ReadAll(cssFile)
	if err != nil {
		log.Fatalf("reading gfmstyle css: %v", err)
	}

	fullHtml := fmt.Sprintf(template, css, html, fileIn)

	err = ioutil.WriteFile(fileOut, []byte(fullHtml), 0644)
	if err != nil {
		log.Fatalf("writing file %s: %v", fileOut, err)
	}
}
