#
# Dockerfile for pptpd
#

FROM alpine:3.6
MAINTAINER Emmanuel Frecon <efrecon@gmail.com>

RUN apk add --no-cache iptables ppp pptpd bash bind-tools

COPY pptpd.conf    /etc/
COPY chap-secrets  /etc/ppp/
COPY pptpd-options /etc/ppp/
COPY *.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/*.sh
COPY firewall.conf /etc/

EXPOSE 1723

CMD set -xe \
    && /usr/local/bin/iptables.sh /etc/firewall.conf \
    && (/usr/local/bin/loop.sh -s 60 /usr/local/bin/iptables-update.sh 1723 &) \
    && pptpd \
    && syslogd -n -O /dev/stdout