+++
slug = "vscode-remote-containers-in-aws"
title = "VSCode: Remote Containers in AWS"
date = 2021-03-26
+++

VSCode's [Remote Container] support is game changing. It provides
reproducible development environments with a UI that runs smoothly on my Mac
while I develop in Ubuntu.

I recently started using VSCode. I'm maybe late to this party but I was stuck
in the world of VIM. My VIM setup was more than just a vimrc, but a
Ubuntu development environment sitting inside Docker where I could spin up
multiple reproducible environments.

The big win I find using Docker for virtual development environments is that
once setup with Remote Containers I'm not limited to running Docker
containers on my local system.

If you start VSCode at the commandline with the `DOCKER_HOST` environment
variable set to a remote instance that has Docker installed, VSCode will run
the containers there.

```
DOCKER_HOST=ssh://ubuntu@<hostname-or-ip> code
```

This opens up the possibility of using large instances, such as AWS's `m5zn`
instance types that have up to 48x 4.5GHz vCPUs. I've found this rapidly
speeds up compiling large applications, such as [stellar-core].

Large instances like the `m5zn.12xlarge` can be expensive though, so I use an
AWS EC2 Launch Template with the following User Data to quickly bring up an
instance ready to go for Remote Containers. Since it is fast to bring up a
new instance, I can stop or terminate an instance the moment I'm not using
it.

I have a selection of [favorite instance types] that are focused on high-CPU
speeds.

I connect to the instance via [Tailscale] so I don't have to deal with
changing public IPs, but you could just assign a public IP to the instance
and connect via it instead.

User Data:
```
#!/bin/bash

hostnamectl set-hostname awsdevenv

addgroup --system docker
adduser ubuntu docker
snap install docker

curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | tee /etc/apt/sources.list.d/tailscale.list
apt-get update
apt-get install tailscale

tailscale up -authkey <tskey>
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
[favorite instance types]: https://instances.vantage.sh/?region=us-west-1&cost_duration=weekly&compare_on=true&selected=m5zn.12xlarge,m6g.16xlarge,c6g.16xlarge,m5zn.6xlarge,m6g.12xlarge,c6g.12xlarge,m6g.8xlarge,c6g.8xlarge,m5zn.3xlarge,m6g.4xlarge,c6g.4xlarge,t4g.2xlarge
