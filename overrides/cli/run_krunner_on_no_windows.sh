#!/bin/bash
# get number of opened windows
windows=$(wmctrl -l | wc -l)

# open krunner if no windows are opened
if [ $windows -eq 0 ]; then
    krunner --replace
fi
