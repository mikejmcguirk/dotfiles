#!/bin/bash
killall xautolock
xautolock -time 15 -locker "$HOME/.config/lock-if-idle.sh" -detectsleep
