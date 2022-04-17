#!/bin/bash

X=$(mpc status 2>/dev/null | grep "%)")
if test $? -eq 0; then
  echo "$X" | awk '{ print $4 }' | awk -F% '{ print $1 }' | awk 'sub(/^.{1}/,"")'
else
  echo "0"
fi
