+++
slug = "safari-picture-in-picture for any video"
title = "Safari picture-in-picture for any video"
date = 2018-11-07
disqus_identifier = "psfvjyn"
+++

Safar’s [picture-in-picture](https://support.apple.com/en-us/HT206997) feature is one of the best features of Safari, but most websites (e.g. Netflix, CBS, etc) disable the native video controls and do not provide a mechanism to trigger picture-in-picture.

Good news! You can create a bookmark to run a small amount of JavaScript to trigger picture-in-picture on any website. Create a bookmark with the following address then when you’re on the page with the video click the bookmark.

{{< highlight javascript >}}
javascript:document.getElementsByTagName("video")[0].webkitSetPresentationMode("picture-in-picture");
{{</ highlight >}}
