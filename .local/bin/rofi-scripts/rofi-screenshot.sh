#!/bin/sh

c1="01. Save Segment"
c2="02. Save and Copy Segment"
c3="03. Copy Segment"
c4="04. Save i3 Workspace"
c5="05. Save and Copy i3 Workspace"
c6="06. Copy i3 Workspace"
c7="07. Save Full Screen"

choice=$(printf "%s\n%s\n%s\n%s\n%s\n%s\n%s" "$c1" "$c2" "$c3" "$c4" "$c5" "$c6" "$c7" | rofi -dmenu -i)

screenshots_dir="$HOME/Pictures/screenshots"
[ ! -d "$screenshots_dir" ] && mkdir -p "$screenshots_dir"
output="$screenshots_dir/$(date +%s_%h%d_%H:%M:%S).png"

get_workspace_geometry() {
    geometry=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
    x=$(echo $geometry | cut -d',' -f1)
    y=$(echo $geometry | cut -d' ' -f1 | cut -d',' -f2)
    width_height=$(echo $geometry | cut -d' ' -f2)
    width=$(echo $width_height | cut -d'x' -f1)
    height=$(echo $width_height | cut -d'x' -f2)
    echo "${width}x${height}+${x}+${y}"
}

case "$choice" in
    "$c1") maim -u -s "$output" || exit 1 ;;
    "$c2") maim -u -s "$output" && xclip -selection clipboard -t image/png -i "$output" || exit 1 ;;
    "$c3") maim -u -s | xclip -selection clipboard -t image/png || exit 1 ;;
    "$c4") maim -u -g "$(get_workspace_geometry)" "$output" || exit 1 ;;
    "$c5") maim -u -g "$(get_workspace_geometry)" "$output" && xclip -selection clipboard -t image/png -i "$output" || exit 1 ;;
    "$c6") maim -u -g "$(get_workspace_geometry)" | xclip -selection clipboard -t image/png || exit 1 ;;
    "$c7") maim -u "$output" || exit 1 ;;
    *) exit 0 ;;
esac

# notify-send "Maim" "Screenshot Taken"
