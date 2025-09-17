#!/usr/bin/env bash
# backup-nixos.sh

# === Directories ===
BACKUP_DIR="./latest-configuration"
CONFIG_DIR="./Configuration"
RAW_DIR="$CONFIG_DIR/Nix-config-raw"
CONFIG_BACKUP_DIR="./config"   # untuk personal configs

# === Functions ===

# --- Option 1: Backup NixOS system configuration ---
backup_system() {
    echo "[*] Starting NixOS system backup..."

    rm -rf "$BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    cp -r /etc/nixos/* "$BACKUP_DIR"
    echo "✅ NixOS configuration backup completed at $BACKUP_DIR"

    FILES=("configuration.nix" "flake.nix")
    for file in "${FILES[@]}"; do
        if [ -f "$BACKUP_DIR/$file" ]; then
            cp "$BACKUP_DIR/$file" "$CONFIG_DIR/"
            echo "✅ File $file copied to $CONFIG_DIR"
        else
            echo "⚠️  File $file not found in $BACKUP_DIR"
        fi
    done

    mkdir -p "$RAW_DIR"
    LAST_NUM=$(ls "$RAW_DIR"/configuration*.nix 2>/dev/null | \
               sed -E 's/.*configuration([0-9]+)\.nix/\1/' | \
               sort -n | tail -1)

    if [ -z "$LAST_NUM" ]; then
        LAST_NUM=0
    fi
    NEXT_NUM=$((LAST_NUM + 1))

    cp "$CONFIG_DIR/configuration.nix" "$RAW_DIR/configuration${NEXT_NUM}.nix"
    cp "$CONFIG_DIR/flake.nix" "$RAW_DIR/flake${NEXT_NUM}.nix"

    echo "✅ Files saved to $RAW_DIR as configuration${NEXT_NUM}.nix & flake${NEXT_NUM}.nix"
}

# --- Option 2: Backup personal dotfiles/configs ---
backup_config() {
    echo "[*] Starting personal config backup..."

    declare -A FILES_TO_COPY=(
        ["/home/tutturuu/.tmux.conf"]="$CONFIG_BACKUP_DIR"
        ["/home/tutturuu/.zshrc"]="$CONFIG_BACKUP_DIR"
        ["/home/tutturuu/.icons"]="$CONFIG_BACKUP_DIR"
        ["/home/tutturuu/.themes"]="$CONFIG_BACKUP_DIR"
        ["/home/tutturuu/.local/share/fonts"]="$CONFIG_BACKUP_DIR/.local/share"
        ["/home/tutturuu/Documents/Cli-Art"]="$CONFIG_BACKUP_DIR/Documents"
        ["/home/tutturuu/File/Script"]="$CONFIG_BACKUP_DIR/File"
        ["/home/tutturuu/.config/hypr"]="$CONFIG_BACKUP_DIR/.config"
        ["/home/tutturuu/.config/kitty"]="$CONFIG_BACKUP_DIR/.config"
        ["/home/tutturuu/.config/nvim"]="$CONFIG_BACKUP_DIR/.config"
        ["/home/tutturuu/.config/swaync"]="$CONFIG_BACKUP_DIR/.config"
    )

    for SRC in "${!FILES_TO_COPY[@]}"; do
        DEST="${FILES_TO_COPY[$SRC]}"
        mkdir -p "$DEST"
        if [ -e "$SRC" ]; then
            cp -r "$SRC" "$DEST/"
            echo "✅ Copied $SRC -> $DEST/"
        else
            echo "⚠️  Skipped $SRC (not found)"
        fi
    done

    echo "✅ Personal config backup completed at $CONFIG_BACKUP_DIR"
}

# === Menu ===
echo "=== NixOS Backup Script ==="
echo "1) Backup system nix (/etc/nixos)"
echo "2) Backup personal configs (dotfiles, themes, etc)"
echo "q) Quit"
echo "==========================="

read -rp "Choose an option: " choice

case "$choice" in
    1) backup_system ;;
    2) backup_config ;;
    q|Q) echo "Exiting..." ;;
    *) echo "Invalid option" ;;
esac

