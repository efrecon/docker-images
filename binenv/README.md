# binenv

This [project] automatically builds alpine-based Docker [images] for [binenv].
Images are tagged after the name of the [binenv] release at github, e.g.
`v0.2.24`, and new releases are automatically detected. The [images] are created
using a GitHub [workflow](../.github/workflows/binenv.yml) that automatically
relays Docker Hub-compatible [hooks](./hooks/).

  [project]: https://github.com/efrecon/docker-images/tree/master/binenv
  [images]: https://hub.docker.com/r/efrecon/binenv
  [binenv]: https://github.com/nektos/binenv
