#!/bin/bash

# attacker_report.sh - SSH attacker investigation

if [ $# -eq 0 ]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

LOGFILE=$1

if [ ! -f "$LOGFILE" ]; then
    echo "Error: file '$LOGFILE' does not exist" >&2
    exit 2
fi

FAILED_COUNT=$(grep -c "Failed password" "$LOGFILE")

TOP_ATTACKER=$(grep "Failed password" "$LOGFILE" |
    awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' |
    sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')

TOP_THREE=$(grep "Failed password" "$LOGFILE" |
    awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' |
    sort | uniq -c | sort -nr | head -n 3)

TOP_USERS=$(grep "Failed password" "$LOGFILE" |
    awk '{
        for(i=1;i<=NF;i++) {
            if($i=="for") {
                if($(i+1)=="invalid")
                    print $(i+2)
                else
                    print $(i+1)
            }
        }
    }' |
    sort | uniq -c | sort -nr | head -n 3)

echo "SSH ATTACKER REPORT"
echo "==================="
echo "Log file: $LOGFILE"
echo ""
echo "Total failed login attempts: $FAILED_COUNT"
echo ""
echo "Top attacker IP: ${TOP_ATTACKER:-None found}"
echo ""
echo "Three busiest attacker IPs:"
echo "${TOP_THREE:-None found}"
echo ""
echo "Three most targeted usernames:"
echo "${TOP_USERS:-None found}"

exit 0