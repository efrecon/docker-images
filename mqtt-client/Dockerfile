FROM alpine:3.11

# OCI Meta information
LABEL org.opencontainers.image.authors="Emmanuel Frecon <efrecon@gmail.com>"
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.version="3.11"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/mqtt-client/Dockerfile"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/mqtt-client/README.md"
LABEL org.opencontainers.image.licenses="BSD"
LABEL org.opencontainers.image.title="MQTT Client"
LABEL org.opencontainers.image.description="mosquitto clients for sending data and/or subscribing to topics"

VOLUME /opt/certs

RUN apk add --no-cache mosquitto-clients ca-certificates && \
    /etc/ca-certificates/update.d/certhash && \
    ln -s /usr/bin/mosquitto_pub /usr/local/bin/pub && \
    ln -s /usr/bin/mosquitto_sub /usr/local/bin/sub

USER nobody
