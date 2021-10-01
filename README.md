# docker-images

This project contains Dockerfiles for building various and useful self-contained
Docker images. You will find a set of curated and customised
[images](#curated-images), as well as a set of automatically installed
[images](#automatically-built-images), based on the [binenv] project and the
[image](./binenv/README.md) part of the first set of images. The largest part of
all these images (curated or automated) try to follow the releasing tempo of
their original projects. In other words, there will be images tagged with the
same release as the original project's release number published soon after the
releases have been made.

A large set of both types of images is interfaced from the [dew] project. [dew]
makes it possible to run these almost as if you had had the binaries installed
on your system directly, but with the encapsulation advantages of Docker.
Cleaning up your system is then as straightforward as [pruning][prune] unused
Docker objects. Provided you have installed [`dew`][dew] and made it accessible
through your `PATH`, you would run `jq` as with `dew jq` instead. [`dew`][dew]
would then arrange for the files in your starting directory and those below to
be automatically accessible to the temporary container created.

Note that this project used to contain a number of images targetting the
[Kubernetes] ecosystem. These have been moved to a separate [project][k8s]
instead. The kubernetes-oriented project started as a perfect copy of this
project in order to preserve revision history.

  [Kubernetes]: https://kubernetes.io/
  [k8s]: https://github.com/efrecon/k8s-images
  [binenv]: https://github.com/devops-works/binenv
  [dew]: https://github.com/efrecon/dew
  [prune]: https://docs.docker.com/config/pruning/

## Curated Images

Most curated images have their own instructions, some are of historical
interest:

+ [act](./act/README.md) - Run your GitHub Actions locally
+ [bat](./bat/README.md) - A cat(1) clone with wings
+ [binenv](./binenv/README.md) - One binary to rule them all. Manage all those
  pesky binaries (kubectl, helm, terraform, ...) easily.
+ [caddy](./caddy/README.md)
+ [chafa](./chafa/README.md) - Terminal graphics for the 21st century.
+ [disque](./disque/README.md) - Disque is a distributed message broker
+ [jq](./jq/README.md) - Command-line JSON processor
+ [mqtt-client](./mqtt-client/README.md) - Mosquitto's MQTT publish and
  subscribe clients.
+ [pptpd](./pptpd/README.md)
+ [stunnel](./stunnel/README.md)
+ [zedrem](zedrem)

## Automatically Built Images

All automatically built images use the [binenv](./binenv/README.md) image to
download binaries and create a new [image](./binenv/distribution/README.md) with
as little cruft as possible, i.e. just the binary itself insert on top of an
Alpine image able to run glibc compiled binaries if necessary.

+ [awless] - A Mighty CLI for AWS
+ [broot] - A new way to see and navigate directory trees
+ [chezmoi] - Manage your dotfiles across multiple diverse machines, securely.
+ [devdash] - Highly Configurable Terminal Dashboard for Developers and Creators
+ [duf] - Disk Usage/Free Utility - a better 'df' alternative
+ [exa] - A modern replacement for ‘ls’.
+ [fd] - A simple, fast and user-friendly alternative to 'find'
+ [gdu] - Disk usage analyzer with console interface written in Go
+ [gh] - GitHub’s official command line tool
+ [gitui] - Blazing fast terminal-ui for git written in rust
+ [glow] - Render markdown on the CLI, with pizzazz!
+ [gotop] - Just another terminal based graphical activity monitor
+ [gotty] - Share your terminal as a web application

  [awless]: https://github.com/wallix/awless
  [broot]: https://github.com/Canop/broot
  [chezmoi]: https://github.com/twpayne/chezmoi
  [devdash]: https://github.com/Phantas0s/devdash
  [duf]: https://github.com/muesli/du
  [exa]: https://github.com/ogham/exa
  [fd]: https://github.com/sharkdp/fd
  [gdu]: https://github.com/dundee/gdu
  [gh]: https://github.com/cli/cli
  [gitui]: https://github.com/extrawurst/gitui
  [glow]: https://github.com/charmbracelet/glow
  [gotop]: https://github.com/xxxserxxx/gotop
  [gotty]: https://github.com/yudai/gotty
