Configuration Live 1

-- nixos-install

Configuration default

-- nixos-rebuild switch

Configuration 33

-- nixos-rebuild switch --flake /etc/nixos#Tutturuu

Configuration 38

Make swapfile
-- sudo fallocate -l 8G /swapfile
-- sudo chmod 600 /swapfile
-- sudo mkswap /swapfile
And add to configuration
