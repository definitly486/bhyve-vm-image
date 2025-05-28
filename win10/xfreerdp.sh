#!/bin/sh
 X :1 &
export DISPLAY=:1
xfreerdp /u:vcore  /p:639639 /w:1920 /h:1080  /v:192.168.8.108  /drive:home,/home/definitly  /sound
