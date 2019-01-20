+++
slug = "hashing-algorithms-sha256-etc-in-obj-c"
title = "Obj-C: Hashing algorithms (SHA256, etc)"
date = 2013-12-01
disqus_identifier = "mhactvd"
+++

Having spent a lot of time programming in C#, where the .NET Framework can really spoil a developer, I was shocked to find no pretty interface in Apple's Cocoa frameworks for hashing NSStrings and NSData. Quite literally developers need to use the CommonCrypto functions themselves.

While it's only a few lines of code using CommonCrypto, I'm a big fan of once and once-only and it really should be a single line of code and no more, so I put together categories for NSData and NSString that reduce all of CommonCryptos hashing algorithms (MD2, MD4, MD5, SHA1, SHA224, SHA256, SHA384, SHA512) to simple one-line method calls.

Import the header:
{{< highlight objective-c >}}
#import "NSString+Hash.h"
{{< / highlight >}}

And then call the hashing methods:
{{< highlight objective-c >}}
NSString *filePath = @"/Users/Wookie/myfile.txt";
NSString *filePathHashStr = [filePath stringByHashingWithSHA256UsingEncoding:NSUTF8StringEncoding];
NSData *filePathHash = [filePath dataByHashingWithSHA256UsingEncoding:NSUTF8StringEncoding];
{{< / highlight >}}

Get [CocoaHash on Github](https://github.com/leighmcculloch/CocoaHash).

