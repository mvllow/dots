#!/usr/bin/env bash

while true; do
	echo $(curl -s "wttr.in?m&format=%c%t") >/tmp/weather
	sleep 900 # 15 minutes
done
