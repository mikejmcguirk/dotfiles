#!/usr/bin/bash

polybar-msg cmd quit

# Or killall -q polybar
# The -q option suppresses errors

polybar main &

if xrandr -q | grep -q 'DVI-D-0 connected'; then
    polybar --reload secondary &
fi
