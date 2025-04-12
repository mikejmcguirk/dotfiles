#!/bin/sh

screenshots_dir="$HOME/Pictures/screenshots"
[ ! -d "$screenshots_dir" ] && mkdir -p "$screenshots_dir"

output=$screenshots_dir/$(date +%s_%h%d_%H:%M:%S)".png"

menu() {
    echo "" | dmenu -p "How Long?" | xargs -I _ sleep "_"
}

case "$1" in
    "full") maim "$output" || exit ;;
    "select") maim -s "$output" || exit ;;
    "fulltime") menu && maim "$output" || exit ;;
    "selecttime") menu && maim -s "$output" || exit ;;
esac
#
# notify-send "Maim" "Screenshot Taken"
