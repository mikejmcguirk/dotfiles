#!/bin/bash

nvim_url="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
nvim_fresh_install=false
nvim_update=false

lua_ls_url="https://github.com/LuaLS/lua-language-server/releases/download/3.7.0/lua-language-server-3.7.0-linux-x64.tar.gz"
lua_ls_file="lua-language-server-3.7.0-linux-x64.tar.gz"
lua_ls_fresh_install=false
lua_ls_update=false

omnisharp_url="https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v1.39.8/omnisharp-linux-x64-net6.0.tar.gz"
omnisharp_file="omnisharp-linux-x64-net6.0.tar.gz"
omnisharp_update=false

marksman_url="https://github.com/artempyanykh/marksman/releases/download/2023-07-25/marksman-linux-x64"
marksman_fresh_install=false
marksman_update=false

nvm_url="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh"
nvm_install="false"

tmux_version="3.3a"
tmux_filename="tmux-$tmux_version"
tmux_url="https://github.com/tmux/tmux/releases/download/3.3a/$tmux_filename.tar.gz"
tmux_install=false

nerd_font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Cousine.zip"
nerd_font_filename="Cousine.zip"
add_nerd_font=false

wezterm_url="https://github.com/wez/wezterm/releases/download/20230712-072601-f4abf8fd/wezterm-20230712-072601-f4abf8fd.Ubuntu22.04.deb"
wezterm_filename="wezterm-20230712-072601-f4abf8fd.Ubuntu22.04.deb"
wezterm_install=false

sudo apt-get update -y
sudo apt-get upgrade -y

check_and_install() {
    if dpkg -l | grep -qw "$1"; then
        echo "$1 is already installed."
    else
        echo "$1 is not installed. Installing now..."
        sudo apt-get update
        sudo apt-get install -y "$1"
    fi
}

packages=("build-essential" "xclip" "cmake" "libssl-dev" "libsystemd-dev" "libparted-dev"
    "libicu-dev" "libcairo2" "libcairo2-dev" "libcurl4-openssl-dev" "meson" "libdbus-1-dev"
    "libgirepository1.0-dev" "vlc" "fzf" "fd-find" "ripgrep" "curl" "shellcheck" "python3-pip"
"doxygen" "libmbedtls-dev" "zlib1g-dev" "libevent-dev" "ncurses-dev" "bison" "pkg-config" "gh")

for pkg in "${packages[@]}"; do
    check_and_install "$pkg"
done

if dpkg -l | grep -qw git-all; then
    echo "git-all is already installed."
else
    echo "git-all is not installed. Installing now..."
    sudo apt-get install -y git-all

    git config user.name "Mike J. McGuirk"
    git config user.email "mike.j.mcguirk@gmail.com"
    git config --global credential.helper store
fi

if dpkg -l | grep -qw brave-browser; then
    echo "brave-browser is already installed."
else
    # https://brave.com/linux/
    echo "brave-browser is not installed. Installing now..."
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update
    sudo apt-get install -y brave-browser
fi

if dpkg -l | grep -qw dotnet-sdk-6.0; then
    echo "dotnet-sdk-6.0 is already installed."
else
    # https://docs.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2004-
    echo "dotnet-sdk-6.0 is not installed. Installing now..."
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-6.0
fi

docker_packages=("docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin")
missing_docker_packages=false
for pkg in "${docker_packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $pkg"; then
        echo "Package $pkg is not installed."
        missing_docker_packages=true
    fi
done

if [ "$missing_docker_packages" = true ]; then
    sudo apt-get remove --purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

if [ ! -d ~/.cargo ]; then
    # https://rustup.rs/
    echo "rustup is not installed. Installing now..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

if [ ! -f ~/.cargo/bin/taplo ]; then
    echo "taplo-cli is not installed. Installing now..."
    cargo install --features lsp --locked taplo-cli
fi

if [ ! -f ~/.cargo/bin/cargo-install-update ]; then
    echo "cargo-update is not installed. Installing now..."
    cargo install cargo-update
fi

rustup update
cargo install-update -a

if [ ! -d ~/.local/bin ]; then
    mkdir ~/.local/bin
fi

if $wezterm_install; then
    # https://wezfurlong.org/wezterm/install/linux.html
    curl -LO $wezterm_url
    sudo apt install -y ./$wezterm_filename
    rm ./$wezterm_filename
fi

nvim_update() {
    echo 'Updating NeoVim...'
    wget -P ~/.local/bin $nvim_url
    if [ -d ~/.local/bin/nvim-linux64 ]; then
        rm -rf ~/.local/bin/nvim-linux64
    fi
    mkdir ~/.local/bin/nvim-linux64
    tar xzvf ~/.local/bin/nvim-linux64.tar.gz -C ~/.local/bin
    rm ~/.local/bin/nvim-linux64.tar.gz
}

