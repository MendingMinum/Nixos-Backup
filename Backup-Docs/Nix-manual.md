From https://nixos.org/manual/nixos/stable/#sec-installation-manual

Manual Installation

NixOS can be installed on BIOS or UEFI systems. The procedure for a UEFI installation is broadly the same as for a BIOS installation. The differences are mentioned in the following steps.

The NixOS manual is available by running nixos-help in the command line or from the application menu in the desktop environment.

To have access to the command line on the graphical images, open Terminal (GNOME) or Konsole (Plasma) from the application menu.

You are logged-in automatically as nixos. The nixos user account has an empty password so you can use sudo without a password:

sudo -i

You can use loadkeys to switch to your preferred keyboard layout. (We even provide neo2 via loadkeys de neo!)

If the text is too small to be legible, try setfont ter-v32n to increase the font size.

To install over a serial port connect with 115200n8 (e.g. picocom -b 115200 /dev/ttyUSB0). When the bootloader lists boot entries, select the serial console boot entry.
Networking in the installer

The boot process should have brought up networking (check ip a). Networking is necessary for the installer, since it will download lots of stuff (such as source tarballs or Nixpkgs channel binaries). It’s best if you have a DHCP server on your network. Otherwise configure networking manually using ifconfig.

On the graphical installer, you can configure the network, wifi included, through NetworkManager. Using the nmtui program, you can do so even in a non-graphical session. If you prefer to configure the network manually, disable NetworkManager with systemctl stop NetworkManager.

On the minimal installer, NetworkManager is not available, so configuration must be performed manually. To configure the wifi, first start wpa_supplicant with sudo systemctl start wpa_supplicant, then run wpa_cli. For most home networks, you need to type in the following commands:

add_network
0

set_network 0 ssid "myhomenetwork"
OK

set_network 0 psk "mypassword"
OK

enable_network 0
OK

For enterprise networks, for example eduroam, instead do:

add_network
0

set_network 0 ssid "eduroam"
OK

set_network 0 identity "myname@example.com"
OK

set_network 0 password "mypassword"
OK

enable_network 0
OK

When successfully connected, you should see a line such as this one

<3>CTRL-EVENT-CONNECTED - Connection to 32:85:ab:ef:24:5c completed [id=0 id_str=]

you can now leave wpa_cli by typing quit.

If you would like to continue the installation from a different machine you can use activated SSH daemon. You need to copy your ssh key to either /home/nixos/.ssh/authorized_keys or /root/.ssh/authorized_keys (Tip: For installers with a modifiable filesystem such as the sd-card installer image a key can be manually placed by mounting the image on a different machine). Alternatively you must set a password for either root or nixos with passwd to be able to login.
Partitioning and formatting

The NixOS installer doesn’t do any partitioning or formatting, so you need to do that yourself.

The NixOS installer ships with multiple partitioning tools. The examples below use parted, but also provides fdisk, gdisk, cfdisk, and cgdisk.

Use the command ‘lsblk’ to find the name of your ‘disk’ device.

The recommended partition scheme differs depending if the computer uses Legacy Boot or UEFI.


UEFI (GPT)

Here’s an example partition scheme for UEFI, using /dev/sda as the device.
Note

You can safely ignore parted’s informational message about needing to update /etc/fstab.

    Create a GPT partition table.

    parted /dev/sda -- mklabel gpt

    Add the root partition. This will fill the disk except for the end part, where the swap will live, and the space left in front (512MiB) which will be used by the boot partition.

    parted /dev/sda -- mkpart root ext4 512MB -8GB

    Next, add a swap partition. The size required will vary according to needs, here a 8GB one is created.

    parted /dev/sda -- mkpart swap linux-swap -8GB 100%

    Note

    The swap partition size rules are no different than for other Linux distributions.

    Finally, the boot partition. NixOS by default uses the ESP (EFI system partition) as its /boot partition. It uses the initially reserved 512MiB at the start of the disk.

    parted /dev/sda -- mkpart ESP fat32 1MB 512MB

        parted /dev/sda -- set 3 esp on

            Note

                In case you decided to not create a swap partition, replace 3 by 2. To be sure of the id number of ESP, run parted --list.

                Once complete, you can follow with the section called “Formatting”.



Formatting

