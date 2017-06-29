# efrecon/stunnel

This image is heavily inspired by
[dweomer/stunnel](https://github.com/dweomer/dockerfiles-stunnel) with
modifications in order to be able to use the PSK-client mode of stunnel. This
implies not being able to rely on the regular stunnel package from Alpine, and
leads to an implementation that compiles from the sources. Therefor... the
complete fork!

## Stunnel on Alpine
To secure an LDAP container named `directory`:

```
docker run -itd --name ldaps --link directory:ldap \
        -e STUNNEL_SERVICE=ldaps \
        -e STUNNEL_ACCEPT=636 \
        -e STUNNEL_CONNECT=ldap:389 \
        -p 636:636 \
#       -v /etc/ssl/private/server.key:/etc/stunnel/stunnel.key:ro \
#       -v /etc/ssl/private/server.crt:/etc/stunnel/stunnel.pem:ro \
    efrecon/stunnel
```
