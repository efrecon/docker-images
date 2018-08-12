# Disque Docker Image

This is a Docker minimal image for running [Disque], an in-memory, distributed
job queue from the same [author][antirez] as [redis]. The image is based on
[Alpine] and configuration can happen through setting environment variables
starting with `DISQUE_`.

## Usage

To create a disque server, run the following command:

    docker run efrecon/disque:1.0-rc1

Any configuration variable that appears in the default Disque [configuration]
can be set in two different ways:

1. By appending a command-line option which name is the same as the
   configuration variable, though led by a double-dash. This is as per the
   Disque main server behaviour.

2. By setting an environment variable according to the following rules: the
   environment variable will be in uppercase, all single dashes from the Disque
   configuration variable should be replaced by underscores and the environment
   variable should start with `DISQUE_`.

So, to set the port, you could run any of the two commands below:

    docker run efrecon/disque:1.0-rc1 --port 3456
    docker run --env DISQUE_PORT=3456 efrecon/disque:1.0-rc1

## Implementation

This image takes its roots in [richnorth/disque], while being based on the
minimal [Alpine] image and taking heavy inspiration of the [official] redis
image. The image is directly compiled from the official released source. To
ensure proper compilation on Alpine, support for backtrace is manually removed
from [config.h] in the [Dockerfile](./Dockerfile).

Support for environment variables led by `DISQUE_` is implemented as part of the
entrypoint. The implementation will copy the default configuration file from
Disque, modify it per the environment variables and start with the disque server
using the modified copy of the default configuration file.

  [Disque]: https://github.com/antirez/disque
  [antirez]: https://github.com/antirez/
  [redis]: https://github.com/antirez/redis
  [richnorth/disque]: https://hub.docker.com/r/richnorth/disque/
  [Alpine]: https://hub.docker.com/_/alpine/
  [official]: https://github.com/docker-library/redis/tree/master/4.0/alpine
  [config.h]: https://github.com/antirez/disque/blob/master/src/config.h
  [configuration]: https://github.com/antirez/disque/blob/master/disque.conf