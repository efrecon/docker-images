FROM alpine:3.14

ARG BAT_VERSION=latest
ARG BAT_GHPROJ=sharkdp/bat
ARG BAT_RELROOT=https://github.com/${BAT_GHPROJ}/releases
ARG BAT_DWROOT=${BAT_RELROOT}/download

# Metadata
LABEL MAINTAINER efrecon+github@gmail.com
LABEL org.opencontainers.image.title="bat"
LABEL org.opencontainers.image.description="bat in Docker"
LABEL org.opencontainers.image.authors="Emmanuel Frécon <efrecon+github@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images/bat"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/bat/README.md"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/bat/Dockerfile"

RUN apk add --no-cache less curl git
COPY bininstall/*.sh /usr/local/bin/

# Install bat
RUN if [ "$BAT_VERSION" = "latest" ]; then BAT_VERSION=$(wget -q  -O - "$BAT_RELROOT"|grep "href=\"/${BAT_GHPROJ}/releases/tag/v[0-9].[0-9]*.[0-9]*\"" | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}'); fi \
    && tarinstall.sh -v -x "bat-v${BAT_VERSION#v*}-x86_64-unknown-linux-musl/bat" "${BAT_DWROOT%/}/v${BAT_VERSION#v*}/bat-v${BAT_VERSION#v*}-x86_64-unknown-linux-musl.tar.gz"

ENTRYPOINT [ "/usr/local/bin/bat" ]
CMD [ "-h" ]
