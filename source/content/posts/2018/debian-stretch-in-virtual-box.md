+++
slug = "debian-stretch-in-virtualbox"
title = "Debian Stretch in VirtualBox"
date = 2018-08-08
disqus_identifier = "rtqwndu"
+++

Installing Debian Stretch in a VirtualBox VM is pretty straight forward, but there are a few things to do to get the basic comforts of home.

1. Download a [Debian image](https://www.debian.org/distrib/netinst).

1. Use VirtualBox to create a new VM, and mount the Debian image as a CD.

1. Follow the GUI and install.

1. Start the VM, the rest of the commands are setting up the OS with what's needed.

1. Install and setup sudo.
   ```
   su -
   apt-get install -y sudo
   usermod -aG sudo <your-username>
   ```

1. Restart the VM.

1. Prepare for installing VirtualBox Guest Additions.
   ```
   sudo apt-get update
   sudo apt-get upgrade
   sudo apt-get install build-essential module-assistant
   sudo m-a prepare
   ```

1. In VirtualBox select `Devices` > `Insert Guest Additions CD image...`.

1. Install VirtualBox Guest Additions.
   ```
   sudo sh /media/cdrom/VBoxLinuxAdditions.run
   ```

1. Restart the VM.

You'll now have a VM running Debian Stretch, with some of the basics setup.
