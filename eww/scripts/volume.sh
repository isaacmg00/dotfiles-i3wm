#!/bin/bash

STATUS=$(pamixer --get-mute)

if 
		 	[ $STATUS = true ];
	then 
			echo Muted		
else
			echo vol
fi
