export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh


# Zsh history config 
HISTFILE=~/.zsh_history
HISTSIZE=1000000        
SAVEHIST=1000000        

# History behavior
setopt APPEND_HISTORY         
setopt INC_APPEND_HISTORY     
setopt SHARE_HISTORY          
setopt HIST_IGNORE_ALL_DUPS   
setopt HIST_SAVE_NO_DUPS      
setopt HIST_REDUCE_BLANKS     

# Func

# Tmux
new-attach() {
  if [ -z "$1" ]; then
    echo "Usage: new-attach <session_name>"
    return 1
  fi
  tmux new -A -s "$1"
}

# setup-ssh-agent <path_to_private_key>
function setup-ssh-agent() {
    if [[ -z "$1" ]]; then
        echo "Usage: setup-ssh-agent <path_to_private_key>"
        return 1
    fi

    local key="$1"

    eval "$(ssh-agent -s)"

    ssh-add "$key"
}


# Hddex
hddex-mount() {
  sudo cryptsetup open /dev/disk/by-uuid/e9fbaedb-8ff8-4631-a5a7-f3feea2d3fc6 hddex_crypt
  sudo mount /dev/mapper/hddex_crypt /home/tutturuu/File/Software/HDD/hddex
  echo "HDDex mounted"
}

hddex-umount() {
  sudo umount /home/tutturuu/File/Software/HDD/hddex
  sudo cryptsetup close hddex_crypt
  echo "HDDex umounted"
}


# Hyprland
switch-workspace() {
  if [ -z "$1" ]; then
    echo "Usage: switch-workspace <number>"
    return 1
  fi

  hyprctl dispatch workspace "$1"
}

Float-Setup() {

  hyprctl dispatch workspace special:magic

  # Term1: clock
  kitty --class Term1 sh -c "tty-clock -c -C 6 -B; exec bash" >/dev/null 2>&1 &
  sleep 0.2

  # Term2: cava
  kitty --class Term2 sh -c "cava; exec bash" >/dev/null 2>&1 &
  sleep 0.2

  # Term 3: zsh
  kitty --class Term3 >/dev/null 2>&1 & 
  sleep 0.5

  # Resize Term1
  hyprctl dispatch focuswindow class:^Term1$
  hyprctl dispatch resizeactive exact 50% 30%

}

# Style

neofetch() {
  if [[ $# -eq 0 ]]; then
    command neofetch --ascii ~/Documents/Cli-Art/neofetch/neofetch6
  elif [[ "$1" =~ ^[1-5]$ ]]; then
    command neofetch --ascii ~/Documents/Cli-Art/neofetch/neofetch$1
  elif [[ "$1" == "6" ]]; then
    command neofetch "$@"
  else
    command neofetch "$@"
  fi
}

# Tools

function type-idle() {
    local repeat=${1:-7}
    local cooldown=${2:-500}
    
    for i in $(seq 1 $repeat); do
        ydotool type "idle"
        if [ $i -lt $repeat ]; then
            remaining=$cooldown
            while [ $remaining -gt 0 ]; do
                echo -ne "Cooldown: $remaining S\r"
                sleep 10
                remaining=$((remaining-10))
            done
            echo # pindah baris setelah cooldown selesai
        fi
    done
}

# Home

Homebasic() {
    # Warna ANSI
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    CYAN='\033[0;36m'
    MAGENTA='\033[0;35m'
    BOLD='\033[1m'
    NC='\033[0m' # No Color


    echo -e "${BOLD}${CYAN}Available Apps${NC}"
    echo -e " • ${YELLOW}podman${NC}"
    echo -e " • ${YELLOW}nvim${NC}"
#   echo -e " • ${YELLOW}Scrcpy${NC}"
#	echo -e "${YELLOW}   ├──${NC} ${CYAN}adbconnect${NC}"
#	echo -e "${YELLOW}   ├──${NC} ${CYAN}scrcpy${NC}"
#	echo -e "${YELLOW}   └──${NC} ${CYAN}scrmore${NC}"
#	echo -e "        ${YELLOW} ├──${NC} ${RED}novideo${NC}"
#	echo -e "        ${YELLOW} ├──${NC} ${RED}novirtual${NC}"
#	echo -e "        ${YELLOW} ├──${NC} ${RED}justinput${NC}"
#	echo -e "        ${YELLOW} ├──${NC} ${RED}inputandaudio${NC}"
#	echo -e "        ${YELLOW} ├──${NC} ${RED}vlc${NC}"
#	echo -e "        ${YELLOW} └──${NC} ${RED}other code${NC}"
    echo ""
}


# User
#~/Documents/Cli-Art/user.sh
#Homebasic

~/Documents/Cli-Art/start-art.sh

# Alias

# Zshrc Config
alias Reload='cd && clear && source ~/.zshrc'
alias Reload-Here='clear && source ~/.zshrc'
alias Reload-Here-Keep='source ~/.zshrc'

# Bios
alias RebootToBios='systemctl reboot --firmware-setup'

# Nix Config
alias NIXConfig='sudo nano /etc/nixos/configuration.nix'
alias NIXReload='sudo nixos-rebuild switch'
alias NIXHistory='sudo nix-env --list-generations --profile /nix/var/nix/profiles/system'

# Style
alias audiofx=cava
alias clock="tty-clock -c -C 6 -B"

# Hyprland
alias Start-Hyprland='hyprland'
alias Floatpanel='hyprctl dispatch togglespecialworkspace magic'

# Vol
alias VolNow='wpctl get-volume @DEFAULT_AUDIO_SINK@'
alias VolUp='/home/tutturuu/File/Script/audio/vol.sh up'
alias VolDown='/home/tutturuu/File/Script/audio/vol.sh down'

# Hyprlock
alias unlock='pkill -USR1 hyprlock'

# App
alias Tabletdriver="systemctl --user start opentabletdriver.service"

# Waydroid
alias droidstop='waydroid session stop && waydroid status'
alias droidstatus='waydroid status'



