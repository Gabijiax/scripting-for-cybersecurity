#!/bin/bash

SURVEYED=0
FLAGGED=0
IOC_TOTAL=0

for FILE in case/evidence/* case/scripts/* case/logs/*; do
    [ -f "$FILE" ] || continue
    SURVEYED=$((SURVEYED + 1))

    SIZE=$(wc -c < "$FILE")
    TYPE=$(file -b "$FILE")
    echo "File: $FILE"
    echo "  Size: $SIZE bytes"
    echo "  Type: $TYPE"

    if [[ "$TYPE" == *text* ]]; then
        echo "  Lines: $(wc -l < "$FILE")"
    fi

    echo "  SHA-256: $(sha256sum "$FILE" | awk '{print $1}')"

    EXPECT=""
    if   [[ "$FILE" == *.png ]]; then EXPECT="PNG"
    elif [[ "$FILE" == *.zip ]]; then EXPECT="Zip"
    elif [[ "$FILE" == *.txt || "$FILE" == *.md ]]; then EXPECT="text"
    elif [[ "$FILE" == *.sh ]]; then EXPECT="shell script"
    elif [[ "$FILE" == *.py ]]; then EXPECT="Python"
    elif [[ "$FILE" == *.bin ]]; then EXPECT="empty"
    fi

    if [ -n "$EXPECT" ] && [[ "$TYPE" != *"$EXPECT"* ]]; then
        echo "  !! extension and type disagree (expected $EXPECT)"
        FLAGGED=$((FLAGGED + 1))
    fi

    if [[ "$FILE" == *.log ]]; then
        N=0
        for IND in $(cat intel/iocs.txt); do
            if grep -qwF "$IND" "$FILE"; then
                N=$((N + 1))
            fi
        done
        echo "  Distinct IOCs present: $N"
        IOC_TOTAL=$((IOC_TOTAL + N))
    fi
    echo
done

echo "Files surveyed: $SURVEYED"
echo "Files flagged: $FLAGGED"
echo "Total IOC matches: $IOC_TOTAL"
