# 🚀 Backup NixOS

Install, History Configuration, Config

---

## 📦 Download ISO

Use the minimal version:  

nixos-minimal-25.05.809451.fe83bbdde2cc-x86_64-linux.iso

🔗 Download here: https://nixos.org/download/

---

## 💿 Boot via USB

- Create a bootable USB (e.g., using **Ventoy**).  
- Boot from the USB into the NixOS minimal live environment.  

---

## 🌐 Initial Setup

1. **Internet Connection** (make sure you can `ping google.com`)  
2. **Disk Setup** with **GPT scheme**:  
    - `boot` → **EFI**   
    - `/root` → **LUKS (encrypted)**  

      References:  
      - NixOS Installation Manual: https://nixos.org/manual/nixos/stable/#sec-installation-manual  
      - LUKS Setup: https://nixos.org/manual/nixos/stable/#ch-file-systems  
      - Persoanl Backup Docs: 
      ---

      ## ⚙️ First Configuration

      Use the initial configuration file:  

      Configuration/Nix-config-raw/configuration-live-1.nix

      ---

      ## ▶️ Install & Reboot

      1. Run the installation process following the manual.  
      2. Reboot into your new NixOS system with encryption enabled.  

      ---

      ✨ Done! You now have a **minimal NixOS backup setup** ready to use.


3. **History Configuration And Config everything is stored in this repo**
