FROM alpine:3.17

ARG MINISERVE_VERSION=latest
ARG MINISERVE_GHPROJ=svenstaro/miniserve
ARG MINISERVE_RELROOT=https://github.com/${MINISERVE_GHPROJ}/releases
ARG MINISERVE_DWROOT=${MINISERVE_RELROOT}/download

# Metadata
LABEL MAINTAINER efrecon+github@gmail.com
LABEL org.opencontainers.image.title="miniserve"
LABEL org.opencontainers.image.description="For when you really just want to serve some files over HTTP right now!"
LABEL org.opencontainers.image.authors="Emmanuel Frécon <efrecon+github@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images/miniserve"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/miniserve/README.md"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/miniserve/Dockerfile"

RUN apk add --no-cache less curl git
COPY bininstall/*.sh /usr/local/bin/

# Install bat
RUN if [ "$MINISERVE_VERSION" = "latest" ]; then MINISERVE_VERSION=$(wget -q  -O - "$MINISERVE_RELROOT"|grep "href=\"/${MINISERVE_GHPROJ}/releases/tag/v[0-9].[0-9]*.[0-9]*\""|grep -v no-underline | head -n 1 | grep -oE 'href="[^"]+' | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}'); fi \
    && bininstall.sh -v -b miniserve "${MINISERVE_DWROOT%/}/v${MINISERVE_VERSION#v*}/miniserve-${MINISERVE_VERSION#v*}-x86_64-unknown-linux-musl"

ENTRYPOINT [ "/usr/local/bin/miniserve" ]
CMD [ "-h" ]
