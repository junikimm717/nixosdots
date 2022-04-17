#!/usr/bin/env bash

# Terminate already running bar instances
pkill polybar

# Wait until the processes have been shut down
while pgrep -u "$(id -u)" -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config

newver() {
    polybar main & sleep 0.5
    polybar pulse &
    polybar backlight &
    polybar bspwm &
    polybar battery &
    polybar wlan &
}

newver

echo "Polybar launched..."
