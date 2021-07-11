# todo.wav
voice to todo.txt (proof of concept)

```
go mod init example.com/humandate
go mod tidy
pip install vosk
curl -LO https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip
unzip vosk-model-small-en-us-0.15.zip
mv vosk-model-small-en-us-0.15 model
sh voicetask.sh
```

TODO: rewrite all in ~~posix shell~~ python/golang