nvim_fresh_install() {
    nvim_update

    echo 'Cloning NeoVim config...'
    if [ ! -d ~/.config/nvim ]; then
        mkdir ~/.config/nvim
    fi
    git clone https://github.com/mikejmcguirk/Neovim-Win10-Lazy.git ~/.config
    mv ~/.config/Neovim-Win10-Lazy/.* nvim
    mv ~/.config/Neovim-Win10-Lazy/* nvim
    rm -rf ~/.config/Neovim-Win10-Lazy

    ln -s ~/.local/bin/nvim-linux64/bin/nvim ~/.local/bin/nvim
}

if $nvim_fresh_install; then
    nvim_fresh_install
elif $nvim_update; then
    nvim_update
else
    echo 'No actions to take for NeoVim'
fi

lua_ls_update() {
    wget -P ~/.local/bin $lua_ls_url
    if [ -d ~/.local/bin/lua_ls ]; then
        rm -rf ~/.local/bin/lua_ls
    fi
    mkdir ~/.local/bin/lua_ls
    tar xzvf ~/.local/bin/$lua_ls_file -C ~/.local/bin/lua_ls
    rm ~/.local/bin/$lua_ls_file
}

lua_ls_fresh_install() {
    lua_ls_update

    ln -s ~/.local/bin/lua_ls/bin/lua-language-server ~/.local/bin/lua-language-server
}

if $lua_ls_fresh_install; then
    lua_ls_fresh_install
elif $lua_ls_update; then
    lua_ls_update
else
    echo 'lua_ls_update set to false'
fi

omnisharp_update() {
    wget -P ~/.local/bin $omnisharp_url
    if [ -d ~/.local/bin/omnisharp ]; then
        rm -rf ~/.local/bin/omnisharp
    fi
    mkdir ~/.local/bin/omnisharp
    tar xzvf ~/.local/bin/$omnisharp_file -C ~/.local/bin/omnisharp
    rm ~/.local/bin/$omnisharp_file

    echo '{
        "RoslynExtensionsOptions": {
            "enableDecompilationSupport": true
        }
    }' > ~/.local/bin/omnisharp/omnisharp.json
}

if $omnisharp_update; then
    echo "Updating OmniSharp..."
    omnisharp_update
else
    echo 'omnisharp_update set to false'
fi

marksman_update() {
    wget -P ~/.local/bin $marksman_url
    if [ -d ~/.local/bin/marksman_dir ]; then
        rm -rf ~/.local/bin/marksman_dir
    fi
    mkdir ~/.local/bin/marksman_dir
    mv ~/.local/bin/marksman-linux-x64 ~/.local/bin/marksman_dir/marksman-linux-x64
    sudo chmod +x ~/.local/bin/marksman_dir/marksman-linux-x64
}

marksman_fresh_install() {
    marksman_update

    ln -s ~/.local/bin/marksman_dir/marksman-linux-x64 ~/.local/bin/marksman
}

if $marksman_fresh_install; then
    marksman_fresh_install
elif $marksman_update; then
    echo "Updating marksman..."
    marksman_update
else
    echo 'marksman_update set to false'
fi

if $tmux_install; then
    echo "Installing tmux..."
    wget -P ~/.local/bin $tmux_url
    tar -xvzf ~/.local/bin/$tmux_filename.tar.gz
    if [ -d "$tmux_filename" ]; then
        cd "$tmux_filename"
        ./configure
        make && sudo make install
        cd ~

        if [ ! -d ~/.config/tmux/plugins ]; then
            mkdir -p ~/.config/tmux/plugins
        fi
        git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
        git clone https://github.com/wfxr/tmux-power ~/.config/tmux/plugins/tmux-power
    else
        echo "Directory $tmux_filename does not exist."
    fi
fi

if $nvm_install; then
    echo "Installing nvm..."
    wget -qO- $nvm_url | bash
else
    echo 'nvm_install set to false'
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm alias default lts/*

npm i -g npm npm i -g typescript-language-server typescript
npm i -g eslint
npm i -g vscode-langservers-extracted
npm install -g --save-dev prettier

npm install -g dockerfile-language-server-nodejs
npm i -g bash-language-server

pip install python-lsp-server[all]
pip install nvitop
pip install beautysh
pip list --outdated --format=columns | tail -n +3 | awk '{print $1}' | xargs -n1 pip install -U
# pip can brick packages if it cannot resolve dependencies properly during update
# Key packages are manually reinstalled here to ensure they are not broken
pip install python-lsp-server[all]
pip install nvitop
pip install beautysh

if [ ! -d ~/.fonts ]; then
    mkdir ~/.fonts
fi

if $add_nerd_font; then
    # nerdfonts.com
    echo "Adding nerd font..."
    wget -P ~/.fonts $nerd_font_url
    unzip ~/.fonts/$nerd_font_filename -d ~/.fonts
    rm ~/.fonts/$nerd_font_filename
else
    echo 'add_nerd_font set to false'
fi

sudo apt-get autoremove -y
sudo apt-get autoclean -y

# DOTFILES INFO:
#
# https://www.atlassian.com/git/tutorials/dotfiles
#
# INSTALLATION ONLY FOLLOW-UP STEPS:
#
# Verify git user config
# Setup git token
# Enter tmux and install plugins
#
# UPDATE FOLLOW-UP STEPS:
#
# Enter Nvim and run Lazy update
