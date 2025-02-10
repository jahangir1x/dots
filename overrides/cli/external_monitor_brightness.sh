#!/bin/bash

command="$1"
step="$2"

if [ "$command" == "reset" ]; then
    ddccontrol -r 0x10 -w 10 dev:/dev/i2c-0 | grep -oP "Control 0x1.: \+/\K\d+(?=/)" > $HOME/.local/override/external_brightness
    brightnes=$(cat $HOME/.local/override/external_brightness)
    ddccontrol -r 0x12 -w ${brightnes} dev:/dev/i2c-0 > /dev/null
    echo "External: $brightnes"

elif [ "$command" == "inc" ]; then
    ddccontrol -r 0x10 -W +${step} dev:/dev/i2c-0 | grep -oP "Control 0x1.: \+/\K\d+(?=/)" > $HOME/.local/override/external_brightness
    brightnes=$(cat $HOME/.local/override/external_brightness)
    ddccontrol -r 0x12 -w ${brightnes} dev:/dev/i2c-0 > /dev/null
    echo "External: $brightnes"

elif [ "$command" == "dec" ]; then
    ddccontrol -r 0x10 -W -${step} dev:/dev/i2c-0 | grep -oP "Control 0x1.: \+/\K\d+(?=/)" > $HOME/.local/override/external_brightness
    brightnes=$(cat $HOME/.local/override/external_brightness)
    ddccontrol -r 0x12 -w ${brightnes} dev:/dev/i2c-0 > /dev/null
    echo "External: $brightnes"
    
else
    echo "Usage: $0 [inc|dec] <step>"
    echo "       $0 reset"
    exit 1
fi
