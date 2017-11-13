#!/bin/bash

if [ "$#" -eq 0 ]; then
    iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
else
    restricted=0
    for fname in "$@"; do
        if [ -r "$fname" ]; then
            while read host
            do
                iptables -A INPUT -i eth0 -s ${host} -p tcp --dport 1723 -j ACCEPT -m comment --comment "${host}"
                restricted=1
            done < <(sed '/^[[:space:]]*$/d' $fname | sed '/^[[:space:]]*#/d')
        fi
    done
    
    # Restrict to anybody else unless no incoming host was really added.
    if [ "$restricted" == "1" ]; then
        iptables -A INPUT -i eth0 -p tcp --dport 1723 -j REJECT
    else
        iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
    fi
fi

# See https://globalcynic.wordpress.com/2013/04/26/pptpd-ubuntu-12-04-vps-fail2ban/
iptables -A INPUT -i eth0 -p gre -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i ppp+ -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o ppp+ -j ACCEPT
# Allow communication between the clients.
iptables --table nat --append POSTROUTING   --out-interface ppp+ --jump MASQUERADE
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
