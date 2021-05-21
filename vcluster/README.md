# `helm` in Docker

This Docker image provides the [`vcluster`][vcluster] CLI.

  [vcluster]: https://vcluster.com/

The image provides a number of build-time arguments that can be changed:

* `HELM_VERSION` should be an existing version of the `helm` client (with or
  without the leading `v`).
* `VCLUSTER_VERSION` can either be the string `latest`, or an existing version
  (with or without the leading `v`). When `latest`, the latest stable version at
  build-time will be installed, otherwise the version matching the value of the
  build-time argument, if it exists.

`vcluster` is the entrypoint of the image. To use the image, you will probably
have to mount your kubeconfig file and the default helm directories (alt.
declare these through `HELM_CACHE_HOME`, `HELM_CONFIG_HOME` and
`HELM_DATA_HOME`), e.g.

```shell
docker run -it --rm \
  -u $(id -u):$(id -g) \
  -v ${HOME}/.kube/config:/.kube/config:ro \
  -v ${HOME}/.cache/helm:/.cache/helm \
  -v ${HOME}/.config/helm:/.config/helm \
  -v ${HOME}/.local/share/helm:/.local/share/helm \
  efrecon/vcluster help
```

Everytime a new stable version of `vcluster` is made available, this image will
automatically be rebuilt. At the time of the build, the latest version of `helm`
will be detected and the build will generate an image that has both binaries.
The same kind of dependency exists towards `kubectl`, which is also installed in
the image. This means that every time the image is rebuilt, the latest of
`helm` will be used. This is a known side-effect of the build process and
might not always be what you want.
