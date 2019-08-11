+++
slug = "ssh-pin-known_hosts-for-github"
title = "SSH: Pin known_hosts for GitHub, BitBucket, etc"
date = 2019-08-10
+++

If you're familiar with SSH configs and files there's a `known_hosts` file you've probably seen that stores for each domain and IP address a known SSH public key. The SSH client uses the key in that file to verify that a hosts key hasn't changed between the first and subsequent connections, since a key changing might be an indicator of a man-in-the-middle attack.

The default SSH config I've come across on Debian and other Linux distros has the SSH client automatically adding new hosts the first time a connection is established, and storing and verifying domains and IP addresses. There are a couple things about this that I've found not to be ideal, at least for my specific use cases:

1. I don't want to automatically add new keys. I only want to connect to hosts I know and trust, and I want to explicitly add new hosts that I plan to trust. While the SSH client does pop a message to the terminal when it adds a new host, I'd rather have a 💥 error that forces me to conciously decide if I want to go ahead and ideally source the key from a trustworthy source. e.g. You can verify GitHub's key [here](https://help.github.com/en/articles/githubs-ssh-key-fingerprints).

2. Some of the hosts I connect to, e.g. GitHub, have [hundreds of IP addresses](https://api.github.com/meta) which makes for maintaining records for both domains and IPs in the `known_hosts` file overwhelming. I have frequently seen new IPs connecting to GitHub that cause permanent diffs in my development environment dotfiles.

3. I connect to GitHub frequently and typing `git@github.com` is repetitive.

As part of my development environment setup I've started using the following configuration instead to address these problems.

### ~/.ssh/config
```
Host *
    HashKnownHosts no
    StrictHostKeyChecking yes
    CheckHostIP no

Host github
    HostName github.com
    User git

Host bitbucket
    Hostname bitbucket.org
    User git
```

- `Hosts *` – Everything under this section apply to any SSH connection, regardless of host.

- `HashKnownHosts no` – This feature is on by default and designed to hide the hostnames in the `known_hosts` file by storing the hash instead of the domain name. I don't need to hide that I connect to GitHub, that should be pretty obvious already and I'd rather be able to see that the key is for github.com, so I turn this off.

- `StrictHostKeyChecking yes` – Turned on this causes the SSH client to error if a key doesn't exist `known_hosts` requiring me to add a key to `known_hosts` before connecting to a new host.

- `CheckHostIP no` – Turned off this causes the SSH client not to bother with storing or verifying the IP address I'm connecting to, instead only using the domain. This is fine for me because I only connect to domains and am still verifying the key against the domain. This keeps me sane when GitHub has so many IPs.

- `Host github` / `Host bitbucket` – This section defines a new shorthand host that I can use to not need to type out the full `git@github.com` user and address. Instead I can use `git clone github:<user>/<repo>`.

### ~/.ssh/known_hosts
```
github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==
```

The `known_hosts` file contains domains/IPs and public keys for each. An easy way to get the GitHub public key into the file is with this command:
```
$ ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
```

And to get the fingerprints of the keys in the `known_hosts` file for verifying out-of-band with [GitHub](https://help.github.com/en/articles/githubs-ssh-key-fingerprints) and others:
```
$ ssh-keygen -l -f ~/.ssh/known_hosts
2048 SHA256:zzXQOXSRBEiUtuE8AikJYKwbHaxvSc0ojez9YXaGp1A bitbucket.org (RSA)
2048 SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8 github.com (RSA)
```

### What's next
I'm continuing to tweak this setup and you can find my config on GitHub: [github.com/leighmcculloch/devenv](https://github.com/leighmcculloch/devenv/tree/master/dotfiles/ssh). Got feedback, ideas, or ways to make this better? I'd love to here it!
