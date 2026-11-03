#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <logfile> <IP_or_username>" >&2
    exit 1
fi

LOGFILE=$1
TERM_ARG=$2

if [ ! -e "$LOGFILE" ]; then
    echo "Error: log does not exist" >&2
    exit 2
fi

if [ ! -f "$LOGFILE" ]; then
    echo "Error: log is not a regular file" >&2
    exit 3
fi

if [ ! -r "$LOGFILE" ]; then
    echo "Error: log is not readable" >&2
    exit 4
fi

if [ ! -s "$LOGFILE" ]; then
    echo "Error: log is empty" >&2
    exit 5
fi

if [ -z "$TERM_ARG" ]; then
    echo "Error: search term is empty" >&2
    exit 5
fi

echo "Investigation: $TERM_ARG"
echo "Log file: $LOGFILE"

if echo "$TERM_ARG" | grep -Eq '^[0-9]+(\.[0-9]+){3}$'; then
    COUNT=$(grep -cwF "$TERM_ARG" "$LOGFILE")
    FAILS=$(grep -wF "$TERM_ARG" "$LOGFILE" | grep -c "Failed password")

    echo "IP occurrences: $COUNT"
    echo "Failed login attempts: $FAILS"

    if [ "$FAILS" -ge 8 ]; then
        echo "Risk level: HIGH"
    elif [ "$FAILS" -ge 5 ]; then
        echo "Risk level: MEDIUM"
    else
        echo "Risk level: LOW"
    fi

    if grep -qwF "$TERM_ARG" case/logs/firewall.log; then
        echo "Firewall: IP found"
        grep -wF "$TERM_ARG" case/logs/firewall.log
    else
        echo "Firewall: IP not found"
    fi

    if grep -qxF "$TERM_ARG" intel/iocs.txt; then
        echo "IOC list: IP found"
    else
        echo "IOC list: IP not found"
    fi

else
    FAILS=$(grep -cF "Failed password for $TERM_ARG " "$LOGFILE")
    ACCEPTS=$(grep -cF "Accepted password for $TERM_ARG " "$LOGFILE")

    echo "Failed logins: $FAILS"
    echo "Accepted logins: $ACCEPTS"

    STATUS=$(awk -F, -v user="$TERM_ARG" '$1 == user {print $3; found=1} END {if (!found) exit 1}' intel/users.csv)

    if [ $? -eq 0 ]; then
        echo "Account status: $STATUS"
    else
        echo "Account status: UNKNOWN (not in users.csv)"
    fi

    if [ "$FAILS" -ge 8 ]; then
        echo "Risk level: HIGH"
    elif [ "$FAILS" -ge 5 ]; then
        echo "Risk level: MEDIUM"
    elif [ "$FAILS" -gt 0 ]; then
        echo "Risk level: LOW"
    else
        echo "Risk level: NO FAILED LOGINS"
    fi
fi

exit 0
