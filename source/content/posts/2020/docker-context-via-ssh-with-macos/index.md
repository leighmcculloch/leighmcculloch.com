+++
slug = "docker-context-via-ssh-with-macos"
title = "Docker Context via SSH with macOS"
date = 2020-11-28
+++

Docker 1.19.x came with Contexts. Contexts are useful if you want the local Docker CLI to connect to a Docker daemon running elsewhere, like another computer or somewhere in the cloud.

It's really easy to get setup. You use the following command to create a context on the client machine:
```
docker context create <context-name> ssh://<username>@<host>
```

Then select that context with:
```
docker context use <context-name>
```

If you're like me and you want to run a container on a macOS system on a local network and want to connect to it, this won't work out of the box. This is because `sshd` macOS systems by default do not include the `/usr/local/bin` location in the system `PATH` and so when the docker CLI ssh's into the mac system it won't be able to find `docker`.

If you experience that problem it can be fixed reasonably easy by changing two things on the macOS system that is hosting the container:

First we set the PATH for sshd for the user to include `/usr/local/bin`:
```
echo 'PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin' >> ~/.ssh/environment
```

Second we allow the user to set a `PATH` for new ssh sessions to that user:
```
sudo sh -c 'echo "PermitUserEnvironment PATH" >> /private/etc/ssh/sshd_config'
```

Once those changes have been made you should be able to run the `docker context use` command above, and then `docker ps` and you should see a list of containers running on the other system.