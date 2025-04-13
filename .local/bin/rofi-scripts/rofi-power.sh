#!/bin/sh

choice=$(printf "Restart\nPower Off" | rofi -dmenu -i)

case "$choice" in
    "Restart") reboot ;;
    "Power Off") poweroff ;;
    *) exit 0 ;;
esac
