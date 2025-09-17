#!/usr/bin/env bash

# ambil data client (workspace id + class)
clients=$(hyprctl clients -j | jq -r '.[] | "\(.workspace.id) \(.class)"')

# declare counter per workspace
declare -A counters
declare -A entries

ICON="🖥️"   # ganti sesuai selera, contoh lain: 🪟

# kumpulkan semua window
while read -r ws class; do
    # skip workspace negatif (-98, -99)
    if [[ $ws -lt 0 ]]; then
        continue
    fi

    counters[$ws]=$(( ${counters[$ws]} + 1 ))

    if [[ ${counters[$ws]} -gt 1 ]]; then
        label="${ws}-${counters[$ws]}: ${ICON} ${class}"
    else
        label="${ws}: ${ICON} ${class}"
    fi

    entries["$ws,${counters[$ws]}"]="$label"
done <<< "$clients"

# urutkan workspace (numerik)
menu=""
for key in $(printf "%s\n" "${!entries[@]}" | sort -t, -k1,1n -k2,2n); do
    menu+="${entries[$key]}"$'\n'
done

# tampilkan di wofi
choice=$(echo -n "$menu" | wofi --dmenu --prompt "Workspace/App")

# ambil workspace id dari pilihan
ws=$(echo "$choice" | cut -d: -f1 | cut -d- -f1)

# pindah ke workspace itu
hyprctl dispatch workspace "$ws"

