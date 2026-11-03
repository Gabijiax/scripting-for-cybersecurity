#!/bin/bash

LOG="case/logs/auth.log"
USERS="intel/users.csv"

if [ ! -f "$LOG" ] || [ ! -f "$USERS" ]; then
    echo "Error: required files are missing."
    exit 1
fi

echo "ACCOUNT SECURITY AUDIT"
echo "======================"

awk '
/Failed password/ {
    for (i=1; i<=NF; i++) {
        if ($i == "for") {
            if ($(i+1) == "invalid") {
                print $(i+2)
            } else {
                print $(i+1)
            }
            break
        }
    }
}' "$LOG" | sort -u | while read USERNAME
do
    ACCOUNT=$(awk -F',' -v user="$USERNAME" '
    NR > 1 && $1 == user {
        print $3
        found=1
    }
    END {
        if (!found) print "NOT FOUND"
    }' "$USERS")

    if [ "$ACCOUNT" = "NOT FOUND" ]; then
        echo "$USERNAME : Account does not exist"
    elif [ "$ACCOUNT" = "active" ]; then
        echo "$USERNAME : Account exists and is ACTIVE"
    elif [ "$ACCOUNT" = "disabled" ]; then
        echo "$USERNAME : Account exists but is DISABLED"
    else
        echo "$USERNAME : Account exists, status: $ACCOUNT"
    fi
done
