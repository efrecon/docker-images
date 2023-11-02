# miniserve

This [project] automatically builds alpine-based Docker [images] for
[miniserve]. Images are tagged after the name of the [miniserve] release at
github, e.g. `v0.18.1`, and new releases are automatically detected. The
[images] are created using a GitHub
[workflow](../.github/workflows/miniserve.yml) that automatically relays Docker
Hub-compatible [hooks](./hooks/).

  [project]: https://github.com/efrecon/docker-images/tree/master/miniserve
  [images]: https://hub.docker.com/r/efrecon/miniserve
  [miniserve]: https://github.com/svenstaro/miniserve
  [talonneur]: https://github.com/YanziNetworks/talonneur
