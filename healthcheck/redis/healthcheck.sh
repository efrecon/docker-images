#!/bin/sh

set -e

hostnames="$(hostname -i || echo '127.0.0.1')"
host=$(echo "${hostnames}"|cut -f1 -d" ")

if ping="$(redis-cli -h "$host" ping)" && [ "$ping" = 'PONG' ]; then
	echo "Alive"
	exit 0
fi

echo "Dead"
exit 1
