FROM alpine:3.13.5

# stable will be automatically be replaced with the latest stable version.
# Otherwise, this should be a version, with or without leading v.
ARG K8S_VERSION=stable
ARG K8S_DWROOT=https://storage.googleapis.com/kubernetes-release/release

# latest is the default, otherwise this should be the version of krew with the
# leading v.
ARG KREW_VERSION=latest
ARG KREW_DWROOT=https://github.com/kubernetes-sigs/krew/releases
ARG KREW_PLUGINS="ctx deprecations evict-pod exec-cronjob exec-as images node-restart node-shell prune-unused unused-volumes"

# Arrange for krew plugins to be installed at /usr/local/krew and accessible
# from the PATH so kubectl can find them at run-time
ENV KREW_ROOT=/usr/local/krew
ENV PATH="$KREW_ROOT/bin:$PATH"

# Metadata
LABEL MAINTAINER efrecon+github@gmail.com
LABEL org.opencontainers.image.title="kubectl"
LABEL org.opencontainers.image.description="kubectl in a box"
LABEL org.opencontainers.image.authors="Emmanuel Frécon <efrecon+github@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/efrecon/docker-images/kubectl"
LABEL org.opencontainers.image.documentation="https://github.com/efrecon/docker-images/kubectl/README.md"
LABEL org.opencontainers.image.source="https://github.com/efrecon/docker-images/kubectl/Dockerfile"

# Install kubectl
RUN apk --no-cache add curl \
    && if [ "$K8S_VERSION" = "stable" ]; then K8S_VERSION=$(curl -s "${K8S_DWROOT%/}/stable.txt"); fi \
    && curl -fsSLO "${K8S_DWROOT%/}/v${K8S_VERSION#v*}/bin/linux/amd64/kubectl" \
    && chmod a+x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# Install krew and a number of plugins
RUN apk --no-cache add git \
    && mkdir /tmp/krew \
    && curl -fsSL -o /tmp/krew/krew.tar.gz "${KREW_DWROOT%/}/${KREW_VERSION}/download/krew.tar.gz" \
    && tar -C /tmp/krew -zxvf /tmp/krew/krew.tar.gz \
    && mv /tmp/krew/krew-linux_amd64 /usr/local/bin/kubectl-krew \
    && rm -rf /tmp/krew \
    && mkdir -p "${KREW_ROOT}" \
    && kubectl krew install ${KREW_PLUGINS}

ENTRYPOINT [ "/usr/local/bin/kubectl" ]
CMD [ "help" ]
