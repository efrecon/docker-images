# Version of the binenv image to use
ARG BINENV_VERSION=0.12.0

# Name and version of the tool that we will be installing in the final image.
ARG DISTRO_NAME=binenv
ARG DISTRO_VERSION=latest

FROM ghcr.io/efrecon/binenv:v${BINENV_VERSION} AS binenv

ARG DISTRO_NAME
ARG DISTRO_VERSION

COPY *.sh /usr/local/bin/
RUN /usr/local/bin/binenv.sh install "${DISTRO_NAME}" "${DISTRO_VERSION}"

FROM busybox

ARG DISTRO_NAME
ARG DISTRO_VERSION

COPY --from=binenv /root/.binenv/binaries/${DISTRO_NAME}/${DISTRO_VERSION} /usr/local/bin/${DISTRO_NAME}

# Make the distribution the entrypoint using a decided-upon name as it is not
# possible to use a build argument inside the ENTRYPOINT vector.
RUN cd /usr/local/bin && ln -s "${DISTRO_NAME}" shim
ENTRYPOINT [ "/usr/local/bin/shim" ]