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

# Add GNU C compatibility layer, and curl so we can download
RUN apk add --no-cache curl gcompat

COPY distribution/*.sh /usr/local/bin/

# Install binenv through requesting a list of known distributions, and remove
# caches.
RUN /usr/local/bin/binenv.sh -v distributions > /dev/null \
    && ln -s /root/.binenv/binenv /usr/local/bin/binenv \
    && rm -rf /root/.config/binenv /root/.cache/binenv

# Add binenv to the PATH, at the end on purpose.
ENV PATH="${PATH}:/root/.binenv"

ENTRYPOINT [ "binenv" ]
CMD [ "help" ]
