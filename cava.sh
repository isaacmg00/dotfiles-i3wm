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
bars = 10
bar_spacing = 0
sensitivity = 200
lower_cutoff_freq = 50

[output]
method = raw
channels = mono
raw_target = $pipe

mono_option = average
data_format = ascii
ascii_max_range = 5
bar_delimiter = 5
frame_delimiter = 10

[color]

# Colors can be one of seven predefined: black, blue, cyan, green, magenta, red, white, yellow.
# Or defined by hex code '#xxxxxx' (hex code must be within ''). User defined colors requires
# ncurses output method and a terminal that can change color definitions such as Gnome-terminal or rxvt.
# if supported, ncurses mode will be forced on if user defined colors are used.
# default is to keep current terminal color


[smoothing]

# Percentage value for integral smoothing. Takes values from 0 - 100.
# Higher values means smoother, but less precise. 0 to disable.
noise_reduction = 0.99

# Disables or enables the so-called "Monstercat smoothing" with or without "waves". Set to 0 to disable.

# Set gravity percentage for "drop off". Higher values means bars will drop faster.
# Accepts only non-negative values. 50 means half gravity, 200 means double. Set to 0 to disable "drop off".


# In bar height, bars that would have been lower that this will not be drawn.
; ignore = 0

[eq]

# This one is tricky. You can have as much keys as you want.
# Remember to uncomment more then one key! More keys = more precision.
# Look at readme.md on github for further explanations and examples.

" > $config_file

# run cava in the background
cava -p $config_file &

# reading data from fifo
while read -r cmd; do
    echo $cmd | sed $dict
done < $pipe