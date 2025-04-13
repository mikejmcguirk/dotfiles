#!/bin/bash

CURRENT_VOL=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]\+%' | head -1 | tr -d '%')

if [ "$CURRENT_VOL" -lt 150 ]; then
    NEW_VOL=$((CURRENT_VOL + 5))
    if [ "$NEW_VOL" -gt 150 ]; then
        NEW_VOL=150
    fi

    pactl set-sink-volume @DEFAULT_SINK@ ${NEW_VOL}%
fi
