#!/bin/sh

if test "$(id -u)" -ne 0; then
	printf "%s must be run as root\n" "${0##*/}"
	exit 1
fi

 for i in $(ifconfig | grep tap | awk '{print $1}' | grep tap | sed 's/:[^:]*$//'); do

         ifconfig  $i destroy 

      done