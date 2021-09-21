ARG UBUNTU_VERSION=20.04
ARG CHAFA_VERSION=1.8.0

# First stage: fetch the official released source code, compile it and install
# it into /usr/local
FROM ubuntu:${UBUNTU_VERSION} AS build

ARG GHPROJ=hpjansson/chafa
ARG CHAFA_VERSION

RUN apt-get -y update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq xz-utils curl automake make libtool libglib2.0-dev libmagickwand-dev \
  && curl -sSL "https://github.com/${GHPROJ}/releases/download/${CHAFA_VERSION}/chafa-${CHAFA_VERSION}.tar.xz" > /tmp/chafa-${CHAFA_VERSION}.tar.xz \
  && xzcat /tmp/chafa-${CHAFA_VERSION}.tar.xz | tar -C /tmp -xvf - \
  && cd /tmp/chafa-${CHAFA_VERSION} \
  && mkdir build \
  && cd build \
  && ../autogen.sh --prefix=/usr/local --disable-dependency-tracking \
  && make -j4 \
  && make install


# Second stage: install non-dev dependencies, copy the installation binaries and
# libraries from previous stage and fix OS dynlib cache.
FROM ubuntu:${UBUNTU_VERSION}

RUN apt-get -y update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq libglib2.0 libmagickwand-6.q16

COPY --from=build /usr/local /usr/local
ENV LD_LIBRARY_PATH=/usr/local/lib
RUN ldconfig

ENTRYPOINT [ "chafa" ]
CMD [ "--help" ]