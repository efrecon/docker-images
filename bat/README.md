# bat

This [project] automatically builds alpine-based Docker [images] for [bat].
Images are tagged after the name of the [bat] release at github, e.g. `v0.18.1`,
and new releases are automatically detected. Detection happens using
[talonneur], running at [gitlab]; building uses the Docker Hub infrastructure
and [hooks](./hooks/).

  [project]: https://github.com/efrecon/docker-images/tree/master/bat
  [images]: https://hub.docker.com/r/efrecon/bat
  [bat]: https://github.com/sharkdp/bat
  [talonneur]: https://github.com/YanziNetworks/talonneur
