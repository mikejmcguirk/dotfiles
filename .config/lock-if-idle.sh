#!/bin/bash

# If using default Mint greeter
# if pgrep -x "slick-greeter" > /dev/null; then
#     exit 0
# fi

if ! playerctl status 2>/dev/null | grep -q "Playing"; then
    # dm-tool lock
    betterlockscreen --lock dim --display 1
fi
