#!/bin/bash

# Probably use this, since dpms can put the monitor into like, the mode where it's blank
# But not in the deep de-powered mode that takes forever. Or maybe that's fine iunno
# Point is I can't test this on a vm
# xset +dpms
# xset dpms 0 0 120

# xset s blank
# xset s 2
# xset -dpms

xautolock -time 15 -locker "betterlockscreen -l dim" &

. /etc/X11/xinit/xinitrc
