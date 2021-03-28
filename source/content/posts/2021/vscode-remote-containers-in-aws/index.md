+++
slug = "vscode-remote-containers-in-aws"
title = "VSCode: Remote Containers in AWS"
date = 2021-03-26
+++

I recently started using VSCode. I'm maybe late to this party but I was stuck
in the world of VIM. My VIM setup was more than just a vimrc, but a
Ubuntu development environment sitting inside Docker where I could spin up
multiple reproducible environments.

VSCode's [Remote Container] support is game changing. It provides
reproducible development environments with a UI that runs smoothly on my Mac
while I develop in Ubuntu.

The good news is that once setup with Remote Containers we aren't limited to
running Docker containers on our local system.

If you start VSCode at the commandline with the `DOCKER_HOST` environment
variable set to a remote instance that has Docker installed, VSCode will run
the containers there. This opens up the possibility of using large instances,
such as AWS's `m5zn` instance types that have up to 48x 4.5GHz vCPUs. I've
found this can rapidly speed up compiling of large applications, such as
[stellar-core].

```
DOCKER_HOST=ssh://ubuntu@<hostname-or-ip> code
```

Large instances like the `m5zn.12xlarge` can be expensive though, so I use an
AWS EC2 Launch Template with the following User Data to quickly bring up an
instance ready to go for Remote Containers. Since it is fast to bring up a
new instance, I can stop or terminate an instance the moment I'm not using
it.

I connect to the instance via [Tailscale] so I don't have to deal with
changing public IPs, but you could just assign a public IP to the instance
and connect via it instead.

User Data:
```
#!/bin/bash

hostnamectl set-hostname awsdevenv

snap install docker
groupadd docker
usermod -a -G docker ubuntu

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list
apt-get update
apt-get install tailscale

tailscale up -authkey <tskey>

reboot
```

Finally I use the dotfiles feature of VSCode Remote Containers to setup any
container I run. You can checkout [my dotfiles] for an example of how I
Configured my shell. Dotfiles are configured in VSCode Settings as so.

```
"dotfiles.repository": "leighmcculloch/dotfiles",
"dotfiles.targetPath": "~/dotfiles",
"dotfiles.installCommand": "~/dotfiles/install-remote.sh",
```

It's also possible to use Docker [Contexts] instead of setting the
`DOCKER_HOST` environment variable, but it's a little buggy inside of VSCode
Remote Containers. If you'd give it a try checkout my last post, [Docker:
Context via SSH with macOS].

[Docker: Context via SSH with macOS]: https://leighmcculloch.com/posts/docker-context-via-ssh-with-macos/
[Remote Container]: https://code.visualstudio.com/docs/remote/containers
[Contexts]: https://docs.docker.com/engine/context/working-with-contexts/
[Tailscale]: https://tailscale.com
[stellar-core]: https://github.com/stellar/stellar-core
[my dotfiles]: https://github.com/leighmcculloch/dotfiles
