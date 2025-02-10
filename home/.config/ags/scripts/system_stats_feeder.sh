#!/bin/bash

SHARED_FILE="/dev/shm/system_stats"

update() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$(( sum + i ))
    done
    cache=${XDG_CACHE_HOME:-$HOME/.cache}/${1##*/}
    [ -f "$cache" ] && read -r old < "$cache" || old=0
    printf %d\\n "$sum" > "$cache"
    printf %d\\n $(( sum - old ))
}

while true; do
    ram_usage_bytes=$(LANG=C free -b | awk '/^Mem/ {print $3}')
    ram_percentage=$(LANG=C free | awk '/^Mem/ {printf("%04.1f", ($3/$2) * 100)}')
    ram_total=$(printf "%4sB\\n" $(numfmt --to=iec $ram_usage_bytes) | sed "s/ /\<s\>/g")

    swap_percentage=$(LANG=C free | awk '/^Swap/ {if ($2 > 0) printf("%04.1f", ($3/$2) * 100); else print "00.0";}')
    swap_total=0

    cpu_percentage=$(LANG=C top -bn1 | grep Cpu | awk '{printf("%04.1f", $2)}')
    cpu_total=0

    rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
    download_percentage=100
    download_total=$(printf "%4sB\\n" $(numfmt --to=iec $rx) | sed "s/ /\<s\>/g")
    
    tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)
    upload_percentage=100
    upload_total=$(printf "%4sB\\n" $(numfmt --to=iec $tx) | sed "s/ /\<s\>/g")

    cat <<EOF > $SHARED_FILE
$ram_percentage
$ram_total
$swap_percentage
$swap_total
$cpu_percentage
$cpu_total
$download_percentage
$download_total
$upload_percentage
$upload_total
EOF
    sleep 1
done