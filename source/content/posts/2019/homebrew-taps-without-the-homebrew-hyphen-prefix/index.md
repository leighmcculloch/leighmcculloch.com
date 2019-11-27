+++
slug = "homebrew-taps-without-the-homebrew-hyphen-prefix"
title = "Homebrew taps without the homebrew- prefix"
date = 2019-11-26
+++

Distributing binaries through custom [Homebrew taps](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap#creating-a-tap) is a really simple way to make binaries more accessible on Linux and macOS. Building a Homebrew formula is the simplest part, but publishing it to a repo can be a little more complicated. GitHub Actions provides a `GITHUB_TOKEN` secret by default that has write access to the contents of the repository, but not other repositories. Homebrew formulas are normally stored in a separate repository which makes it more difficult to setup.

How creating a tap works is you create a small ruby file that tells the `brew` tool can download the binary from. You put the ruby file in the `Formula` directory of a repository on GitHub named with a `homebrew-` prefix, e.g. `homebrew-<tap-name>`. You can then install any formula from that tap with the command `brew install <github-username>/<tap-name>/<formula-name>`.

If I wanted to release a formula for my tool [gas](https://github.com/leighmcculloch/gas), I'd need to put the formula in a repository named `homebrew-gas` or if I wanted to bundle all my formulas together, `homebrew-tap`. To do this with GitHub Actions would require creating a new `GITHUB_TOKEN` that has access to all my repositories because the default `gas` repository `GITHUB_TOKEN` secret doesn't have write access to any other repository.

Good news, we can use GitHub's repository rename and redirect feature to make it work!

For my `gas` repository I can rename the repository temporarily to `homebrew-gas` and then back to `gas`. From here on GitHub will redirect any requests relating to `homebrew-gas` to `gas`. I have the formula in that repository and GitHub Actions needs no additional credentials to generate the formula on every release. You can even temporarily transfer repos to an organization and back to make use of redirects.

If you'd like to see it in action check these links out:

- https://github.com/leighmcculloch/gas/commit/8a3f120/checks?check_suite_id=328892361
- https://github.com/leighmcculloch/gas/blob/8a3f120/.github/workflows/release.yml#L14-L16
- https://github.com/leighmcculloch/gas/blob/8a3f120/Makefile#L4-L5
- https://github.com/leighmcculloch/gas/blob/8a3f120/Formula/gas.rb

A user can install `gas` by typing `brew install 4d63/gas/gas` and it uses the formula above that is written by GitHub Actions without any secrets defined beyond the default `GITHUB_TOKEN` that GitHub provides.
