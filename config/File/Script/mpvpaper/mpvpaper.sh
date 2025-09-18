#!/usr/bin/env bash

# Path folder awal playlist
PLAYLIST_DIR="$HOME/playlist"
VIDEO_DIR="$HOME/Videos/Wallpaper"
SOCKET_PATH="/tmp/mpv-socket"
OUTPUT_NAME="HDMI-A-1"

# Base mpv options
BASE_OPTS="--vf=scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080 mute=yes volume=30 input-ipc-server=$SOCKET_PATH"


# Fungsi navigasi folder dan pilih file .m3u
choose_media_file() {
    local root_dir="$1"
    local mode="$2"   # "playlist" atau "video"
    local current_dir="$root_dir"

    while true; do
        # Ambil daftar folder & file sesuai mode, urut terbaru (mtime)
        mapfile -t folders < <(find "$current_dir" -mindepth 1 -maxdepth 1 -type d \
            -printf "%T@ %f/\n" | sort -rn | cut -d' ' -f2-)

        if [[ "$mode" == "playlist" ]]; then
            mapfile -t files < <(find "$current_dir" -mindepth 1 -maxdepth 1 \( -type f -o -type l \) -iname "*.m3u" \
  	    -printf "%T@ %f\n" | sort -rn | cut -d' ' -f2-)
        else
            mapfile -t files < <(find "$current_dir" -mindepth 1 -maxdepth 1 -type f \
                \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.avi" -o -iname "*.mov" \) \
                -printf "%T@ %f\n" | sort -rn | cut -d' ' -f2-)
        fi

        entries=()

        # Kalau di root_dir → tombol kembali ke menu utama
        if [[ "$current_dir" == "$root_dir" ]]; then
            entries+=("🔙 Kembali ke menu utama")
        else
            entries+=("🔙 ../")
        fi

        # File dulu, baru folder
        if [[ "$mode" == "playlist" ]]; then
            for f in "${files[@]}"; do entries+=("📜 $f"); done
        else
            for f in "${files[@]}"; do entries+=("🎬 $f"); done
        fi
        for d in "${folders[@]}"; do entries+=("📁 $d"); done

        # Menu wofi
        selected=$(printf "%s\n" "${entries[@]}" | wofi --dmenu --insensitive --prompt "Pilih file / folder")
        [[ -z "$selected" ]] && return 1

        clean_selected="${selected#* }" # hapus ikon

        if [[ "$clean_selected" == "Kembali ke menu utama" ]]; then
            return 2
        elif [[ "$clean_selected" == "../" ]]; then
            current_dir=$(dirname "$current_dir")
        elif [[ "$clean_selected" == */ ]]; then
            current_dir="$current_dir/${clean_selected%/}"
        else
            echo "$current_dir/$clean_selected"
            return 0
        fi
    done
}


# --- Fungsi stop mpvpaper ---
stop_mpvpaper() {
    PIDS=$(pgrep -f "mpvpaper -o")
    if [ -n "$PIDS" ]; then
        echo "Menemukan proses mpvpaper dengan PID: $PIDS"
        echo "Menghentikan proses..."
        for PID in $PIDS; do
            pkill -TERM -P "$PID" 2>/dev/null
            kill "$PID" 2>/dev/null
        done
        echo "Proses mpvpaper telah dihentikan."
    else
        echo "Tidak ada proses mpvpaper yang berjalan."
    fi
}



# --- Mode argumen langsung ---
if [[ "$1" == "kill" ]]; then
    stop_mpvpaper
    exit 0

elif [[ "$1" == "videoplay" && -n "$2" ]]; then
    ARG_PATH="$2"
    [[ ! -f "$ARG_PATH" ]] && { echo "File video tidak ditemukan: $ARG_PATH"; exit 1; }
    SELECTED="$ARG_PATH"
    MPV_OPTS="$BASE_OPTS --loop"

elif [[ "$1" == "playlistplay" && -n "$2" ]]; then
    ARG_PATH="$2"
    [[ ! -f "$ARG_PATH" ]] && { echo "File playlist tidak ditemukan: $ARG_PATH"; exit 1; }
    SELECTED="$ARG_PATH"
    MPV_OPTS="$BASE_OPTS --loop-playlist"

elif [[ "$1" == "wofiinput" ]]; then
    current_dir="$HOME"

    while true; do
        entries=("⌨️ Input manual path" "🔙 ../")

        # Tambah folder (skip hidden)
        mapfile -t folders < <(find "$current_dir" -mindepth 1 -maxdepth 1 -type d \
            ! -name '.*' -printf "%f/\n" | sort)
        for d in "${folders[@]}"; do
            entries+=("📂 $d")
        done

        # Tambah semua file (skip hidden)
        mapfile -t files < <(find "$current_dir" -mindepth 1 -maxdepth 1 -type f \
            ! -name '.*' -printf "%f\n" | sort)
        for f in "${files[@]}"; do
            case "$f" in
                *.m3u) entries+=("📜 $f") ;;
                *.mp4|*.mkv|*.webm|*.avi|*.mov) entries+=("🎬 $f") ;;
                *) entries+=("📄 $f") ;;  # file lain tetap ditampilkan
            esac
        done

        selected=$(printf "%s\n" "${entries[@]}" | wofi --dmenu --insensitive --prompt "Pilih file / folder / input manual")
        [[ -z "$selected" ]] && exit 0

        clean_selected="${selected#* }"

        case "$clean_selected" in
            "Input manual path")
                INPUT_PATH=$(wofi --dmenu --insensitive --prompt "Masukkan path lengkap file")
                [[ -z "$INPUT_PATH" ]] && exit 0
                [[ ! -f "$INPUT_PATH" ]] && { echo "Path tidak valid: $INPUT_PATH"; exit 1; }
                ;;
            "../")
                current_dir=$(dirname "$current_dir")
                continue
                ;;
            */)
                current_dir="$current_dir/${clean_selected%/}"
                continue
                ;;
            *)
                INPUT_PATH="$current_dir/$clean_selected"
                ;;
        esac

        # Validasi file
        case "$INPUT_PATH" in
            *.m3u|*.M3U)
                exec "$0" playlistplay "$INPUT_PATH"
                ;;
            *.mp4|*.mkv|*.webm|*.avi|*.mov|*.MP4|*.MKV|*.WEBM|*.AVI|*.MOV)
                exec "$0" videoplay "$INPUT_PATH"
                ;;
            *)
                echo "Format file tidak didukung, keluar..."
                exit 1
                ;;
        esac
    done

