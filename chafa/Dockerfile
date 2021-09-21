ARG CHAFA_VERSION=1.8.0

FROM ubuntu:20.04 AS build

ARG GHPROJ=hpjansson/chafa
ARG CHAFA_VERSION

RUN apt-get -y update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq xz-utils curl automake make libtool libglib2.0-dev libmagickwand-dev \
  && curl -sSL "https://github.com/${GHPROJ}/releases/download/${CHAFA_VERSION}/chafa-${CHAFA_VERSION}.tar.xz" > /tmp/chafa-${CHAFA_VERSION}.tar.xz \
  && xzcat /tmp/chafa-${CHAFA_VERSION}.tar.xz | tar -C /tmp -xvf - \
  && cd /tmp/chafa-${CHAFA_VERSION} \
  && mkdir /tmp/usr && mkdir build && cd build && ../autogen.sh --prefix=/usr/local --disable-dependency-tracking && make -j4 && make install
#  && rm -rf /tmp/chafa-${CHAFA_VERSION}*

FROM ubuntu:20.04

ARG CHAFA_VERSION

RUN apt-get -y update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq libglib2.0 libmagickwand-6.q16

COPY --from=build /usr/local /usr/local
ENV LD_LIBRARY_PATH=/usr/local/lib
RUN ldconfig

ENTRYPOINT [ "chafa" ]
CMD [ "--help" ]