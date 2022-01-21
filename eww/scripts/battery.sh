#!/bin/bash

STATE=$(upower -i $(upower -e | grep BAT) | grep --color=never -E "state" | cut -d ":" -f2 | xargs)
PERCENT=$(upower -i $(upower -e | grep BAT) | grep --color=never -E "percentage" | cut -d ":" -f2 | xargs)


echo "${STATE} : ${PERCENT}"
			
