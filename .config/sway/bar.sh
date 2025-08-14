#!/usr/bin/env bash

WIFI_INTERFACE="wlp1s0f0"
WIFI_INFO=$(iw dev "$WIFI_INTERFACE" link)

if [[ "$WIFI_INFO" == "Not connected." ]]; then
	WIFI_STATUS="WIFI –"
else
	SSID=$(echo "$WIFI_INFO" | grep SSID | cut -d' ' -f2-)
	WIFI_STATUS="WIFI $SSID"
fi

BATTERY=$(cat /sys/class/power_supply/macsmc-battery/capacity)
BATTERY_STATUS="BAT ${BATTERY}%"

DATE="$(LC_TIME=it_IT.UTF-8 date +'%e %b %H:%M' | sed 's/^ *//')"

VOLUME_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOLUME=$(echo "$VOLUME_RAW" | awk '{print int($2 * 100)}')
if echo "$VOLUME_RAW" | grep -q '\[MUTED\]'; then
	VOLUME_STATUS="VOL –"
else
	VOLUME_STATUS="VOL ${VOLUME}%"
fi

WEATHER_STATUS=$(cat /tmp/weather)

echo "$WEATHER_STATUS  |  $VOLUME_STATUS  |  $WIFI_STATUS  |  $BATTERY_STATUS  |  $DATE"
