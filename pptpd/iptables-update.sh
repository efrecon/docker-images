#!/bin/sh

for port in "$@"; do
    # Parse the output of iptables, make sure not to resolve back the IPs to
    # host and constrain us to the (destination) port passed on the command
    # line.
    iptables -L -n --line-numbers| grep "ACCEPT" | grep "dpt:$port" | while read line
    do
        # Look for first IP address (the source) in the current set of tables
        # and to which host it corresponds to (from the comment).
        in_tables=$(echo "${line}" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -n 1)
        host=$(echo "${line}" | grep -o '/\* .* \*/$' | grep -o '[a-zA-Z0-9._-]*')
        if [ ! -z "${host}" ]; then
            # If we have a host and it is not an IP number, then we can start comparing
            isip=$(echo "${host}" | grep -E '^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$')
            if [ -z "$isip" ]; then
                current=$(dig +short $host | tail -n 1)
                # We don't do anything when the host seem to have disappear,
                # maybe should we actually remove the rule.
                if [ ! -z "$current" ]; then
                    # Host has changed IP address, update the ip tables.
                    if [ "$current" != "$in_tables" ]; then
                        rulenum=$(echo "${line}" | cut -d" " -f1)
                        iptables -R INPUT $rulenum -i eth0 -s $current -p tcp --dport $port -j ACCEPT -m comment --comment "${host}"
                    fi
                fi
            fi
        fi
    done
done
