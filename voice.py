#!/usr/bin/env python3

import vosk
import sys
import os
import wave
import json
import subprocess

vosk.SetLogLevel(-1)

if not os.path.exists("./model"):
    print ("Please download the model from https://alphacephei.com/vosk/models and unpack as 'model' in the current folder.")
    exit (1)

sample_rate=48000
model = vosk.Model("./model")
rec = vosk.KaldiRecognizer(model, sample_rate)

process = subprocess.Popen(['ffmpeg', '-loglevel', 'quiet', '-i',
                            '/tmp/vosk_out.wav',
                            '-ar', str(sample_rate) , '-ac', '1', '-f', 's16le', '-'],
                            stdout=subprocess.PIPE)

result = ""
while True:
    data = process.stdout.read(4000)
    if len(data) == 0:
        break
    if rec.AcceptWaveform(data):
        data = json.loads(rec.Result())
        result += data['text']
        result += " "

#print(result) 
data = json.loads(rec.FinalResult())
result += data['text']
print("\n")
print(result)
with open("/tmp/vosk_out.txt", "w+") as text_file:
    text_file.write(result)
