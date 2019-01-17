ARG SRCTAG=alpine
FROM rabbitmq:${SRCTAG}

RUN apk add --no-cache bash

COPY healthcheck.sh /usr/local/bin/

HEALTHCHECK CMD ["healthcheck.sh"]