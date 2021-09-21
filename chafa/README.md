# chafa

This [project] automatically builds ubuntu-based Docker [images] for [chafa].
Images are tagged after the name of the [chafa] release at github, e.g. `1.8.0`,
and new releases are automatically detected. The [images] are created using a
GitHub [workflow](../.github/workflows/chafa.yml) that automatically relays
Docker Hub-compatible [hooks](./hooks/).

  [project]: https://github.com/efrecon/docker-images/tree/master/chafa
  [images]: https://hub.docker.com/r/efrecon/chafa
  [chafa]: https://github.com/hpjansson/chafa

## Usage

To use these Docker images, you will have to bind-mount your current directory
and probably respect user and group permissions. For example, the following
command would let you display any image present in your current directory or
below, if you replaced the `--help` with the relative path to an image.

```console
docker run \
  -it --rm \
  -v $(pwd):$(pwd) \
  -u $(id -u):$(id -g) \
  -w $(pwd) \
  efrecon/chafa:1.8.0 --help
```
