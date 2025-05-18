#!/bin/sh
#CD=/home/definitly/Downloads/Bliss-v15.9.2-x86_64-OFFICIAL-gapps-20241012.iso
HD=/home/definitly/2TB/vm/android-blissos/disk0.img
USB="5/0/0"
UEFI=/usr/local/share/uefi-firmware/BHYVE_UEFI.fd
MEM=6G
VM="q4s"
IF="tap0"
MAC="mac=00:A0:98:78:32:10"
DPY="w=1918,h=1058"
#-s 2,ahci-cd,$CD \
#truncate -s 15GB windows2016.img
doas  ifconfig $IF up
while true
do
    doas  bhyve \
      -c 1 \
      -s 0,hostbridge \
      -s 3,ahci-hd,$HD,sectorsize=512 \
-s 5,fbuf,tcp=0.0.0.0:5900,$DPY \
      -s 6,xhci,tablet \
      -s 10,virtio-net,$IF \
      -s 20,hda,play=/dev/dsp,rec=/dev/dsp \
      -s 31,lpc \
      -l bootrom,$UEFI \
      -m $MEM -H -w -A \
      $VM

    RES=$?
    doas  bhyvectl --destroy --vm=$VM
    if [ $RES -eq 1 ]
    then
        exit 1
    fi
    echo sleeping for 5 sec...
    sleep 5
done