#! /bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# make sure to clean pipe
pipe="/tmp/cava.fifo"
if [ -p $pipe ]; then
    unlink $pipe
fi
mkfifo $pipe

# write cava config
config_file="/tmp/polybar_cava_config"
echo "
[general]
framerate = 60
mode = normal
bars = 7
bar_spacing = 0

[output]
method = raw
channels = mono
raw_target = $pipe

mono_option = average
data_format = ascii
ascii_max_range = 7
bar_delimiter = 5
; frame_delimiter = 10

[color]

# Colors can be one of seven predefined: black, blue, cyan, green, magenta, red, white, yellow.
# Or defined by hex code '#xxxxxx' (hex code must be within ''). User defined colors requires
# ncurses output method and a terminal that can change color definitions such as Gnome-terminal or rxvt.
# if supported, ncurses mode will be forced on if user defined colors are used.
# default is to keep current terminal color
;background = default
;foreground = default

gradient = 0
gradient_count = 8
gradient_color_1 = '#59cc33'
gradient_color_2 = '#80cc33'
gradient_color_3 = '#a6cc33'
gradient_color_4 = '#cccc33'
gradient_color_5 = '#cca633'
gradient_color_6 = '#cc8033'
gradient_color_7 = '#cc5933'
gradient_color_8 = '#cc3333'


[smoothing]

# Percentage value for integral smoothing. Takes values from 0 - 100.
# Higher values means smoother, but less precise. 0 to disable.
;integral = 0

# Disables or enables the so-called "Monstercat smoothing" with or without "waves". Set to 0 to disable.
;monstercat = 0
;waves = 20

# Set gravity percentage for "drop off". Higher values means bars will drop faster.
# Accepts only non-negative values. 50 means half gravity, 200 means double. Set to 0 to disable "drop off".
gravity = 200


# In bar height, bars that would have been lower that this will not be drawn.
; ignore = 0

[eq]

# This one is tricky. You can have as much keys as you want.
# Remember to uncomment more then one key! More keys = more precision.
# Look at readme.md on github for further explanations and examples.
#1 = 5 # bass
#2 = 10
#3 = 10 # midtone
#4 = 10
#5 = 5# treble


" > $config_file

# run cava in the background
cava -p $config_file &

# reading data from fifo
while read -r cmd; do
    echo $cmd | sed $dict
done < $pipe