# binenv-based Docker Images

This directory contains a multi-stage Dockerfile and a number of scripts to
allow the creation of Docker Images for all the tools that are supported by
[binenv].

The [build](./build) and [push](./push) will inject the wrapper
[binenv.sh](./binenv.sh) script into the `binenv` image created by this
[project](../) to detect all the known versions for a `binenv` supported tool,
a.k.a. distribution. For all versions, the scripts will use the multi-stage
[Dockerfile](./Dockerfile) to create a Docker image with the binary of the
distribution placed on top of the busybox image.

  [binenv]: https://github.com/devops-works/binenv
