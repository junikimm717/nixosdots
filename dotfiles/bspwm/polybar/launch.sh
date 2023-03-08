#!/bin/sh
if test "$1" = "-r"; then
  RELOAD=1
  echo "Hot reload..."
else
  RELOAD=
fi

pkill polybar

bar() {
  if test -z "$RELOAD"; then
    polybar -c "$HOME/.config/polybar/config.ini" "$@" &
  else
    polybar -r -c "$HOME/.config/polybar/config.ini" -l warning "$@" &
  fi
}

bar top
bar workspaces-role
bar bottom
