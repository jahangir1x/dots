#!/bin/bash

# start video
# mpv --no-audio --no-input-default-bindings --no-osc --no-osd-bar --no-border --no-window-dragging --no-keepaspect --no-resume-playback --no-input-cursor --no-sub --no-config --no-quiet --no-stop-screensaver --no-input-terminal --no-input-cursor --no-input-vo-keyboard --fs --loop ~/Videos/lock.mp4

if [ "$#" -ne 1 ]; then
    echo "Usage $0 (static|dynamic)"
    exit 1
fi

monitor_count=$(hyprctl monitors -j | jq length)
background_type=$1

start_video() {
    vlc --qt-minimal-view --no-interact --no-osd --no-audio --no-video-title-show --fullscreen --loop --video-on-top ~/Videos/lock.mp4 &
    sleep 0.5
}

start_picture() {
    feh --zoom fill ~/Pictures/lock.png &
    sleep 0.25
    hyprctl dispatch fullscreen
}

start_lock_background() {
    if [[ $background_type == "static" ]]; then
        start_picture
    elif [[ $background_type == "dynamic" ]]; then
        start_video
    else
        echo "Usage $0 (static|dynamic)"
        exit 1
    fi
}


if [ $monitor_count -eq 1 ]; then
    start_lock_background
    hyprlock
    pkill vlc
    pkill feh
    exit 0
fi

hyprctl dispatch workspace 1
start_lock_background

hyprctl dispatch workspace 2
start_lock_background

hyprlock
pkill vlc
pkill feh