FROM alpine:edge

ENV STUNNEL_VERSION 5.44

RUN set -x \
 && addgroup -S stunnel \
 && adduser -S -G stunnel stunnel \
 && apk add --update --no-cache \
        ca-certificates \
        gettext \
        libintl \
        openssl-dev \
        wget \
        build-base \
        linux-headers \
        openssl \
 && cp -v /usr/bin/envsubst /usr/local/bin/ \
 && apk del --purge gettext \        
 && mkdir -p /tmp/src \
 && cd /tmp/src \
 && wget --no-check-certificate https://www.stunnel.org/downloads/stunnel-${STUNNEL_VERSION}.tar.gz \
 && tar -zxvf stunnel-${STUNNEL_VERSION}.tar.gz \
 && cd stunnel-${STUNNEL_VERSION} \
 && ./configure \
 && make \
 && make install \
 && apk del --purge build-base wget linux-headers \
 && rm -rf /tmp/src \
 && apk --no-network info openssl

COPY *.template openssl.cnf /srv/stunnel/
COPY stunnel.sh /srv/

RUN set -x \
 && chmod +x /srv/stunnel.sh \
 && mkdir -p /var/run/stunnel /var/log/stunnel \
 && chown -vR stunnel:stunnel /var/run/stunnel /var/log/stunnel

VOLUME ["/etc/stunnel"]

ENTRYPOINT ["/srv/stunnel.sh", "stunnel", "/etc/stunnel/stunnel.conf"]
