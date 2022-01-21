#!/bin/bash
SSID=$(iwgetid -r)
STATUS=$(nmcli device status | grep -m1 "wlp4s0" | awk '{print $3}')

if 
	[ $STATUS = "connected" ];
then 
	echo "$SSID"
else 
	echo "No Internet"
fi
