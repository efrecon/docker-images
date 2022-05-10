# ts-node

This [project] automatically builds Alpine Docker [images] for [ts-node]. Images
are tagged after the name of the [ts-node] release at github, e.g. `10.0.0`, and
new releases are automatically detected. The [images] are created using a GitHub
[workflow](../.github/workflows/ts-node.yml) that automatically relays Docker
Hub-compatible [hooks](./hooks/).

  [project]: https://github.com/efrecon/docker-images/tree/master/ts-node
  [images]: https://hub.docker.com/r/efrecon/ts-node
  [ts-node]: https://github.com/hpjansson/ts-node

## Usage

To use these Docker images, you will have to bind-mount your current directory
and probably respect user and group permissions. For example, the following
command would provide you with an interactive TypeScript REPL with access to the
current directory and its descendants.

```console
docker run \
  -it --rm \
  -v $(pwd):$(pwd) \
  -u $(id -u):$(id -g) \
  -w $(pwd) \
  efrecon/ts-node:10.7.0
```
