#!/bin/bash
# ~/.tmux/battery.sh

status=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | sed 's/    state:               //g')
percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | sed 's/    percentage:          //g')

if [ $status == "discharging" ]; then
	printf -- "$percentage%"
elif [ $status == "fully-charged" ]; then
	printf -- "$status"
else
	printf -- "$status:$percentage%"
fi

