#!/bin/bash
BTID=$(bluetoothctl devices | cut -f2 -d' ' | while read uuid; 
do bluetoothctl info $uuid; 
done|grep -e "Name" | cut -d ":" -f2)

STATUS=$(bluetoothctl devices | cut -f2 -d' ' | while read uuid; do bluetoothctl info $uuid; done|grep -e "Connected" | cut -d ":" -f2)
if 
	[ $BTID = "WI-XB400" ];
then 
	echo "Sony XB400"

elif 
	[ $STATUS = "yes" ]
then
	echo "$BTID"

else 
	echo "No device connected"
fi