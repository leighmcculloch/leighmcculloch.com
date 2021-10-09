+++
slug = "ffmpeg-reducing-size-of-videos"
title = "FFmpeg: Reducing the size of videos"
date = 2021-10-09
+++

I've started taking more videos in the last few years and while disk space is
cheaper now than it used to be it always seems like I'm screaming towards the
limits of what I have. So much of my disk space is consumed with family photos
and videos, and so size matters, bigger isn't better, or rather, bigger creates
one more problem I have to solve. For the most part I avoid shooting in quality
I don't need and that keeps file size down.

FFmpeg to the rescue. FFmpeg reencodes video and we can use it to drop the file
size on videos without sacrificing meaningful quality. If you're on Mac FFmpeg can be installed via brew.
```
brew install ffmpeg
```

The following command reencodes video using the H.265/MPEG-H AVC codec. It'll
work on new Mac's and Apple devices, and maybe other devices. I prefer this
codec for home videos because the file sizes are smaller.
```
ffmpeg -i $in -c:v libx265 -crf 28 -tag:v hvc1 -c:a aac -b:a 128k $out
```

The following command reencodes video to H.265/MPEG-4 AVC. It'll work on a wider
range of devices and offers better compatibility if you're sharing on the web.
```
ffmpeg -i $in -c:v libx264 -crf 20 -c:a aac -b:a 128k $out
```

In both commands replace `$in` with the input file, and `$out` with where you
want the output file to be written.
