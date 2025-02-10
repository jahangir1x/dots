#!/bin/bash
CONFIG_FILES="$HOME/.config/ags"
STATE_FILES="$HOME/.local/state/ags"

trap "killall ags" EXIT

while true; do
    ags &
    inotifywait -r --exclude '\.git' -e create,modify $CONFIG_FILES $STATE_FILES/scss/_material.scss
    killall ags
done
