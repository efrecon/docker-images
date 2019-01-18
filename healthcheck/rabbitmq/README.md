# Healthchecked RabbitMQ

This is an identical copy of the Docker official [rabbitmq] image, with an
additional healthcheck. Checking logic is copied from the official
[healthcheck]. What this image brings is the availability of all [tags] forward,
starting from its inception. This is achived through hooks that will collect the
[tags] and build from all existing official images while adding the healthcheck
layer on top.

When [configuring] HiPE compiling, you should arrange for a much larger start
period than the default one. This can be done both from the command line with
the `--health-start-period` option for [run], or overriding `start_period` in a
[compose] file.

  [rabbitmq]: https://hub.docker.com/_/rabbitmq
  [healthcheck]: https://github.com/docker-library/healthcheck/tree/master/rabbitmq
  [tags]: https://github.com/docker-library/official-images/blob/master/library/rabbitmq
  [configuring]: http://www.rabbitmq.com/configure.html#config-items
  [run]: https://docs.docker.com/engine/reference/#healthcheck
  [compose]: https://docs.docker.com/compose/compose-file/#healthcheck