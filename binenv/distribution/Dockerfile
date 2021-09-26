# Version of the binenv image to use
ARG BINENV_VERSION=0.13.0

# Name and version of the tool, a.k.a distribution, that we will be installing
# in the final image.
ARG DISTRO_NAME=binenv
ARG DISTRO_VERSION=latest

FROM ghcr.io/efrecon/binenv:v${BINENV_VERSION} AS binenv

ARG DISTRO_NAME
ARG DISTRO_VERSION

# Copy our binenv wrapper script and install the tool at the version requested.
COPY *.sh /usr/local/bin/
RUN /usr/local/bin/binenv.sh -v install "${DISTRO_NAME}" "${DISTRO_VERSION}"

# Start again from almost scratch. We need busybox in order to be able to create
# a symbolic link as part of the image's instructions.
FROM busybox

ARG DISTRO_NAME
ARG DISTRO_VERSION

# Copy the binary installed in the prior stage to /usr/local/bin
COPY --from=binenv /root/.binenv/binaries/${DISTRO_NAME}/${DISTRO_VERSION} /usr/local/bin/${DISTRO_NAME}

# Make the distribution the entrypoint using a decided-upon name as it is not
# possible to use a Docker build argument inside the ENTRYPOINT vector.
RUN cd /usr/local/bin \
  && ln -s "${DISTRO_NAME}" shim \
  && chmod a+x "${DISTRO_NAME}"
ENTRYPOINT [ "/usr/local/bin/shim" ]