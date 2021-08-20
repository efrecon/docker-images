FROM alpine:3.14

ARG ACT_VERSION=latest
ARG ACT_GHPROJ=nektos/act
ARG ACT_RELROOT=https://github.com/${ACT_GHPROJ}/releases
ARG ACT_DWROOT=${ACT_RELROOT}/download

# Metadata
LABEL MAINTAINER efrecon+github@gmail.com
LABEL org.opencontainers.image.title="act"
LABEL org.opencontainers.image.description="act in Docker"
LABEL org.opencontainers.image.authors="Emmanuel Frécon <efrecon+github@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images/act"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/act/README.md"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/act/Dockerfile"

RUN apk add --no-cache less curl git
COPY bininstall/*.sh /usr/local/bin/

# Install act
RUN if [ "$ACT_VERSION" = "latest" ]; then ACT_VERSION=$(wget -q  -O - "$ACT_RELROOT"|grep "href=\"/${ACT_GHPROJ}/releases/tag/v[0-9].[0-9]*.[0-9]*\"" | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}'); fi \
    && tarinstall.sh -v -x "act" "${ACT_DWROOT%/}/v${ACT_VERSION#v*}/act_Linux_x86_64.tar.gz"

ENTRYPOINT [ "/usr/local/bin/act" ]
CMD [ "--help" ]
