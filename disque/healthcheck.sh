#!/bin/sh

set -eo pipefail

hostnames="$(hostname -i || echo '127.0.0.1')"
host=$(echo "${hostnames}"|cut -f0 -d" ")

if ping="$(disque -h "$host" ping)" && [ "$ping" = 'PONG' ]; then
	echo "Alive"
	exit 0
fi

echo "Dead"
exit 1