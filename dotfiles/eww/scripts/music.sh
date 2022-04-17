#!/bin/bash

case "$1" in
  [Ss]tatus) 
    OT="$(mpc status -f "%file%" | head -n 1)"
    if echo "$OT" | grep "volume:" > /dev/null ; then
      echo "MPD Inactive";
    else
      echo "$OT";
    fi
  ;;
  [Pp]aused)
    OT="$(mpc status 2> /dev/null)"
    if echo "$OT" | head -n 1 | grep "volume:" > /dev/null; then
      echo "⏹"
      exit;
    fi
    if echo "$OT" | grep "paused" > /dev/null; then
      echo "⏵"
    else
      echo "⏸"
    fi
  ;;
  *)
    echo "No arg exists for $1";
  ;;
esac

