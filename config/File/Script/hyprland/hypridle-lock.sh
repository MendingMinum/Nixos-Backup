#!/usr/bin/env bash

LOG_FILE="/tmp/lockscreenstyle.log"
LOCK_SCRIPT="$HOME/File/Script/hyprlock/mpvpaper-hyprlock.sh"
VIDEO="$HOME/Videos/Wallpaper/santai-hijau-lofi.mp4"
           
# Cek apakah hyprlock sedang berjalan
if pgrep -x hyprlock > /dev/null; then
    echo "[LOG] Lockscreen is already active." >> "$LOG_FILE"
    exit 0
fi

# Kalau tidak aktif, jalankan lockscreen
"$LOCK_SCRIPT" videopath "$VIDEO"

