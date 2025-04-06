if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# if [[ "$(tty)" == "/dev/tty1" && -z "$DISPLAY" ]]; then
#     startx
# fi

# Created by `pipx` on 2025-04-03 13:27:31
export PATH="$PATH:/home/mjm/.local/bin"
. "$HOME/.cargo/env"
