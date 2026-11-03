#!/bin/bash

if [ ! -f "$1" ]; then
    echo "Error: file not found" >&2
    exit 1
fi

echo "File found successfully"
exit 0