else
    # --- Menu awal pilih playlist atau video ---
    choice=$(printf "Playlist\nVideo" | wofi --dmenu --insensitive --prompt "Pilih sumber") || exit 1

    if [[ "$choice" == "Playlist" ]]; then
        SELECTED=$(choose_media_file "$PLAYLIST_DIR" "playlist")
        [[ $? -eq 2 ]] && exec "$0" # kembali ke menu utama
        [[ -z "$SELECTED" ]] && { echo "Batal menjalankan mpvpaper. Tidak ada playlist dipilih."; exit 0; }
        MPV_OPTS="$BASE_OPTS --loop --loop-playlist"
    elif [[ "$choice" == "Video" ]]; then
        SELECTED=$(choose_media_file "$VIDEO_DIR" "video")
        [[ $? -eq 2 ]] && exec "$0"
        [[ -z "$SELECTED" ]] && { echo "Batal menjalankan mpvpaper. Tidak ada video dipilih."; exit 0; }
        MPV_OPTS="$BASE_OPTS --loop"
    else
        echo "Pilihan tidak valid."
        exit 0
    fi
fi


stop_mpvpaper


# Jalankan mpvpaper dengan playlist terpilih
echo "Menjalankan mpvpaper dengan playlist: $SELECTED"
mpvpaper -o "$MPV_OPTS" "$OUTPUT_NAME" "$SELECTED"


