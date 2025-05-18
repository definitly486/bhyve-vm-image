#!/bin/sh
mkdir -p /usr/local/etc/win10
cp win10.conf  /usr/local/etc/win10
cp win10vm  /usr/local/bin
cp win10_vm /usr/local/bin
cp win10.desktop /home/definitly/.local/share/applications
chown -R definitly:wheel  /home/definitly/.local/share/applications/win10.desktop 