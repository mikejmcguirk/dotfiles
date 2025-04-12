if ! playerctl status 2>/dev/null | grep -q "Playing"; then
    dm-tool lock
fi
