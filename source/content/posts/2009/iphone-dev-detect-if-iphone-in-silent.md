+++
slug = "iphone-dev-detect-if-iphone-in-silent"
title = "iOS Dev: Detect if the iPhone's in silent mode"
date = 2009-07-20
disqus_identifier = "qpwxrcf"
+++

I have been writing an application that delivers audio to the user using the AVAudioPlayer, apart of the AVFoundation. If the iPhone is in Silent mode, then the audio isn't heard, however from the applications point of view the audio has been played. If the iPhone is in Silent mode, I want to warn the user so they know that when they press the button that plays sound, they're not going to hear any.

The following function is based on some info I found scattered around on forums, as well as some of my own tinkering to actually get it to work. It will return a boolean indicating if you will be able to play audio using the AVAudioPlayer.

{{< highlight objective-c >}}
- (bool)isAudioEnabled {
    UInt32 cfRouteSize = sizeof (CFStringRef);
    CFStringRef cfRoute;
    NSString* nsRoute;

    AudioSessionGetProperty(
        kAudioSessionProperty_AudioRoute,
        &cfRouteSize,
        &cfRoute);

    nsRoute = (NSString*)cfRoute;

    return ([nsRoute length] == 0);
}
{{< / highlight >}}

Note: If the iPhone is in Silent mode with headphones attached, this function will return true, and the AVAudioPlayer should still be able to play audio.
