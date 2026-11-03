#!/bin/bash

FIREWALL="case/logs/firewall.log"

./check_ip.sh "$FIREWALL" "$1" > /dev/null
RESULT=$?
if [ "$FAILS" -gt 5 ]; then
    echo "HIGH RISK: $USERNAME has $FAILS failed and $ACCEPTS accepted login(s)"
elif [ "$FAILS" -gt 0 ]; then
    echo "$USERNAME: $FAILS failed and $ACCEPTS accepted login(s) - investigate"
else
    echo "$USERNAME: $ACCEPTS successful login(s) only"
fi
