#!/bin/sh
 X :1 &
export DISPLAY=:1
xfreerdp /u:vcore  /p:639639 /w:1918 /h:1045  /v:192.168.8.104  /drive:home,/home/definitly  /sound
