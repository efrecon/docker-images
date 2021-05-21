ARG HELM_VERSION=v3.5.4
FROM efrecon/helm:${HELM_VERSION}

# Version for helm. When version is "latest", it will be actively replaced by
# the latest version from gihub.
ARG VCLUSTER_VERSION=latest
ARG VCLUSTER_RELROOT=https://github.com/loft-sh/vcluster/releases

# Metadata
LABEL MAINTAINER efrecon+github@gmail.com
LABEL org.opencontainers.image.title="vcluster"
LABEL org.opencontainers.image.description="vcluster client in Docker"
LABEL org.opencontainers.image.authors="Emmanuel Frécon <efrecon+github@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images/vcluster"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/vcluster/README.md"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/vcluster/Dockerfile"

COPY bininstall/*.sh /usr/local/bin/

# Install kubectl
RUN if [ "$VCLUSTER_VERSION" = "latest" ]; then VCLUSTER_VERSION=$(wget -q  -O - "$VCLUSTER_RELROOT"|grep 'href="/loft-sh/vcluster/releases/tag/v[0-9]*.[0-9]*.[0-9]*\"' | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}'); fi \
    && bininstall.sh -v -b vcluster "${VCLUSTER_RELROOT%/}/download/v${VCLUSTER_VERSION#v*}/vcluster-linux-amd64"

ENTRYPOINT [ "/usr/local/bin/vcluster" ]
CMD [ "help" ]
