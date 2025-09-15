{ config, lib, pkgs, apps, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true; 
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Bootloader Config
  boot.loader.timeout = 120;
  boot.loader.grub.default = "Shutdown";
  
  # Custom entry
  boot.loader.grub.extraEntries = ''

    menuentry "Shutdown" --class shutdown {
      halt
    }

    menuentry "UEFI" --class efi {
      fwsetup
    }

    menuentry "Fedora" --class fedora {
      insmod part_gpt
      insmod fat
      search --no-floppy --fs-uuid --set=root 99A7-FC90
      chainloader /EFI/fedora/grubx64.efi
    }

  '';
   
  # Grub Theme
  boot.loader.grub.theme = "/etc/nixos/themes/Elegant-wave-window-right-dark";

  # Power
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  # HostName
  networking.hostName = "Tutturuu";

  # Network
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # keyboard
  i18n.inputMethod = {
  type = "fcitx5";
  enable = true;
   fcitx5.addons = with pkgs; [
     fcitx5-mozc
     fcitx5-configtool
   ];
  };

  # Hyprland
  programs.hyprland.enable = true;

  # Lock
  security.pam.services.hyprlock = {
    text = ''
      #%PAM-1.0
      auth       include      login
      account    include      login
    '';
  };


  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.tutturuu = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # Pkgs
    ];
  };

  # terminal
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Tablet
  hardware.opentabletdriver.enable = true;

  # Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Pkgs
  environment.systemPackages = with pkgs; [

  # Tools
    wget
    neofetch
    tmux    
    ydotool
    btop  
    distrobox

  # Better Tools
    eza
    bat

  # Themes
    nwg-look

  # File
    nautilus
    file-roller

  # Hyprland
    kitty
    hyprlock
    wofi
    wlogout
    waybar
    hypridle

  # Sudo
    hyprpolkitagent

  # Clipboard
    wl-clipboard
    cliphist

  # Wallpaper
    mpvpaper

  # Tool mpvpaper
    socat
    jq

  # ss
    grim
    slurp

  # UwU
    pipes
    cava
    cmatrix
    tty-clock

  # Notification
    swaynotificationcenter
    libnotify    

  # App-Image
    appimage-run
    icu

  # Dev
    git
    vscodium
    neovim

  # Flake
    apps.quickshell.packages.x86_64-linux.default

  ];

  # Miror
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
  };


  # flatpak
  services.flatpak.enable = true;

  # Podman
  virtualisation.podman.enable = true;

  # waydroid
  virtualisation.waydroid.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";

  # Version
  system.stateVersion = "25.05";

}

