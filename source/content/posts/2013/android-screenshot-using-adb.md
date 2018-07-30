+++
slug = "android-screenshot-using-adb"
title = "Android: Screenshot using ADB"
date = 2013-12-05
disqus_identifier = "pmgfrdf"
+++

Need a quick script for taking screenshots of an Android device that's connected via ADB, and your running on Windows?

This batch script will do just that, and download the screenshot to the directory this script to the current directory. Screenshots are saved with filename: `screenshot-YYYYMMDD-HHMMSS.png`. ADB must be connected to a device already.

{{< highlight batch >}}
@echo off

rem File: Android Screenshot.bat

rem configurable parameters
set SCREENCAP_FILE_PREFIX=screenshot

rem the dir on the device where the screenshot will be stored temporarily
set SCREENCAP_WORKING_DIR=/sdcard/

rem adb path, leave blank if adb is already on the user or system path
set SCREENCAP_ADB_PATH=

rem get date and time
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set SCREENCAP_DATE=%%c%%a%%b)
For /f "tokens=1-4 delims=/:." %%a in ("%TIME%") do (set SCREENCAP_TIME=%%a%%b%%c%%d)

rem create output file from parameters and date and time
set SCREENCAP_FILE_NAME=%SCREENCAP_FILE_PREFIX%-%SCREENCAP_DATE%-%SCREENCAP_TIME%.png
set SCREENCAP_FILE_PATH=%SCREENCAP_WORKING_DIR%%SCREENCAP_FILE_NAME%

rem do it!
echo Taking Screenshot at %SCREENCAP_DATE%-%SCREENCAP_TIME%
echo Output File: %SCREENCAP_FILE_NAME%
echo.
%SCREENCAP_ADB_PATH%adb shell screencap -p %SCREENCAP_FILE_PATH%
%SCREENCAP_ADB_PATH%adb pull %SCREENCAP_FILE_PATH%
%SCREENCAP_ADB_PATH%adb shell rm %SCREENCAP_FILE_PATH%
echo.
pause
{{< / highlight >}}

Get the code above, or from my [GitHub Gist](https://gist.github.com/leighmcculloch/7803130).
