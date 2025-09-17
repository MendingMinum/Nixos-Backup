#!/usr/bin/env bash

# Ambil info window aktif dalam JSON
ACTIVE_WIN=$(hyprctl activewindow -j)

# Cek apakah ada window aktif
if [ -z "$ACTIVE_WIN" ] || [ "$ACTIVE_WIN" == "null" ]; then
    echo "Tidak ada window aktif."
    exit 1
fi

# Ambil class dan title
WIN_CLASS=$(echo "$ACTIVE_WIN" | jq -r '.class')
WIN_TITLE=$(echo "$ACTIVE_WIN" | jq -r '.title')

echo "Window aktif:"
echo "Class: $WIN_CLASS"
echo "Title: $WIN_TITLE"

# Pilihan opacity
OPTIONS="1\n0.9\n0.8\n0.7\n0.5\n0.3\n0.2\n0.1"

# Tampilkan wofi untuk pilih opacity
CHOICE=$(echo -e $OPTIONS | wofi --dmenu --prompt "Pilih opacity:")

if [ -z "$CHOICE" ]; then
    echo "Tidak ada pilihan opacity."
    exit 1
fi

# Tanyakan apakah mau pakai title juga
TITLE_OPTION=$(echo -e "Ya\nTidak" | wofi --dmenu --prompt "Gunakan title juga?")

if [ "$TITLE_OPTION" == "Ya" ]; then
    RULE="opacity $CHOICE, class:$WIN_CLASS, title:$WIN_TITLE"
else
    RULE="opacity $CHOICE, class:$WIN_CLASS"
fi

echo "Menerapkan rule: $RULE"

# Terapkan windowrulev2
hyprctl keyword windowrulev2 "$RULE"

