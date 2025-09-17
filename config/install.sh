#!/usr/bin/env bash

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Path custom plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Clone plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  $ZSH_CUSTOM/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-completions \
  $ZSH_CUSTOM/plugins/zsh-completions

git clone https://github.com/zsh-users/zsh-history-substring-search \
  $ZSH_CUSTOM/plugins/zsh-history-substring-search



# Flakpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.mozilla.firefox

flatpak install flathub com.valvesoftware.Steam

flatpak install flathub com.github.xournalpp.xournalpp

flatpak install flathub org.gnome.baobab

flatpak install flathub org.gnome.Loupe

# Link
mkdir -p ~/Downloads
mkdir -p ~/File/Software/Distrobox/UwU
mkdir -p ~/File/Software/Distrobox/scrcpy

mkdir -p ~/File/Software/Distrobox/UwU/.config/fish/


ln -s /home/tutturuu/Downloads /home/tutturuu/File/Software/Distrobox/UwU/Downloads

ln -s /home/tutturuu/Downloads /home/tutturuu/File/Software/Distrobox/Scrcpy/Downloads

ln -s /home/tutturuu/File/Software/Distrobox/UwU/.config/fish/config.fish /home/tutturuu/File/Software/Distrobox/scrcpy/.config/fish/config.fish

ln -s /home/tutturuu/File/Software/Distrobox/UwU/.config/starship.toml /home/tutturuu/File/Software/Distrobox/scrcpy/.config/starship.toml
