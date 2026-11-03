#!/bin/bash

read -p "Enter risk level (1-10): " RISK

if ! [[ "$RISK" =~ ^[0-9]+$ ]]; then
    echo "Please enter a number."
elif [ "$RISK" -lt 1 ] || [ "$RISK" -gt 10 ]; then
    echo "Risk level must be between 1 and 10."
elif [ "$RISK" -ge 8 ]; then
    echo "HIGH RISK"
elif [ "$RISK" -ge 5 ]; then
    echo "MEDIUM RISK"
else
    echo "LOW RISK"
fi
