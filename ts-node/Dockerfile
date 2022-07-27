FROM node:16-alpine
ARG TS_NODE_VERSION=10.7.0

RUN \
    npm update -g npm && \
    npm install --location=global typescript && \
    npm install --location=global ts-node@${TS_NODE_VERSION} && \
    npm install --location=global tslib @types/node && \
    ts-node --version

ENTRYPOINT "ts-node"