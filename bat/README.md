# bat

This [project] automatically builds alpine-based Docker [images] for [bat].
Images are tagged after the name of the [bat] release at github, e.g. `v0.18.1`,
and new releases are automatically detected. The [images] are created using a
GitHub [workflow](../.github/workflows/bat.yml) that automatically relays Docker
Hub-compatible [hooks](./hooks/).

  [project]: https://github.com/efrecon/docker-images/tree/master/bat
  [images]: https://hub.docker.com/r/efrecon/bat
  [bat]: https://github.com/sharkdp/bat
  [talonneur]: https://github.com/YanziNetworks/talonneur
