#!/bin/sh

set -eo pipefail

host="$(hostname -i || echo '127.0.0.1')"
user="${POSTGRES_USER:-postgres}"
db="${POSTGRES_DB:-$POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD:-}"

if select="$(echo 'SELECT 1' | psql --host "$host" --username "$user" --dbname "$db" --quiet --no-align --tuples-only)" && [ "$select" = '1' ]; then
	echo "ALive"
	exit 0
fi

echo "Dead"
exit 1