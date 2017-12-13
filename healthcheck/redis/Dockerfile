ARG SRCTAG=latest
FROM redis:${SRCTAG}

COPY healthcheck.sh /usr/local/bin/
HEALTHCHECK CMD [ "/usr/local/bin/healthcheck.sh" ]
