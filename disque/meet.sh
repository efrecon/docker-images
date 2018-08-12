#!/bin/sh
set -e

HOST=localhost
PORT=
NODES=./nodes.conf
WAIT=2

while getopts "h:p:n:w:" opt; do
    case $opt in
        h)
            HOST="$OPTARG"
            ;;
        p)
            PORT="$OPTARG"
            ;;
        n)
            NODES="$OPTARG"
            ;;
        w)
            WAIT="$OPTARG"
            ;;
        \?)
            set +x
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            set +x
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done
shift $(expr $OPTIND - 1)

# Wait for Disque to be properly started through discovering the existence of
# the nodes configuration file.
while  [ ! -f "$NODES" ]; do
    echo "Waiting for Disque to start..."
    sleep $WAIT
done

# Discover port of locally running disque-server whenever possible and
# necessary.
if [ "$HOST" = "localhost" ] && [ "$PORT" = "" ]; then
    PORT=$(ps -o args|grep disque-server|grep -o -E ':[0-9]+'|cut -c2-)
    if [ -n "$PORT" ]; then
        echo "Discovered port: $PORT"
    fi
fi

# Defaulting to port 7711 for the disque-server whenever none is available.
if [ -z "$PORT" ]; then
    echo "Defaulting to port 7711"
    PORT=7711
fi

# For each remote specification, attempt to meet the cluster. Default to port
# 7711 whenver the port at the remote destination isn't specified.
for REMOTE in "$@"; do
    RHOST=$(echo "$REMOTE"|cut -d : -f 1)
    RPORT=$(echo "$REMOTE"|cut -d : -f 2 -s)
    if [ "$RPORT" = "" ]; then
        RPORT=7711
    fi
    echo "Joining Disque remote at ${RHOST}:${RPORT}"
    disque -p $PORT -h $HOST cluster meet "$RHOST" "$RPORT"
done

