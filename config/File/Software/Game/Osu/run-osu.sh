#!/usr/bin/env bash
ICU_PATH=$(ls -d /nix/store/*icu4c-*/lib | head -n1)

if [ -z "$ICU_PATH" ]; then
  echo "not found"
  exit 1
fi

export LD_LIBRARY_PATH="$ICU_PATH:$LD_LIBRARY_PATH"

# jalankan osu AppImage
exec appimage-run "/home/tutturuu/File/Software/Game/Osu/osu.AppImage" 
