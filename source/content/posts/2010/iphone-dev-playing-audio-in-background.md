+++
slug = "iphone-dev-playing-audio-in-background"
title = "iOS Dev: Playing audio in the background"
date = 2010-08-21
disqus_identifier = "pktykrx"
+++

I recently released a new version of the Hope Media application that brought a lot of new challenges to it's development. Apple released iOS4 that supported background applications and I set out to make my application continue to play radio after the application was minimized.

It was actually extremely easy. At the most basic level all I needed to do was add the UIBackgroundModes field to the Info.plist file for the application. I soon discovered though, that even though this part was easy, the rest would not be so easy.

My problems hit when handling interruptions. If I received an audio interruption from the OS, I would stop playing the music as I should. When the interruption ceased I received the "end interruption" indicator from the OS, and was even informed by the OS that I could resume playing. But alas, I could not resume. This is a bug in iOS4 it turns out. The OS is telling the application to resume, when the application is actually not allowed to resume as my application is not the "now playing" application. To become the "now playing" application I have to register for remote audio events.

That. Simple.

For more info on implementing/handling remote audio events in your application (which makes you the now playing application) see the [Apple Developer docs](https://developer.apple.com/iphone/library/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/RemoteControl/RemoteControl.html).
