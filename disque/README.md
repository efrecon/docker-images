# Disque Docker Image

This is a Docker minimal image for running [Disque], an in-memory, distributed
job queue from the same [author][antirez] as [redis]. The image is based on
[Alpine] and configuration can happen through setting environment variables
starting with `DISQUE_`. The special environment variable `DISQUE_MEET` can be
used to establish cluster formations.

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

## Clustering

The environment variable `DISQUE_MEET` can be used to meet a number of other
already running Disque server. The variable should contain a space separated
list of pairs `<hostname>:<port>` where `<port>` (and the colon sign preceeding
it) can be omitted and will default to 7711. While Disque require the `MEET`
command to accept an IP address, creating the cluster using the `DISQUE_MEET`
environment variable allows for hostnames, which facilitates the creation of
distributed clusters. From this directory, and using the example
[compose](docker-compose.yml) file, you can easily create a cluster of 3 nodes
using the following command (assuming that you have `docker-compose` installed):

    docker-compose up --scale slave=2

Disque has no slave or master. In the example setup, the runtime existence of
the three equivalent nodes ensures the persistence of the queues. The compose
file persists queue state into a volume associated to the `master` service to
ease cold restarts.

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

The only exception to these `DISQUE_` environment variables is the
`DISQUE_MEET`. Instead, whenever it exists, a temporary helper process
implemented as [meet.sh](meet.sh) will wait for the local Disque server to be
running, resolve all hostnames pointed at by the content of the `DISQUE_MEET`
environment variable and request the local Disque server to meet those remote IP
addresses. The implementation will automatically wait for the remote servers to
be up and running (and available at the relevant port) before trying to join.

  [Disque]: https://github.com/antirez/disque
  [antirez]: https://github.com/antirez/
  [redis]: https://github.com/antirez/redis
  [richnorth/disque]: https://hub.docker.com/r/richnorth/disque/
  [Alpine]: https://hub.docker.com/_/alpine/
  [official]: https://github.com/docker-library/redis/tree/master/4.0/alpine
  [config.h]: https://github.com/antirez/disque/blob/master/src/config.h
  [configuration]: https://github.com/antirez/disque/blob/master/disque.conf