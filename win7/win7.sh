#!/bin/sh
CD="/home/definitly/Downloads/virtio-win-0.1.240.iso"
HD=/ntfs-2TB/vm/win7/disk.img
USB="5/0/0"
#UEFI=/home/definitly/2TB/vm/win7/BHYVE_UEFI.fd
UEFI=/usr/local/share/uefi-firmware/BHYVE_UEFI.fd
MEM=2G
VM="win7"
IF="tap0"
MAC="mac=00:A0:98:78:32:10"
DPY="w=1918,h=1058"
#-s 2,ahci-cd,$CD \
#truncate -s 15GB windows2016.img
doas  ifconfig $IF up
while true
do
    doas  bhyve \
      -c 2 \
      -s 0,hostbridge \
      -s 3,ahci-hd,$HD,sectorsize=512 \
-s 4,ahci-cd,$CD \
-s 7,fbuf,tcp=0.0.0.0:5900,$DPY \
      -s 8,xhci,tablet \
      -s 10,virtio-net,$IF \
   -s 31,lpc \
 -s 20,hda,play=/dev/dsp,rec=/dev/dsp \
      -l bootrom,$UEFI \
      -m $MEM -w -H   \
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