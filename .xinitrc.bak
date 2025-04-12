#!/bin/bash

if command -v xset >/dev/null 2>&1 && xset q | grep -q "DPMS is Enabled"; then
    xset +dpms
    xset dpms 1800 0 0
else
    echo "DPMS not supported or disabled" >> ~/.xsession-errors
fi

killall -q xautolock
xautolock -time 15 -locker "betterlockscreen -l dim" -detectsleep &

# Use the default xinitrc to make sure that the session is built properly (including dbus)
. /etc/X11/xinit/xinitrc
