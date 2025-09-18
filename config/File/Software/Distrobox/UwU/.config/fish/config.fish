if status is-interactive
	
	# Home
	clear
	cd 
	/home/tutturuu/Documents/Cli-Art/art-anime-cli.sh 16	

	# Alias

	alias Config-Fish="nano ~/.config/fish/config.fish"
	alias Reload-Fish="source ~/.config/fish/config.fish"
	alias Reload-Fish-Clean="clear && cd && source ~/.config/fish/config.fish"

	alias Subtitle='/home/tutturuu/File/Script/subtitle/subtitle-setting.sh'

	# Func
	# Scrcpy
function SCRCPY
    set -gx PATH $PATH /home/tutturuu/File/Software/platform\ tools\ latest\ linux/platform-tools
    set -gx PATH $PATH /home/tutturuu/File/Software/scrcpy/scrcpy-linux-x86_64-v3.3.2

    alias ADBconnect="/home/tutturuu/File/Script/adb/adbconnect"
    alias TCPconnect="/home/tutturuu/File/Script/adb/tcp.sh"
    alias scrmore="bash /home/tutturuu/File/Script/adb/scrcpymore.sh"

    set_color -o cyan; echo "Available Apps"; set_color normal
    echo -n " • "; set_color yellow; echo "Scrcpy"; set_color normal

    echo -n "   ├── "; set_color cyan; echo "ADBconnect"; set_color normal
    echo -n "   ├── "; set_color cyan; echo "TCPconnect"; set_color normal
    echo -n "   ├── "; set_color cyan; echo "scrcpy"; set_color normal
    echo -n "   └── "; set_color cyan; echo "scrmore"; set_color normal

    echo -n "        ├── "; set_color red; echo "novideo"; set_color normal
    echo -n "        ├── "; set_color red; echo "novirtual"; set_color normal
    echo -n "        ├── "; set_color red; echo "justinput"; set_color normal
    echo -n "        ├── "; set_color red; echo "inputandaudio"; set_color normal
    echo -n "        ├── "; set_color red; echo "vlc"; set_color normal
    echo -n "        └── "; set_color red; echo "other code"; set_color normal
    echo ""
end


	# Starship
	starship init fish | source

end
