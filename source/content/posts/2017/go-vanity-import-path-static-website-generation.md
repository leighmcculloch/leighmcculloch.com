+++
slug = "go-vanity-import-path-static-website-generation"
title = "Go: Vanity import path static website generation"
date = 2017-09-10
disqus_identifier = "edwuljg"
+++

I recently created `vangen`, a static website builder for Go vanity import paths. 

I use vanity import paths for all of my Go packages so that I can move the source repository if I need to. My Go packages are not big time projects, but I like that I can defer the decision on where my source code must live and that I get to use short import paths for my own packages.

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Non vanity import paths are considered harmful. If you are a serious project, enforce a vanity import path. <a href="https://twitter.com/hashtag/golang?src=hash&amp;ref_src=twsrc%5Etfw">#golang</a></p>&mdash; JBD (@rakyll) <a href="https://twitter.com/rakyll/status/892805962867683328?ref_src=twsrc%5Etfw">August 2, 2017</a></blockquote>

I considered using [github.com/GoogleCloudPlatform/govanityurls](https://github.com/GoogleCloudPlatform/govanityurls) which is a small server designed for running on Google App Engine, but this seemed overkill given vanity import paths are just HTML meta tags.

Given that vanity import paths are just HTML meta tags that redirect the `go get` command and godoc.org to the source code, there's little need for a server or logic to run on every request, and no need for any complex or substantial infrastructure. `vangen` generates static HTML files that can be hosted on any web host. e.g. AWS S3, Google Cloud Storage, GitHub Pages, etc.

Install:
{{< highlight shell >}}
go get 4d63.com/vangen
{{< / highlight >}}

Usage: Define a `vangen.json` file with a domain and a list of repositories.
{{< highlight json >}}
{
  "domain": "4d63.com",
  "repositories": [
    {
      "prefix": "optional",
      "subs": [
        "template"
      ],
      "url": "https://github.com/leighmcculloch/go-optional"
    }
  ]
}
{{< / highlight >}}

Run `vangen` in the same directory as the file and it will create the static files in a `vangen/` directory. The HTML generated will be:
{{< highlight html >}}
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="go-import" content="4d63.com/optional git https://github.com/leighmcculloch/go-optional">
<meta name="go-source" content="4d63.com/optional https://github.com/leighmcculloch/go-optional https://github.com/leighmcculloch/go-optional/tree/master{/dir} https://github.com/leighmcculloch/go-optional/blob/master{/dir}/{file}#L{line}">
...
{{< / highlight >}}

Because of how simple it is to define Go vanity import paths there's a variety of ways you can do it. You don't need to use this generator.
