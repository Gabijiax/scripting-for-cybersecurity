#!/bin/bash

read -p "Enter a username to look up: " TARGET_USER
read -p "Enter a department: " DEPT

echo "Searching for $TARGET_USER in $DEPT"
grep "$TARGET_USER" intel/users.csv | grep "$DEPT"
