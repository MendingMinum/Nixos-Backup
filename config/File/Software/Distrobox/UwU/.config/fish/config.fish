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

	# Starship
	starship init fish | source

end
