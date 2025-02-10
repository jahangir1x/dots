#!/usr/bin/env bash

############ Variables ############
enable_battery=false
battery_charging=false
battery_charging_and_full=false

####### Check availability ########
for battery in /sys/class/power_supply/*BAT*; do
  if [[ -f "$battery/uevent" ]]; then
    enable_battery=true
    if [[ $(cat /sys/class/power_supply/*BAT*/status | head -1) == "Charging" ]]; then
      battery_charging=true
    elif [[ $(cat /sys/class/power_supply/*BAT*/status | head -1) == "Full" ]]; then
      battery_charging_and_full=true
    fi
    break
  fi
done

############# Output #############
if [[ $enable_battery == true ]]; then
  battery_percentage=$(cat /sys/class/power_supply/*/capacity | head -1)
  if [[ $battery_charging_and_full == true ]]; then
    echo -n "󱟢 ${battery_percentage}%";
  elif [[ $battery_charging == true ]]; then
    echo -n "󰂄 ${battery_percentage}%!"
  elif [[ $battery_charging == false ]]; then
    echo -n "󰂃 ${battery_percentage}%!"
  fi
fi

echo ''