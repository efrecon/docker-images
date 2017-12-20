ARG SRCTAG=latest
FROM postgres:${SRCTAG}

COPY healthcheck.sh /usr/local/bin/
HEALTHCHECK CMD [ "/usr/local/bin/healthcheck.sh" ]
