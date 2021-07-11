#!/bin/sh
BASEDIR=$(dirname "$0")
source $BASEDIR/config
if [ $fj ] ; then
  fj="firejail --quiet --net=none"
fi
echo "Say and press Ctrl+C"
rm /tmp/vosk_out.txt 2>/dev/null
rm /tmp/vosk_out.wav 2>/dev/null
arecord -fdat /tmp/vosk_out.wav 2>/dev/null
echo "You can hide this window"
$fj python $BASEDIR/voice.py
file="$(cat /tmp/vosk_out.txt)"
rm /tmp/vosk_out.txt
rm /tmp/vosk_out.wav

echo "$file" | sed 's/^ *//;s/[[:blank:]]\+/ /g;s/[[:blank:]]\+$//'
echo "$file" | sed 's/^ *//;s/[[:blank:]]\+/ /g;s/[[:blank:]]\+$//' >> $HOME/.notes
