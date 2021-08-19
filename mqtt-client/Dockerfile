ARG ALPINE_VERSION=3.14.1
FROM alpine:${ALPINE_VERSION}

ARG MOSQUITTO_VERSION=2.0.11
ARG PACKAGE_RELEASE=0

# OCI Meta information
LABEL org.opencontainers.image.authors="Emmanuel Frecon <efrecon@gmail.com>"
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.version=${MOSQUITTO_VERSION}
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/mqtt-client/Dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/mqtt-client/README.md"
LABEL org.opencontainers.image.licenses="BSD"
LABEL org.opencontainers.image.title="MQTT Client"
LABEL org.opencontainers.image.description="mosquitto clients for sending data and/or subscribing to topics"

VOLUME /opt/certs

RUN apk add --no-cache ca-certificates tini mosquitto-clients=${MOSQUITTO_VERSION}-r${PACKAGE_RELEASE} && \
    /etc/ca-certificates/update.d/certhash && \
    ln -s /usr/bin/mosquitto_pub /usr/local/bin/pub && \
    ln -s /usr/bin/mosquitto_sub /usr/local/bin/sub

USER nobody
ENTRYPOINT [ "/sbin/tini", "--" ]
