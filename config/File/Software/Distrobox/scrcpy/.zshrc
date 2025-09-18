# Created by newuser for 5.9
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh


export PATH="$PATH:/home/tutturuu/File/Software/platform tools latest linux/platform-tools"

export PATH="$PATH:/home/tutturuu/File/Software/scrcpy/scrcpy-linux-x86_64-v3.3.2"


alias ADBconnect='/home/tutturuu/File/Script/adb/adbconnect'
alias TCPconnect='/home/tutturuu/File/Script/adb/tcp.sh'
alias scrmore='bash /home/tutturuu/File/Script/adb/scrcpymore.sh'

Homebasic() {
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    CYAN='\033[0;36m'
    MAGENTA='\033[0;35m'
    BOLD='\033[1m'
    NC='\033[0m' # No Color


    echo -e "${BOLD}${CYAN}Available Apps${NC}"
   echo -e " • ${YELLOW}Scrcpy${NC}"
	echo -e "${YELLOW}   ├──${NC} ${CYAN}ADBconnect${NC}"
        echo -e "${YELLOW}   ├──${NC} ${CYAN}TCPconnect${NC}"
	echo -e "${YELLOW}   ├──${NC} ${CYAN}scrcpy${NC}"
	echo -e "${YELLOW}   └──${NC} ${CYAN}scrmore${NC}"
	echo -e "        ${YELLOW} ├──${NC} ${RED}novideo${NC}"
	echo -e "        ${YELLOW} ├──${NC} ${RED}novirtual${NC}"
	echo -e "        ${YELLOW} ├──${NC} ${RED}justinput${NC}"
	echo -e "        ${YELLOW} ├──${NC} ${RED}inputandaudio${NC}"
	echo -e "        ${YELLOW} ├──${NC} ${RED}vlc${NC}"
	echo -e "        ${YELLOW} └──${NC} ${RED}other code${NC}"
    echo ""
}

Homebasic

eval "$(starship init zsh)"

