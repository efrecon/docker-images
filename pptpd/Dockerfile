#
# Dockerfile for pptpd
#

FROM alpine:3.6
MAINTAINER Emmanuel Frecon <efrecon@gmail.com>

RUN apk add --no-cache iptables ppp pptpd bash

COPY pptpd.conf    /etc/
COPY chap-secrets  /etc/ppp/
COPY pptpd-options /etc/ppp/
COPY iptables.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/iptables.sh
COPY firewall.conf /etc/

EXPOSE 1723

CMD set -xe \
    && /usr/local/bin/iptables.sh /etc/firewall.conf \
    && pptpd \
    && syslogd -n -O /dev/stdout