+++
slug = "google-analyticsjs-outbound-link"
title = "Google analytics.js outbound link tracking"
date = 2013-11-22
disqus_identifier = "vabzuqw"
+++

If you're using Google Analytics on your website, you're tracking all your internal links, but you might not be tracking links to external websites. This can be very helpful in what outgoing links your users are interested in, and especially useful if you're hosting content like file downloads on services like Amazon S3.

You can do this simply with jQuery, by using the code below. Include this in your website's JavaScript and it will automatically catch clicks on any outgoing links. This uses the new analytics.js which is better than the old ga.js. The most important feature possible with using analytics.js is that the script below will wait until the click is registered with Google Analytics before moving on to the next page.

{{< highlight javascript >}}
/* Google - Standard new analytics code. Replace the UA-XXXXXXXX-X and example.com. */
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','http://www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-XXXXXXXX-X', 'example.com');
ga('send', 'pageview');

/* Catch any outbound links, register them with Google Analytics. 
   Outbound links will be displayed in your analytics account as 'out/[outbound url]'.
   Copyright (c) 2013, Leigh McCulloch
   All Rights Reserved
   License: BSD-2-Clause (http://opensource.org/licenses/BSD-2-Clause) */
$(function(){
  $('a:not([href*="' + document.domain + '"])').click(function(event){
    /* get all the info from the link */
    var anchor = $(this);
    var href = anchor.attr('href');
    /* check that the link isn't a relative link */
    var hrefLead = href.charAt(0);
    if (hrefLead != '.' && hrefLead != '#' && hrefLead != '/') {
      /* stop the browser redirecting away, we'll do it manually after the hit is registered with Google */
      event.preventDefault();
      /* strip the protocol, because it's wasted space */
      var hrefNoProtocol = href.replace(/http[s]?:\/\//, '');
      ga('send', 'pageview', {
        /* register the outgoing link as '/out/[outgoing link]' */
        'page': 'out/'+hrefNoProtocol,
        /* only when we've finished registering the link click, send the user to the link they clicked on */
        'hitCallback': function() {
          document.location = href;
        }
      });
    }
  });
});
{{< / highlight >}}

Get the code above, or from my [GitHub Gist](https://gist.github.com/leighmcculloch/7596803).
