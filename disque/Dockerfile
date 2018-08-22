FROM alpine:3.8
MAINTAINER efrecon@gmail.com

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S disque && adduser -S -G disque disque

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

ARG DISQUE_VERSION=1.0-rc1
ARG DISQUE_DOWNLOAD_URL=https://github.com/antirez/disque/archive/${DISQUE_VERSION}.tar.gz
ARG DISQUE_DOWNLOAD_SHA=2d6fc85d16c8009154fc24d7fb004708f864712853d417cbea74bb6c2694e134

RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		coreutils \
		gcc \
		jemalloc-dev \
		linux-headers \
		make \
		musl-dev \
        curl \
	; \
	\
    curl -sSL -o disque.tar.gz "${DISQUE_DOWNLOAD_URL}"; \
	echo "$DISQUE_DOWNLOAD_SHA *disque.tar.gz" | sha256sum -c -; \
	mkdir -p /usr/src/disque; \
	tar -xzf disque.tar.gz -C /usr/src/disque --strip-components=1; \
	rm disque.tar.gz; \
	\
# Manually disable backtrace as this is not supported by musl and internal testing
# is hard-coded to being on linux (thus assuming libc)
    sed -ri 's!^#define HAVE_BACKTRACE 1$!#undef HAVE_BACKTRACE!' /usr/src/disque/src/config.h; \
	make -C /usr/src/disque -j "$(nproc)"; \
	make -C /usr/src/disque install; \
# Keep a copy of the default configuration so we can use it
    cp /usr/src/disque/disque.conf /usr/local/share/disque.conf; \
	\
	rm -r /usr/src/disque; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .disque-rundeps $runDeps; \
	apk del .build-deps; \
	\
	disque-server --version

RUN mkdir /data && chown disque:disque /data
VOLUME /data
WORKDIR /data

COPY *.sh /usr/local/bin/

EXPOSE 7711 17711

HEALTHCHECK CMD [ "healthcheck.sh" ]
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "disque-server" ]