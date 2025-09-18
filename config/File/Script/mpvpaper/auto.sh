#!/usr/bin/env bash

SOCKET="/tmp/mpv-socket"
CURRENT_MODE=""   # menyimpan state terakhir (360 / 1080)

while true; do
    ACTIVE=$(hyprctl activewindow -j | jq -r '.class')

    if [ "$ACTIVE" != "null" ] && [ -n "$ACTIVE" ]; then
        # Ada window aktif → target resolusi 360
        if [ "$CURRENT_MODE" != "360" ]; then
            echo '{ "command": ["set_property", "vf", ""] }' | socat - $SOCKET
            echo '{ "command": ["set_property", "vf", "scale=640:360:force_original_aspect_ratio=increase,crop=640:360"] }' | socat - $SOCKET
            CURRENT_MODE="360"
            echo "360"
        fi
    else
        # Tidak ada window aktif → target resolusi 1080
        if [ "$CURRENT_MODE" != "1080" ]; then
            echo '{ "command": ["set_property", "vf", ""] }' | socat - $SOCKET
            echo '{ "command": ["set_property", "vf", "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080"] }' | socat - $SOCKET
            CURRENT_MODE="1080"
            echo "1080"
        fi
    fi

    sleep 3
done
