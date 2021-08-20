# act

This [project] automatically builds alpine-based Docker [images] for [act].
Images are tagged after the name of the [act] release at github, e.g. `v0.2.24`,
and new releases are automatically detected.

  [project]: https://github.com/efrecon/docker-images/tree/master/act
  [images]: https://hub.docker.com/r/efrecon/act
  [act]: https://github.com/nektos/act

## Usage

To use these images, you will have to bind-mount the Docker socket and your
current directory. For example, from the root [directory](../) of this project
you could run the following command to trigger the `act` job of the github
workflows. Note that this command makes use of the `-b` option to `act` to
bind-mount the same directory a second time (this time: into `act`). Also, note
that this command would actually fail as you would have to specify additional
secrets using the `act` command-line option `-s`.

```console
docker run \
  -it --rm \
  -v $(pwd):$(pwd) \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w $(pwd) \
  efrecon/act:v0.2.24 \
    -b \
    -j act \
    -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
```
