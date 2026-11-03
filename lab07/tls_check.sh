#!/bin/bash

CONF=$1

if [ ! -f "$CONF" ]; then
    echo "Error: file not found: $CONF"
    exit 1
fi

TLS=$(grep -i '^tls=' "$CONF" | cut -d'=' -f2)
TLS="${TLS,,}"

if [ "$TLS" = "true" ] || [ "$TLS" = "yes" ]; then
    echo "$CONF: TLS is enabled"
elif [ "$TLS" = "false" ] || [ "$TLS" = "no" ]; then
    echo "$CONF: WARNING - TLS is disabled"
else
    echo "$CONF: TLS setting is missing or unrecognised"
fi
