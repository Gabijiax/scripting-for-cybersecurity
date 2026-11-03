#!/bin/bash

for FILE in case/scripts/*; do
    [ -f "$FILE" ] || continue
    TYPE=$(file -b "$FILE")
    if [[ "$FILE" == *.sh ]]; then EXPECT="shell script"
    elif [[ "$FILE" == *.py ]]; then EXPECT="Python"
    else EXPECT=""; fi

    if [ -z "$EXPECT" ]; then echo "?? $FILE — $TYPE"
    elif [[ "$TYPE" == *"$EXPECT"* ]]; then echo "OK $FILE — $TYPE"
    else echo "!! $FILE — expected $EXPECT, detected: $TYPE"
    fi
done
