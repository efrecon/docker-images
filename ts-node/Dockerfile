FROM node:16-alpine
ARG TS_NODE_VERSION=10.7.0

RUN \
    npm update -g npm && \
    npm install -g typescript && \
    npm install -g ts-node@${TS_NODE_VERSION} && \
    npm install -g tslib @types/node && \
    ts-node --version

ENTRYPOINT "ts-node"