Use the following commands:

    For initialising Ext4 partitions: mkfs.ext4. It is recommended that you assign a unique symbolic label to the file system using the option -L label, since this makes the file system configuration independent from device changes. For example:

    mkfs.ext4 -L nixos /dev/sda1

    For creating swap partitions: mkswap. Again it’s recommended to assign a label to the swap partition: -L label. For example:

    mkswap -L swap /dev/sda2

    UEFI systems

    For creating boot partitions: mkfs.fat. Again it’s recommended to assign a label to the boot partition: -n label. For example:

        mkfs.fat -F 32 -n boot /dev/sda3

            For creating LVM volumes, the LVM commands, e.g., pvcreate, vgcreate, and lvcreate.

                For creating software RAID devices, use mdadm.

                Installing

                    Mount the target file system on which NixOS should be installed on /mnt, e.g.

                    mount /dev/disk/by-label/nixos /mnt

                    UEFI systems

                    Mount the boot file system on /mnt/boot, e.g.

                    mkdir -p /mnt/boot

                    mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

                    If your machine has a limited amount of memory, you may want to activate swap devices now (swapon device). The installer (or rather, the build actions that it may spawn) may need quite a bit of RAM, depending on your configuration.

                    swapon /dev/sda2

                    You now need to create a file /mnt/etc/nixos/configuration.nix that specifies the intended configuration of the system. This is because NixOS has a declarative configuration model: you create or edit a description of the desired configuration of your system, and then NixOS takes care of making it happen. The syntax of the NixOS configuration file is described in Configuration Syntax, while a list of available configuration options appears in Appendix A. A minimal example is shown in Example: NixOS Configuration.

                    This command accepts an optional --flake option, to also generate a flake.nix file, if you want to set up a flake-based configuration.

                    The command nixos-generate-config can generate an initial configuration file for you:

                    nixos-generate-config --root /mnt

                    You should then edit /mnt/etc/nixos/configuration.nix to suit your needs:

                    nano /mnt/etc/nixos/configuration.nix

                    If you’re using the graphical ISO image, other editors may be available (such as vim). If you have network access, you can also install other editors – for instance, you can install Emacs by running nix-env -f '<nixpkgs>' -iA emacs.

                    BIOS systems

                        You must set the option boot.loader.grub.device to specify on which disk the GRUB boot loader is to be installed. Without it, NixOS cannot boot.

                            If there are other operating systems running on the machine before installing NixOS, the boot.loader.grub.useOSProber option can be set to true to automatically add them to the grub menu.
                            UEFI systems

                                You must select a boot-loader, either systemd-boot or GRUB. The recommended option is systemd-boot: set the option boot.loader.systemd-boot.enable to true. nixos-generate-config should do this automatically for new configurations when booted in UEFI mode.

                                    You may want to look at the options starting with boot.loader.efi and boot.loader.systemd-boot as well.

                                        If you want to use GRUB, set boot.loader.grub.device to nodev and boot.loader.grub.efiSupport to true.

                                            With systemd-boot, you should not need any special configuration to detect other installed systems. With GRUB, set boot.loader.grub.useOSProber to true, but this will only detect windows partitions, not other Linux distributions. If you dual boot another Linux distribution, use systemd-boot instead.

                                            If you need to configure networking for your machine the configuration options are described in Networking. In particular, while wifi is supported on the installation image, it is not enabled by default in the configuration generated by nixos-generate-config.

                                            Another critical option is fileSystems, specifying the file systems that need to be mounted by NixOS. However, you typically don’t need to set it yourself, because nixos-generate-config sets it automatically in /mnt/etc/nixos/hardware-configuration.nix from your currently mounted file systems. (The configuration file hardware-configuration.nix is included from configuration.nix and will be overwritten by future invocations of nixos-generate-config; thus, you generally should not modify it.) Additionally, you may want to look at Hardware configuration for known-hardware at this point or after installation.
                                            Note

                                            Depending on your hardware configuration or type of file system, you may need to set the option boot.initrd.kernelModules to include the kernel modules that are necessary for mounting the root file system, otherwise the installed system will not be able to boot. (If this happens, boot from the installation media again, mount the target file system on /mnt, fix /mnt/etc/nixos/configuration.nix and rerun nixos-install.) In most cases, nixos-generate-config will figure out the required modules.

                                            Do the installation:

                                            nixos-install

                                            This will install your system based on the configuration you provided. If anything fails due to a configuration problem or any other issue (such as a network outage while downloading binaries from the NixOS binary cache), you can re-run nixos-install after fixing your configuration.nix.

                                            If you opted for a flake-based configuration, you will need to pass the --flake here as well and specify the name of the configuration as used in the flake.nix file. For the default generated flake, this is nixos.

                                            nixos-install --flake 'path/to/flake.nix#nixos'

                                            As the last step, nixos-install will ask you to set the password for the root user, e.g.

                                            setting root password...
                                            New password: ***
                                            Retype new password: ***

                                            If you have a user account declared in your configuration.nix and plan to log in using this user, set a password before rebooting, e.g. for the alice user:

                                            nixos-enter --root /mnt -c 'passwd alice'

                                            Note

                                            For unattended installations, it is possible to use nixos-install --no-root-passwd in order to disable the password prompt entirely.

                                            If everything went well:

                                            reboot

                                            You should now be able to boot into the installed NixOS. The GRUB boot menu shows a list of available configurations (initially just one). Every time you change the NixOS configuration (see Changing Configuration), a new item is added to the menu. This allows you to easily roll back to a previous configuration if something goes wrong.

                                            Use your declared user account to log in. If you didn’t declare one, you should still be able to log in using the root user.
                                            Note

                                            Some graphical display managers such as SDDM do not allow root login by default, so you might need to switch to TTY. Refer to User Management for details on declaring user accounts.

                                            You may also want to install some software. This will be covered in Package Management.
