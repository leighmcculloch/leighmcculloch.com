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

Use Docker as you normally do:
```
docker build ...
```

[Docker] has been a pivotal technology in my toolbox for a number of years.  For
deployment yes, but more so for my development environment. I'm a Linux native
living in a Mac world and Docker has made it possible to develop software using
the Linux tools I'm familiar with. Most recently I've been using Docker's Mac
product, [Docker Desktop], like many developers who use Macs.

As wonderful as it is that Docker provides me with reproducible development
environments, Docker Desktop hasn't been all rainbows and sunshine. For about a
year I've been experiencing random high CPU usage with Docker Desktop. It occurs
at the most inopportune time, high CPU Docker, causing my computer to crawl to a
halt, fans spinning loudly like a jet taking off.

I've been wanting to look at alternatives to Docker Desktop for sometime, but
for the most part there was always something else more important to do. However,
on August 31st, 2021, Docker announced a new pricing model for Docker Desktop.
I don't have any huge issue with this, but it's inconvenient and the friction of
"do I need a subscription?" flowchart was the final push I needed to explore
other options for virtualized or containerized workflows on Mac. I tried Podman,
VMWare Fusion's vctl, qemu, Vagrant, and Multipass, but let's face it, Docker is
convenient and its ubiquity is unparalleled.

Thankfully all we need to run Docker on Mac without Docker Desktop is a virtual
machine to host the Docker daemon. The Docker client is available for Mac and
can connect over SSH or TCP to any remote daemon.

Enter Multipass. [Multipass] is a convenient tool for launching Ubuntu virtual
machines. It turns out it works really well on Mac and at this point might be
the simplest lowest-effort tool for running Linux VMs on Mac, assuming you're
into Ubuntu.

Needing to setup a virtual machine from scratch with Docker is tedious, and so I
created [Dockerhost] to wrap the process. Dockerhost is a script that wraps
Multipass and launches Ubuntu VMs that have Docker running and accessible over
TCP.

Dockerhost and Multipass are not as feature rich as Docker Desktop, but they
have what I need for my workflow, and so far I haven't experienced those high
CPU woes.

I'm using Dockerhost for my own Docker driven development environments. If you
have any feedback, please open an issue at:

https://github.com/leighmcculloch/dockerhost

_Why not [Podman]? I'm excited about Podman and I expect to be using it in the
future, but it isn't compatible with VSCode and I ran into a few issues running
images so it isn't quite a Docker replacement for me. I'm very keen to use it
though, and I just had [my first
contribution](https://github.com/containers/buildah/commit/58a16f97689cc96b1a69a03d773c4399413f8854)
to the Podman sibling Buildah merged last week, which was thrilling. It's not
quite a drop-in replacement for my workflows yet by I'll be keeping my eye on
it._

_Why not qemu? You overestimate my current ability and the amount of free time I
have.  😅_

[Dockerhost]: https://github.com/leighmcculloch/dockerhost
[Docker]: https://docker.com
[Docker Desktop]: https://docker.com/products/docker-desktop
[Multipass]: https://multipass.run
[Podman]: https://podman.io
