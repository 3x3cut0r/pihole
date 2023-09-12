#!/bin/bash

while true; do
    if [ -f /etc/pihole/domains-keepalive.txt ]; 
    then
         # add custom domains from keepalive.txt
        cat /etc/pihole/domains-keepalive.txt > /etc/pihole/domains.txt
    else
        # clean up domains.txt
        > /etc/pihole/domains.txt
    fi

    # add the 100 top permitted domains from pihole
    sqlite3 "/etc/pihole/pihole-FTL.db" "SELECT domain,count(domain) FROM queries WHERE (STATUS == 2 OR STATUS == 3) GROUP BY domain ORDER BY count(domain) DESC LIMIT 100" | cut -d "|" -f 1 > /etc/pihole/domains-top100.txt
    cat /etc/pihole/domains-top100.txt >> /etc/pihole/domains.txt
    
    # get current cache-min-ttl from unbound
    CACHE_MIN_TTL=$(grep "cache-min-ttl" /etc/unbound/unbound.conf.d/pi-hole.conf | awk '{print $2}')
    TOTAL_PAUSE=$((CACHE_MIN_TTL / 2))
    
    # request all domains in the domains.txt to renew ttl from unbound
    for domain in $(cat /etc/pihole/domains.txt); do
       # request to unbound directly -> does not falsify the top permitted domain list
       dig @127.0.0.1 -p 5335 $domain | grep -A 1 ";; ANSWER SECTION:" | tail -n 1
       sleep 1 # sleep 1 to not ratelimit root dns server
    done

    # pause for some time
    sleep $TOTAL_PAUSE
done
