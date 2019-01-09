# Caddyserver

This image automatically builds from the excellent [caddy] server image by
[Abiola Ibrahim]. It will be updated as soon as the original image publishes a
new tag, which should follow the release schedule of Caddy in the near future.

  [caddy]: https://github.com/abiosoft/caddy-docker
  [Abiola Ibrahim]: https://github.com/abiosoft/

The image comes with a different set of plugins enabled, namely:

  [cors],[realip],[expires],[cache],[webdav],[docker],[ipfilter]

  [cors]: https://github.com/captncraig/cors/blob/master/README.md
  [realip]: https://github.com/captncraig/caddy-realip/blob/master/README.md
  [expires]: https://github.com/epicagency/caddy-expires/blob/master/README.md
  [cache]: https://github.com/nicolasazrak/caddy-cache/blob/master/README.md
  [webdav]: https://github.com/hacdias/caddy-webdav/blob/master/README.md
  [docker]: https://github.com/lucaslorentz/caddy-docker-proxy/blob/master/README.md
  [ipfilter]: https://github.com/pyed/ipfilter/blob/master/README.md