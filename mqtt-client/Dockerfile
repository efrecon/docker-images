FROM alpine
MAINTAINER Emmanuel Frecon <efrecon@gmail.com>

VOLUME /opt/certs

RUN apk add --no-cache mosquitto-clients && \
    ln -s /usr/bin/mosquitto_pub /usr/local/bin/pub && \
    ln -s /usr/bin/mosquitto_sub /usr/local/bin/sub
