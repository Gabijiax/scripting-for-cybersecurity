#!/bin/bash

read -p "Enter a username to look up: " TARGET_USER
read -p "Enter a department: " DEPT

MATCH=$(grep -i "^$TARGET_USER," intel/users.csv | grep -i "$DEPT")

echo "$MATCH"
echo "Role   : $(echo "$MATCH" | cut -d',' -f2)"
echo "Status : $(echo "$MATCH" | cut -d',' -f3)"
