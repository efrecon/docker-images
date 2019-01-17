ARG SRCTAG=latest
FROM rabbitmq:${SRCTAG}

COPY healthcheck.sh /usr/local/bin/

HEALTHCHECK CMD ["healthcheck.sh"]