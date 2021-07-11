#!/bin/sh
BASEDIR=$(dirname "$0")
echo "Say and press Ctrl+C"
rm /tmp/vosk_out.txt 2>/dev/null
rm /tmp/vosk_out.wav 2>/dev/null
arecord -fdat /tmp/vosk_out.wav 2>/dev/null
echo "You can hide this window"
python $BASEDIR/voice.py
file="$(cat /tmp/vosk_out.txt)"
rm /tmp/vosk_out.txt
rm /tmp/vosk_out.wav

datename="$($BASEDIR/humandate "$file" | tail -n1 | sed 's/^ *//;s/[[:blank:]]\+$//')"
date="$($BASEDIR/humandate "$file" | head -n1 | awk '{print $1}')"


priority=$(echo "$file" | grep -Pio '(?:medium|urgent|high|low) priority|priority (?:medium|urgent|high|low)')
context=$(echo "$file" | grep -Pio 'context.? \w+' | sed 's/context.\? /@/' | tr '\n' ' ' | sed 's/[[:blank:]]\+$//')
project=$(echo "$file" | grep -Pio 'project.? \w+' | sed 's/project.\? /+/' | tr '\n' ' ' | sed 's/[[:blank:]]\+$//')

task="$(echo "$file")"
[ ! -z "$datename" ] && task=$(echo "$task" | sed "s/$datename//" )
[ ! -z "$priority" ] && task=$(echo "$task" | sed "s/$priority//" )

task=$(echo "$task" | sed "s/context.\? [[:alnum:]]\+//g;s/project.\? [[:alnum:]]\+//g;s/[[:blank:]]\+/ /g")
priority=$(echo "$priority"  | sed 's/ \?priority.\? \?//;s/urgent/(A)/;s/high/(B)/;s/medium/(C)/;s/low/(D)/')
[ "$date" ] && due="due:"
[ -z "$project" ] && project="+random"
echo
echo "$priority $task $context $project ${due}${date}" | sed 's/^ *//;s/[[:blank:]]\+/ /g;s/[[:blank:]]\+$//'
echo "$priority $task $context $project ${due}${date}" | sed 's/^ *//;s/[[:blank:]]\+/ /g;s/[[:blank:]]\+$//' >> $HOME/todo.txt
sleep 10
