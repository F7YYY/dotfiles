#!/usr/bin/env bash

text="$(curl https://v2.wttr.in/?format=1 | sed 's/ +//g')"
tooltip="$(curl https://v2.wttr.in/?0QT |
    sed 's/\\/\\\\/g' |
    sed ':a;N;$!ba;s/\n/\\n/g' |
    sed 's/"/\\"/g')"
echo "{\"text\": \"${text}\", \"tooltip\": \"<tt>${tooltip}</tt>\", \"class\": \"weather\"}"
