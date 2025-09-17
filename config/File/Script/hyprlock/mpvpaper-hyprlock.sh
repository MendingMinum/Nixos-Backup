#!/usr/bin/env bash

PID_FILE="/tmp/wallpaper.pid"
MONITOR="HDMI-A-1"
VIDEO_DIR="/home/tutturuu/Videos/Wallpaper"

# Cek apakah dipanggil dengan argumen
if [[ "$1" == "videopath" && -n "$2" ]]; then
    VIDEO="$2"
    SKIP_EFFECTS=true
else
# Cari semua file video di folder
mapfile -t FILES < <(find "$VIDEO_DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) -printf '%T@ %p\n' \
    | sort -nr | cut -d' ' -f2-)

# Buat daftar untuk wofi: hanya nama file + icon 🎬
MENU=$(for f in "${FILES[@]}"; do
    name=$(basename "$f")
    echo "🎬 $name"
done | wofi --dmenu --prompt "Pilih Video Wallpaper:")

# Kalau tidak memilih apa pun, keluar
[ -z "$MENU" ] && exit 0

# Cari path asli dari nama yang dipilih
VIDEO=""
for f in "${FILES[@]}"; do
    if [[ "🎬 $(basename "$f")" == "$MENU" ]]; then
        VIDEO="$f"
        break
    fi
done

SKIP_EFFECTS=false


fi



# Kalau tidak memilih apa pun, keluar
[ -z "$VIDEO" ] && exit 0

MPV_OPTS='--title=mpvpaperhyprlock volume=100 --loop-playlist shuffle --vf=scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080'

if [ "$SKIP_EFFECTS" = false ]; then
    MIRROR=$(printf "🎚️ Tidak\n🪞 Mirror Horizontal\n🔇 Mute\n🔇🪞 Mute Miror\n🚫🎶 Tanpa Audio Visual" | wofi --dmenu --prompt "Efek")

    [ "$MIRROR" = "🪞 Mirror Horizontal" ] && MPV_OPTS="$MPV_OPTS,hflip"
    [ "$MIRROR" = "🔇 Mute" ] && MPV_OPTS="mute=yes ,$MPV_OPTS"
    [ "$MIRROR" = "🔇🪞 Mute Miror" ] && MPV_OPTS="mute=yes ,$MPV_OPTS,hflip"

    [ "$MIRROR" = "🚫🎶 Tanpa Audio Visual" ] && NO_AUDIO_VISUAL=true
fi


# Hentikan wallpaper lama jika ada
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if kill "$OLD_PID" 2>/dev/null; then
        rm "$PID_FILE"
    fi
fi

hyprctl dispatch workspace 21

mpvpaper -o "$MPV_OPTS" "$MONITOR" "$VIDEO" -f &

# Tunggu proses mpv muncul lalu simpan PID-nya
sleep 0.5
PID=$(pgrep -f "mpv.*mpvpaperhyprlock" | head -n 1)
echo "$PID" > "$PID_FILE"

: > /tmp/lockscreenstyle.log


if [ "$NO_AUDIO_VISUAL" != true ]; then
    kitty --class kitty-audio --config /home/tutturuu/File/Script/kitty/kitty-transparant.conf -e cava &
    KITTY_AUDIO_PID=$!
fi

sleep 0.5

kitty --class kitty-overlay --config /home/tutturuu/File/Script/kitty/kitty-log.conf -e sh -c "sleep 1 && tail -n +1 -f /tmp/lockscreenstyle.log" &

KITTY_OVERLAY_PID=$!

stdbuf -oL -eL hyprlock -c /home/tutturuu/File/Script/hyprlock/hyprlock-terminal.conf >> /tmp/lockscreenstyle.log 2>&1 &

# Simpan PID hyprlock
HYPRLOCK_PID=$!

wait $HYPRLOCK_PID

kill "$KITTY_AUDIO_PID" 2>/dev/null
kill "$KITTY_OVERLAY_PID" 2>/dev/null

if [ -f "$PID_FILE" ]; then
    kill "$(cat "$PID_FILE")" 2>/dev/null
    rm "$PID_FILE"
fi


hyprctl dispatch workspace empty
