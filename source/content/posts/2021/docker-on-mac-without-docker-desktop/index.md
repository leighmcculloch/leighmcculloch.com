+++
slug = "docker-on-mac-without-docker-desktop"
title = "Docker on Mac without Docker Desktop"
date = 2021-09-12
+++

[Dockerhost] is a small tool that sets up a virtual machine hosting a Docker
daemon. The docker client running locally on Mac can run all its Docker
workloads on the docker host.

Install dockerhost:
```
brew install 4d63/dockerhost/dockerhost
```

Create a docker host:
```
dockerhost create
```

Set the `DOCKER_HOST` environment variable:
```
eval $(dockerhost env)
```

Use Docker as you normally would:
```
docker build ...
```

Containers, and their popularity via [Docker], has been one of those pivotal
technologies in my toolbox for a number of years. For deployment yes, but more
so for my development environments. I'm a Linux native living in a Mac world and
Docker has allowed me to develop software using the Linux environment and tools
I'm familiar with. Most recently I've been using Docker's Mac product, [Docker
Desktop], like many developers who work on Mac's.

For all the benefits and wonders Docker provides to me with reproducible
development environments, it hasn't been all rainbows and sunshine. For about a
year I've been experiencing high CPU usage in Docker. I'll be working hard
towards a deadline, then enter high CPU Docker, and it feels like my computer is
old and slow. Each time this happens I get one step closer to switching back to
Linux.

On August 31st, 2021, Docker announces a new pricing model for Docker Desktop.
This raised the question for me, what else is going to change about Docker's
licensing in the future. It was the final push I needed to look at other options
virtualized or containerized workflows on Mac.

Thankfully all we need to run Docker on Mac is a virtual machine to host the
Docker daemon. The Docker client is available for Mac and can connect over SSH
or TCP to any remote daemon.

Enter Multipass. [Multipass] is a convenience tool for launching Ubuntu virtual
machines. It turns out it works really well on Mac and at this point might be
the simplest low-effort method for running Linux VMs on Mac, assuming you're
into Ubuntu.

Needing to setup a virtual machine from scratch with Docker is tedious, and so I
created Dockerhost to wrap the process. Dockerhost is a zsh script that wraps
Multipass and launches Ubuntu VMs that have Docker running and accessible over
TCP.

Dockerhost and Multipass are not as feature rich as Docker Desktop, but they
have what I need for my workflow, and so far I haven't experienced those high
CPU woes.

I'm using Dockerhost for my own Docker driven development environments. If you
have any feedback, please open an issue at:

https://github.com/leighmcculloch/dockerhost

_Why not [Podman]? I'm excited about Podman and I expect to be using it in the
future, but it isn't compatible wit VSCode and I ran into a few issues running
images so it isn't quite a Docker replacement for me. I'm very keen to use it
though, and I just had [my first
contribution](https://github.com/containers/buildah/commit/58a16f97689cc96b1a69a03d773c4399413f8854)
to the Podman ecosystem merged last week, which was thrilling. It's not quite a
drop-in replacement for my workflows by I'll be keeping my eye on it._

[Dockerhost]: https://github.com/leighmcculloch/dockerhost
[Docker]: https://docker.com
[Docker Desktop]: https://docker.com/products/docker-desktop
[Multipass]: https://multipass.run
[Podman]: https://podman.io
