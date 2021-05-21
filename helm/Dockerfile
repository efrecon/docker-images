ARG K8S_VERSION=v1.21.1
FROM efrecon/kubectl:${K8S_VERSION}

# Version for helm. When version is "latest", it will be actively replaced by
# the latest version from gihub.
ARG HELM_VERSION=latest
ARG HELM_RELROOT=https://github.com/helm/helm/releases
ARG HELM_DWROOT=https://get.helm.sh
# Metadata
LABEL MAINTAINER efrecon+github@gmail.com
LABEL org.opencontainers.image.title="helm"
LABEL org.opencontainers.image.description="Helm in Docker"
LABEL org.opencontainers.image.authors="Emmanuel Frécon <efrecon+github@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images/helm"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/helm/README.md"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/helm/Dockerfile"

COPY bininstall/*.sh /usr/local/bin/

# Install kubectl
RUN if [ "$HELM_VERSION" = "latest" ]; then HELM_VERSION=$(wget -q  -O - "$HELM_RELROOT"|grep 'href="/helm/helm/releases/tag/v[3-9].[0-9]*.[0-9]*\"' | grep -v no-underline | head -n 1 | cut -d '"' -f 2 | awk '{n=split($NF,a,"/");print a[n]}' | awk 'a !~ $0{print}; {a=$0}'); fi \
    && tarinstall.sh -v -x linux-amd64/helm "${HELM_DWROOT%/}/helm-v${HELM_VERSION#v*}-linux-amd64.tar.gz"

ENTRYPOINT [ "/usr/local/bin/helm" ]
CMD [ "--help" ]
