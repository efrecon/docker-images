#!/bin/sh -e

# Initialise all STUNNEL_ environment variables to good defaults. STUNNEL_LOG
# can also be given, in which case it should point to the path of a log file.
# The default is to keep it empty to rely on Docker logging and keep the
# container volume to grow on disk.
export STUNNEL_CONF="/etc/stunnel/stunnel.conf"
export STUNNEL_DEBUG="${STUNNEL_DEBUG:-7}"
export STUNNEL_CLIENT="${STUNNEL_CLIENT:-no}"
export STUNNEL_CAFILE="${STUNNEL_CAFILE:-/etc/ssl/certs/ca-certificates.crt}"
export STUNNEL_KEY="${STUNNEL_KEY:-/etc/stunnel/stunnel.key}"
export STUNNEL_CRT="${STUNNEL_CRT:-/etc/stunnel/stunnel.pem}"
export STUNNEL_PSK="${STUNNEL_PSK:-}"
#export STUNNEL_LOG

if [[ -z "${STUNNEL_SERVICE}" ]] || [[ -z "${STUNNEL_ACCEPT}" ]] || [[ -z "${STUNNEL_CONNECT}" ]]; then
    echo >&2 "one or more STUNNEL_SERVICE* values missing: "
    echo >&2 "  STUNNEL_SERVICE=${STUNNEL_SERVICE}"
    echo >&2 "  STUNNEL_ACCEPT=${STUNNEL_ACCEPT}"
    echo >&2 "  STUNNEL_CONNECT=${STUNNEL_CONNECT}"
    exit 1
fi

env

if [[ ! -z "${STUNNEL_PSK}" ]] && [[ -f ${STUNNEL_PSK} ]]; then
    if [[ ! -s ${STUNNEL_CONF} ]]; then
        if [[ -z "${STUNNEL_LOG}" ]]; then
            cat /srv/stunnel/stunnel-psk.conf.template | envsubst | sed "s/^output\\s*=.*/;&/g" > ${STUNNEL_CONF}
        else
            cat /srv/stunnel/stunnel-psk.conf.template | envsubst > ${STUNNEL_CONF}
        fi
    fi
else
    if [[ ! -f ${STUNNEL_KEY} ]]; then
        if [[ -f ${STUNNEL_CRT} ]]; then
            echo >&2 "crt (${STUNNEL_CRT}) missing key (${STUNNEL_KEY})"
            exit 1
        fi
    
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${STUNNEL_KEY} -out ${STUNNEL_CRT} \
            -config /srv/stunnel/openssl.cnf 
    fi
    
    cp -v ${STUNNEL_CAFILE} /usr/local/share/ca-certificates/stunnel-ca.crt
    cp -v ${STUNNEL_CRT} /usr/local/share/ca-certificates/stunnel.crt
    update-ca-certificates

    if [[ ! -s ${STUNNEL_CONF} ]]; then
        if [[ -z "${STUNNEL_LOG}" ]]; then
            cat /srv/stunnel/stunnel.conf.template | envsubst | sed "s/^output\\s*=.*/;&/g" > ${STUNNEL_CONF}
        else
            cat /srv/stunnel/stunnel.conf.template | envsubst > ${STUNNEL_CONF}
        fi
    fi
fi

exec "$@"
