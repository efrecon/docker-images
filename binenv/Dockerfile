FROM alpine:3.14

ARG BINENV_VERSION=latest
ARG BINENV_GHPROJ=devops-works/binenv
ARG BINENV_RELROOT=https://github.com/${BINENV_GHPROJ}/releases
ARG BINENV_DWROOT=${BINENV_RELROOT}/download

# Metadata
LABEL MAINTAINER efrecon+github@gmail.com
LABEL org.opencontainers.image.title="binenv"
LABEL org.opencontainers.image.description="binenv in Docker"
LABEL org.opencontainers.image.authors="Emmanuel Frécon <efrecon+github@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images/binenv"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/binenv/README.md"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/binenv/Dockerfile"

RUN apk add --no-cache less curl git
COPY bininstall/*.sh /usr/local/bin/

# Install binenv
RUN if [ "$BINENV_VERSION" = "latest" ]; then BINENV_VERSION=$(wget -q  -O - "$BINENV_RELROOT"|grep "href=\"/${BINENV_GHPROJ}/releases/tag/v[0-9].[0-9]*.[0-9]*\"" | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}'); fi \
    && bininstall.sh -v -b binenv "${BINENV_DWROOT%/}/v${BINENV_VERSION#v*}/binenv_linux_amd64" \
    && chmod a+x /usr/local/bin/binenv \
    && mkdir -p ~/.binenv/binaries/binenv \
    && chmod -R a+r ~/.binenv \
    && ln -s /usr/local/bin/binenv ~/.binenv/binaries/binenv/${BINENV_VERSION#v*} \
    && chmod a+x ~/.binenv/binaries/binenv/${BINENV_VERSION#v*} \
    && cd ~/.binenv \
    && ln -s binaries/binenv/${BINENV_VERSION#v*} shim \
    && ln -s shim binenv

# Add binenv to the PATH, at the end on purpose.
ENV PATH="${PATH}:/root/.binenv"

ENTRYPOINT [ "binenv" ]
CMD [ "help" ]
