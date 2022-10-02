#!/bin/bash

i3status | while :
do
	read line
	command=`xset -q | grep Caps | awk '{print $4}' | tr xargs -r`
	echo " CAPS: $command | $line" || exit 1
done
