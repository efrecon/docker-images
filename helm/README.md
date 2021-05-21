# `helm` in Docker

This Docker image provides `helm` on top of the [krew] capable `kubectl`
[image][kubectl-image] and [project][kubectl-project].

  [krew]: https://krew.sigs.k8s.io/
  [kubectl-image]: https://hub.docker.com/r/efrecon/kubectl
  [kubectl-project]: https://github.com/efrecon/docker-images/tree/master/kubectl

The image provides a number of build-time arguments that can be changed:

* `K8S_VERSION` should be an existing version of the kubectl client (with or
  without the leading `v`).
* `HELM_VERSION` can either be the string `latest`, or an existing version (with
  or without the leading `v`). When `latest`, the latest stable version at
  build-time will be installed, otherwise the version matching the value of the
  build-time argument, if it exists.

`helm` is the entrypoint of the image. To use the image, you will probably have
to mount your kubeconfig file and the default helm directories (alt. declare
these through `HELM_CACHE_HOME`, `HELM_CONFIG_HOME` and `HELM_DATA_HOME`), e.g.

```shell
docker run -it --rm \
  -u $(id -u):$(id -g) \
  -v ${HOME}/.kube/config:/.kube/config:ro \
  -v ${HOME}/.cache/helm:/.cache/helm \
  -v ${HOME}/.config/helm:/.config/helm \
  -v ${HOME}/.local/share/helm:/.local/share/helm \
  efrecon/helm --version
```

Everytime a new stable version of `helm` is made available, this image will
automatically be rebuilt. At the time of the build, the latest version of
`kubectl` will be detected and the build will generate an image that has both
binaries. This also means that every time the image is rebuilt, the latest of
`kubectl` will be used. This is a known side-effect of the build process and
might not always be what you want.
