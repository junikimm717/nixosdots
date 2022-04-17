#!/usr/bin/env bash

QUIT=$(printf "No\nYes" | dmenu -i -p "Are you sure u want to kill bspwm?")

if test "$QUIT" == "Yes" ; then
    pkill bspwm
fi
