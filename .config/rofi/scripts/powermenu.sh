#!/usr/bin/env bash

#rofi_command="rofi -theme themes/powermenu.rasi"
rofi_command="rofi -theme slate_powermenu.rasi"
uptime=$(uptime -p | sed -e 's/up //g')

# Options
shutdown=" Shutdown"
reboot=" Reboot"
suspend=" Suspend"
logout=" Logout"

# Variable passed to rofi
options="$shutdown\n$reboot\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command -dmenu -i -p "")"
case $chosen in
    $shutdown)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $suspend)
        systemctl suspend && slock
        ;;
    $logout)
        echo 'awesome.quit()' | awesome-client
        ;;
esac

