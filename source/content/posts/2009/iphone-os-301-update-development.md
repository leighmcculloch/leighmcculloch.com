+++
slug = "iphone-os-301-update-development"
title = "iOS Dev: iOS 3.0.1 update development"
date = 2009-08-03
disqus_identifier = "vxkjqme"
+++

If you've just updated with the iPhone OS 3.0.1 Update and do development on the iPhone, you'll soon discover you won't be able to load up your apps onto your iPhone anymore. But there's an easy solution, as detailed in [Apple's iPhone OS 3.0.1 Advisory](https://developer.apple.com/iphone/download.action?path=/iphone/iphone_sdk_3.0__final/iphone_os_3.0.1_advisory.pdf), you just need to execute the following command in your Terminal to be back up and running.

{{< highlight shell >}}
ln -s /Developer/Platforms/iPhoneOS.platform/DeviceSupport/3.0\ \(7A341\) /Developer/Platforms/iPhoneOS.platform/DeviceSupport/3.0.1
{{< / highlight >}}

It will create a symbolic link "3.0.1" pointing to the existing "3.0 (7A341)" directory. To XCode it will appear like you have a 3.0.1 SDK and a 3.0 SDK installed, even though the 3.0.1 directory just points to the contents of the 3.0 directory. Since 3.0.1 is exactly the same as 3.0 in terms of the SDK, that's exactly what we want.

