#!/bin/sh

set -e

host="$(hostname -i || echo '127.0.0.1')"
user="${POSTGRES_USER:-postgres}"
db="${POSTGRES_DB:-$POSTGRES_USER}"
# Capture password from file if _FILE env. variable is set.
if [ -n "${POSTGRES_PASSWORD_FILE}" ]; then
	export POSTGRES_PASSWORD=$(cat "${POSTGRES_PASSWORD_FILE}")
fi
export PGPASSWORD="${POSTGRES_PASSWORD:-}"

if select="$(echo 'SELECT 1' | psql --host "$host" --username "$user" --dbname "$db" --quiet --no-align --tuples-only)" && [ "$select" = '1' ]; then
	echo "Alive"
	exit 0
fi

echo "Dead"
exit 1