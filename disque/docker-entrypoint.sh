#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
	set -- disque-server "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'disque-server' -a "$(id -u)" = '0' ]; then
	chown -R disque .

    # Meet
    if [ -n "$(env|grep -E '^DISQUE_MEET')" ]; then
        echo "Arranging to join to cluster through $DISQUE_MEET"
        su-exec disque meet.sh "$DISQUE_MEET" &
    fi
    
    # First arg is not a configuration file and we have environment variables
    # starting with DISQUE_. Arrange to use a configuration file and to replace
    # configuration variables in that file using the values from the environment
    # variables (sans the leading DISQUE_ and in lower case, all underscores
    # become dash).
    DENV=$(env | grep -E '^DISQUE_' | grep -v 'MEET' | wc -l)
    if [ "${2%.conf}" = "$2" ] && [ "$DENV" -gt 0 ]; then
        cp /usr/local/share/disque.conf ./disque.conf
        for VAR in $(env); do
            if [ -n "$(echo $VAR | grep -E '^DISQUE_' | grep -v 'MEET')" ]; then
                # Transform environment variable (starting with DISQUE_) into a
                # variable that might occur in the configuration file. This
                # remove the leading DISQUE_, change to lowercase and replace
                # all underscores by single dash.
                VAR_NAME=$(echo "$VAR" | sed -r "s/DISQUE_([^=]*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr '_' '-' )
                # Keep a record of the name of the real environment variable,
                # including the leading DISQUE_
                VAR_FULL_NAME=$(echo "$VAR" | sed -r "s/([^=]*)=.*/\1/g")
                if [ -n "$(cat ./disque.conf |grep -E "^(^|^#*)$VAR_NAME")" ]; then
                    echo "Configuring '$VAR_NAME' from env: $(eval echo \$$VAR_FULL_NAME)"
                    sed -ri "s/(^#*)($VAR_NAME)\s+(.*)/\2 $(eval echo \$$VAR_FULL_NAME|sed -e 's/\//\\\//g')/g" ./disque.conf
                    sed -ri "s/(^#*)($VAR_NAME)\s*$/$VAR_NAME $(eval echo \$$VAR_FULL_NAME|sed -e 's/\//\\\//g')/g" ./disque.conf
                    # Remove the variable, this provides *some* sort of privacy
                    # through keeping away possible secrets to leak at runtime
                    # (they will still be in the configuration file though...
                    # but this requires access to the container's disk
                    # hierarchy).
                    unset $VAR_FULL_NAME
                fi
            fi
        done

        chown -R disque ./disque.conf
        # Shift away disque-server to be able to prepend current configuration
        # file to list of (otherwise arguments)
        shift
        exec su-exec disque disque-server ./disque.conf "$@"
    else
        exec su-exec disque "$0" "$@"
    fi
fi

exec "$@"
