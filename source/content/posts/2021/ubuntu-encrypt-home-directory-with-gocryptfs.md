+++
slug = "ubuntu-encrypt-home-directory-with-gocryptfs"
title = "Linux: Encrypt home directory with gocryptfs"
date = 2021-07-11
+++

I recently installed Ubuntu 21.04 on a Raspberry Pi 4. Getting my user data or
full disk encryption was top of my list of things to setup. After a bit of
reading I decided to go with encrypting just my home directory since my disk is
an SD card and the device is lower powered I decided to avoid the overhead of
encrypting the entire disk.

These were the steps I took, which were cobbled together from instructions in a
few places.


1. Install `libpam-mount` and `gocryptfs`.

   ```
   sudo apt install libpam-mount gocryptfs
   ```

2. Edit the fuse config to allow other users access to mounts. Open
`/etc/fuse.conf` and uncommon the line with `user_allow_other`.

3. Edit the libpam-mount config, instructing it to mount the encrypted home
directory at login. Add the following tag before the last xml tag of
`/etc/security/pam_mount.conf.xml`. Replace `yourusername` with your username on
the computer.

   ```xml
   <volume
     user="yourusername"
     fstype="fuse"
     options="nodev,nosuid,quiet,nonempty,allow_other"
     path="/usr/local/bin/gocryptfs#/home/%(USER).cipher"
     mountpoint="/home/%(USER)"
   />
   ```

4. Backup your current home directory contents.

   ```
   cd /home
   sudo tar cvf $USER.tar $USER
   ```

5. Create a directory to hold the encrypted files.

   ```
   sudo mkdir $USER.cipher
   sudo chown $USER:$USER $USER.cipher
   ```

6. Initialize the enrypted files.

   ```
   gocryptfs -init $USER.cipher
   ```

7. Clear the home directory.

   ```
   rm -fr /home/$USER/* /home/$USER/.*
   ```

8. Add a file that will indicate if the encrypted file system isn't mounted.

   ```
   touch /home/$USER/GOCRYPTFS_NOT_MOUNTED
   ```

9. Mount the encrypted home directory.

   ```
   gocryptfs $USER.cipher $USER
   ```

10. Copy the home directory into the mounted encrypted home directory.

   ```
   tar xvf $USER.tar --strip-components=1 -C $USER
   ```

11. Add a file that will indicate if the encrypted file system is mounted.

   ```
   touch /home/$USER/GOCRYPTFS_MOUNTED
   ```

12. Reboot the system, check that after login the GOCRYPTFS_MOUNTED file is in the home directory.

13. Delete the backup.

   ```
   rm /home/$USER.tar
   ```

Note: This flow will also work on Raspbian OS, however you'll need to disable
autologin because gocryptfs will only be triggered to mount the encrypted home
directory if the user performs the login.
