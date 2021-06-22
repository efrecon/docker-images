# jq

This [project] automatically builds alpine-based Docker [images] for [jq].
Images are tagged after the version of the [jq] release at github, e.g. `1.6`,
and new releases are automatically detected. Detection happens using
[talonneur], running at [gitlab]; building uses the Docker Hub infrastructure
and [hooks](./hooks/).

  [project]: https://github.com/efrecon/docker-images/tree/master/jq
  [images]: https://hub.docker.com/r/efrecon/jq
  [jq]: https://github.com/stedolan/jq
  [talonneur]: https://github.com/YanziNetworks/talonneur
