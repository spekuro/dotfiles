#!/usr/bin/env bash

#rofi_command="rofi -theme themes/powermenu.rasi"
rofi_command="rofi -theme slate_xrandr.rasi"

# Options
mono=" Mono screen"
dual=" Dual Screen"
tv=" TV"

# Variable passed to rofi
options="$mono\n$dual\n$tv"

chosen="$(echo -e "$options" | $rofi_command -dmenu -i -p "")"
case $chosen in
    $mono)
        xrandr --output eDP1 --primary --mode 1366x768 --pos 0x0 --rotate normal
#				echo 'awesome.restart()' | awesome-client
        ;;
    $dual)
				xrandr --output eDP1 --mode 1366x768 --pos 1920x312 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
#				echo 'awesome.restart()' | awesome-client
        ;;
    $tv)
        xrandr --output HDMI-1 --primary --mode 640x480 --pos 0x0 --rotate normal
#        echo 'awesome.restart()' | awesome-client
        ;;
esac

