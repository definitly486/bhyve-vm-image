#!/bin/sh
mkdir -p /usr/local/etc/win7
cp win7.conf  /usr/local/etc/win7
cp win7vm  /usr/local/bin
cp win7_vm /usr/local/bin
cp win7.desktop /home/definitly/.local/share/applications
chown -R definitly:wheel  /home/definitly/.local/share/applications/win7.desktop 