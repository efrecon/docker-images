FROM alpine:3.14

ARG JQ_VERSION=latest
ARG JQ_GHPROJ=stedolan/jq
ARG JQ_RELROOT=https://github.com/${JQ_GHPROJ}/releases
ARG JQ_APIROOT=https://api.github.com/repos/${JQ_GHPROJ}
ARG JQ_DWROOT=${JQ_RELROOT}/download

# Metadata
LABEL MAINTAINER efrecon+github@gmail.com
LABEL org.opencontainers.image.title="jq"
LABEL org.opencontainers.image.description="jq in Docker"
LABEL org.opencontainers.image.authors="Emmanuel Frécon <efrecon+github@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images/jq"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/jq/README.md"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/jq/Dockerfile"

RUN apk add --no-cache curl
COPY bininstall/*.sh /usr/local/bin/

# Install bat
RUN if [ "$JQ_VERSION" = "latest" ]; then JQ_VERSION=$(wget -q -O - "${JQ_APIROOT}/releases" | grep -oE '[[:space:]]*"tag_name"[[:space:]]*:[[:space:]]*"jq-([0-9]+\.[0-9]+)"' | sed -E 's/[[:space:]]*"tag_name"[[:space:]]*:[[:space:]]*"jq-([0-9]+\.[0-9]+)"/\1/' | head -n 1); fi \
    && bininstall.sh -v -b jq "${JQ_DWROOT%/}/jq-${JQ_VERSION#v*}/jq-linux64"

ENTRYPOINT [ "/usr/local/bin/jq" ]
CMD [ "-h" ]
