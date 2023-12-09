# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -lhA --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

tmux_reload_bashrc() {
    if command -v tmux &> /dev/null; then
        for i in $(tmux list-windows -F "#{window_id}"); do
            tmux send-keys -t "$i" "source ~/.bashrc" Enter
        done
    else
        echo "tmux is not installed. Please install tmux to use this feature."
    fi
}

alias tmux-reload-bashrc="tmux_reload_bashrc"

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
. "$HOME/.cargo/env"

shopt -s dotglob

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm alias default lts/*

export PATH=$PATH:/home/mjm/.local/bin

export DisableCopilot="false"
export NvimTheme="delta"
export NvimCopilotNode="$HOME/.nvm/versions/node/v18.18.0/bin/node"
export OmniSharpDLL="$HOME/.local/bin/omnisharp/OmniSharp.dll"

export DOTNET_CLI_TELEMETRY_OPTOUT=1 # Bad, Microsoft

alias config='git --git-dir=/home/mjm/.cfg/ --work-tree=/home/mjm'

export EDITOR=nvim
export ESLINT_USE_FLAT_CONFIG= #As of 11/25/2023, just not ready

for_creating_all() {
    cp ~/default_programming_files/.gitignore .
    cp ~/default_programming_files/.markdownlint.jsonc .
    git init
    git add .
}

for_creating_all_nogit() {
    cp ~/default_programming_files/.markdownlint.jsonc .
}

for_javascript() {
    cp ~/default_programming_files/.prettierrc.json .
    cp ~/default_programming_files/.eslintrc.json .
    cp ~/default_programming_files/package.json .

    npm install --save-dev eslint-config-prettier
    # Future proofing for flat config
    npm install globals
    npm install @eslint/js
}

create_html_css_js() {
    cp ~/default_programming_files/index.html .
    cp ~/default_programming_files/style.css .
    cp ~/default_programming_files/script.js .

    for_javascript_all
    for_creating_all
}

alias create-html-css-js="create_html_css_js"

create_cs() {
    cp ~/default_programming_files/.csproj .
    cp ~/default_programming_files/Program.cs .
    cp ~/default_programming_files/omnisharp.json .

    for_creating_all
}

alias create-cs="create_cs"

create_cs_nogit() {
    cp ~/default_programming_files/.csproj .
    cp ~/default_programming_files/Program.cs .
    cp ~/default_programming_files/omnisharp.json .

    for_creating_all_nogit
}

alias create-cs-nogit="create_cs_nogit"

create_js_nogit() {
    cp ~/default_programming_files/index.js .

    for_javascript
    for_creating_all_nogit
}

alias create-js-nogit="create_js_nogit"
