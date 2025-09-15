#!/usr/bin/env bash
# backup-nixos.sh

# --- Folders relative to current directory ---
BACKUP_DIR="./latest-configuration"
CONFIG_DIR="./Configuration"
RAW_DIR="$CONFIG_DIR/Nix-config-raw"

# --- Step 1: Backup all NixOS configuration ---
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
cp -r /etc/nixos/* "$BACKUP_DIR"
echo "NixOS configuration backup completed at $BACKUP_DIR"

# --- Step 2: Copy configuration.nix & flake.nix to Configuration (overwrite) ---
FILES=("configuration.nix" "flake.nix")

for file in "${FILES[@]}"; do
    if [ -f "$BACKUP_DIR/$file" ]; then
        cp "$BACKUP_DIR/$file" "$CONFIG_DIR/"
        echo "File $file successfully copied to $CONFIG_DIR"
    else
        echo "File $file not found in $BACKUP_DIR"
    fi
done

# --- Step 3: Copy to Nix-config-raw with automatic numbering ---
mkdir -p "$RAW_DIR"

# Find the last number from configuration files in RAW_DIR
LAST_NUM=$(ls "$RAW_DIR"/configuration*.nix 2>/dev/null | \
           sed -E 's/.*configuration([0-9]+)\.nix/\1/' | \
           sort -n | tail -1)

# If no files exist, start from 1
if [ -z "$LAST_NUM" ]; then
    LAST_NUM=0
fi

NEXT_NUM=$((LAST_NUM + 1))

# Copy with new names
cp "$CONFIG_DIR/configuration.nix" "$RAW_DIR/configuration${NEXT_NUM}.nix"
cp "$CONFIG_DIR/flake.nix" "$RAW_DIR/flake${NEXT_NUM}.nix"

echo "Files configuration.nix & flake.nix successfully copied to $RAW_DIR as configuration${NEXT_NUM}.nix & flake${NEXT_NUM}.nix"

