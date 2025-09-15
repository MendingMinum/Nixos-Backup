  # VirtualBox
  boot.blacklistedKernelModules = [ "kvm" "kvm_amd" "kvm_intel" ];
  
  # virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "tutturuu" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;
