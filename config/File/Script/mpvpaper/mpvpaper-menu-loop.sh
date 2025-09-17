#!/usr/bin/env bash

SCRIPT_PATH="$HOME/File/Script/mpvpaper/mpvpaper-menu.sh"


while true; do
    # Jalankan script utama dan ambil output
    selection=$("$SCRIPT_PATH")

    # Jika user tekan Esc di wofi (output kosong), keluar loop
    if [ -z "$selection" ]; then
        break
    fi
done
