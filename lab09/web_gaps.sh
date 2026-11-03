#!/bin/bash

for IP in $(awk '{print $1}' case/logs/access.log | sort -u); do
    COUNT=$(grep -c "^$IP " case/logs/access.log)

    case "$IP" in
        10.*|192.168.*|172.1[6-9].*|172.2[0-9].*|172.3[0-1].*) WHERE="internal" ;;
        *) WHERE="EXTERNAL" ;;
    esac

    if grep -qxF "$IP" intel/iocs.txt; then
        echo "$IP ($COUNT requests, $WHERE): already in IOC list"
    else
        echo "$IP ($COUNT requests, $WHERE): NOT in IOC list"
    fi
done
