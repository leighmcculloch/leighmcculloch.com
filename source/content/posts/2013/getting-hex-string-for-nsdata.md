+++
slug = "getting-hex-string-for-nsdata"
title = "Obj-C: Getting a Hex String for an NSData"
date = 2013-11-30
disqus_identifier = "ofvtepu"
+++

Even simple tasks programmers shouldn't need to do manually, and this is one of them. Generating a hex string from an NSData is really useful when debugging and sometimes in applications in general. This category exposes a method that when called will return the hex string for the data within the NSData object.

Data is returned in the format of two characters per octet with no delimiters. E.g. af459a2f

{{< highlight objective-c >}}
//
//  NSData+HexString.h
//
//  Copyright (c) 2013, Leigh McCulloch. All rights reserved.
//  BSD-2-Clause License: http://opensource.org/licenses/BSD-2-Clause
//

#import <Foundation/Foundation.h>

@interface NSData (HexString)

- (NSString *)hexString;

@end
{{< / highlight >}}

{{< highlight objective-c >}}
//
//  NSData+HexString.m
//
//  Copyright (c) 2013, Leigh McCulloch. All rights reserved.
//  BSD-2-Clause License: http://opensource.org/licenses/BSD-2-Clause
//

#import "NSData+HexString.h"

@implementation NSData (HexString)

- (NSString *)hexString {
	NSMutableString *hex = [NSMutableString stringWithCapacity:[self length]*2];
	[self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
		const unsigned char *dataBytes = (const unsigned char *)bytes;
		for (NSUInteger i = byteRange.location; i < byteRange.length; ++i) {
			[hex appendFormat:@"%02x", dataBytes[i]];
		}
	}];
	return hex;
}

@end
{{< / highlight >}}

Get the code above, or from my [GitHub Gist](https://gist.github.com/leighmcculloch/7623204).
