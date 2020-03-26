#!/bin/sh

test=`xrandr | grep " connected " | wc -l`

if [ $test -eq 2 ]
then
	xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output eDP-1 --mode 1280x720 --pos 1920x360 --rotate normal
	echo 'awesome.restart()' | awesome-client
else
	xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
	echo 'awesome.restart()' | awesome-client
fi
