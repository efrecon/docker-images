# Krew-Capable `kubectl` in Docker

This Docker image provides a `kubectl` with a number of [`krew`][krew]
[plugins].

  [krew]: https://krew.sigs.k8s.io/
  [plugins]: https://krew.sigs.k8s.io/plugins/

The image provides a number of build-time arguments that can be changed:

* `K8S_VERSION` can either be the string `stable`, or an existing version (with
  or without the leading `v`). When `stable`, the latest stable version at
  build-time will be installed, otherwise the version matching the value of the
  build-time argument, if it exists.
* `KREW_VERSION` should be the name of an existing version of [krew]. The
  default is `latest`, but it is also possible to specify a specific version of
  [krew]. When specifying versions, they **must** start with a `v`.
* `KREW_PLUGINS` should be a space separated list of existing [plugins] to
  install.

Within the image, all [krew] [plugins] are installed at the location specified
by the environment variable [`KREW_ROOT`][advanced-config] and the `PATH` is
modified so that it contains `$KREW_ROOT/bin` as its first directory.

  [advanced-config]: https://krew.sigs.k8s.io/docs/user-guide/advanced-configuration/

`kubectl` is the entrypoint of the image. To use the image, you will probably
have to mount your kubeconfig file, e.g.

```shell
docker run -it --rm -v ${HOME}/.kube/config:/root/.kube/config:ro efrecon/kubectl version
```
